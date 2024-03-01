require('dotenv').config();

const express = require("express");
const app = express();
const port = 3000;
const path = require("path");
const bcrypt = require("bcrypt");
const jwt = require('jsonwebtoken');

app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));
app.use(express.static(path.join(__dirname, "public")));
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// mysql2
const mysql = require("mysql2");
const { error } = require("console");

const connection = mysql.createConnection({
  host: "localhost",
  user: "root",
  database: "GlamSphereDB",
  password: "sql123",
  port: "3306",
});

app.get("/home", (req, res) => {
  let queryReviews =
    "SELECT r.RName, r.EmailID, r.Content, u.imagePath FROM StoreReviews r JOIN Users u ON r.EmailID = u.EmailID;";
  connection.query(queryReviews, (errReviews, resultReviews) => {
    if (errReviews) {
      console.log(errReviews);
      res.send("some error in Database");
    } else {
      // console.log(resultReviews);
      let queryProducts =
        "SELECT productid, pname, price, category, quantityAvailable, imagePath FROM products ORDER BY quantityAvailable DESC LIMIT 4;";
      connection.query(queryProducts, (errProducts, resultProducts) => {
        if (errProducts) {
          console.log(errProducts);
          res.send("Some error in fetching products from the database");
        } else {
          // console.log(resultProducts);

          res.render("index.ejs", {
            reviews: resultReviews,
            products: resultProducts,
          });
        }
      });
    }
  });
});

app.get("/products", (req, res) => {
  const queryString = req.query.category;
  let queryProducts = "";
  if(!queryString) {
    queryProducts = "SELECT productid, pname, price, category, quantityAvailable FROM products;";
  }
  else {
    queryProducts = "SELECT productid, pname, price, category, quantityAvailable FROM products WHERE MainCategory = ?;";
  }
 
  connection.query(queryProducts,[queryString], (errProducts, resultProducts) => {
    if (errProducts) {
      console.log(errProducts);
      res.send("Some error in fetching products from the database");
    } else {
      // console.log(resultProducts);
      res.render("products.ejs", { products: resultProducts });
    }
  });
});

app.get("/products/view", (req,res) => {
  const pid = req.query.pid;
  console.log(pid);
  res.render("viewproduct.ejs");
});


app.post("/cart", (req,res) => {
  console.log(req.body);
    let userid = parseInt(req.body.userid);
    let query = 
      "SELECT c.CartItemID, c.ProductID, c.UserID, p.PName, p.Price,p.imagePath, c.quantity FROM Cart c,Products p where c.productid = p.productid and c.userid=1;";
    try {
      connection.query(query, [userid], (errCart, resultCart) => {
        if (errCart) {
          console.log(errCart);
          res.send("some error with database");
        } else {
          console.log(resultCart);
          // if(resultCart == 0) 
          res.render("cart.ejs", { cartItems: resultCart });
        }
      });
    } catch (err) {
      console.log(err);
      res.redirect("/home");
    }
  
});

app.post("/addtocart", (req, res) => {
  console.log(req.body);
  let query = "SELECT CartItemID, Quantity FROM Cart WHERE ProductID = ? AND UserID = ? ;";
  let details = [req.body.userid, req.body.productid];
  connection.query(query, details, (errItem, resItem) => {
      if (errItem) {
          console.log(errItem);
          res.status(500).send("Internal Server Error");
      } else {
          console.log(resItem);
          if (resItem.length === 0) {
              let queryAddCart = "INSERT INTO CART(UserID, ProductID, Quantity) VALUES (?,?,1);";
              connection.query(queryAddCart, details, (errAddCart, resAddCart) => {
                  if (errAddCart) {
                      console.log(errAddCart);
                      res.status(500).send("Internal Server Error");
                  } else {
                      res.status(200).send("Added to cart");
                      console.log("Added to cart");
                  }
              });
          } else {
              let currentQuantity = resItem[0].Quantity;
              let queryUpdateCart = "UPDATE Cart SET Quantity = ? WHERE UserID = ? AND ProductID = ?;";
              connection.query(queryUpdateCart, [currentQuantity + 1, req.body.userid, req.body.productid], (errUpdateCart, resUpdateCart) => {
                  if (errUpdateCart) {
                      console.log(errUpdateCart);
                      res.status(500).send("Internal Server Error");
                  } else {
                      res.status(200).send("Cart updated");
                      console.log("Cart updated");
                  }
              });
          }
      }
  });
});

// checkout
app.get("/checkout" , (req,res) => {
  console.log("you have enetered checkout section");
  console.log(req.query);
  return res.status(200).json({ success: true, message: 'checkedout sucessfully' });
});

app.get("/orderplaced",(req,res) => {
  res.render("orderSuccess.ejs");
});



// Signup routes
app.get("/signup", (req, res) => {
  res.render("signup.ejs");
});

app.post("/user/signup", async (req, res) => {
  try {
    const hashedPassword = await bcrypt.hash(req.body.password, 10);
    console.log(req.body);
    console.log(hashedPassword);
    let user = req.body;
    user.password = hashedPassword;

    let signupQuery = `INSERT INTO Users (FirstName, LastName, EmailID, Username, PasswordHash, Phone, UserRole, UserAddress) VALUES (?,?,?,?,?,?,'Customer',?)`;
    let userArray = Object.values(user);

    connection.query(signupQuery, userArray, (errSignup, resultSignup) => {
      if (errSignup) {
        console.log(errSignup.sqlMessage);
        res.redirect(
          "/signup?alert=" + encodeURIComponent(errSignup.sqlMessage)
        );
      } else {
        res.redirect("/home");
      }
    });
  } catch (err) {
    res.redirect("/signup?alert=" + encodeURIComponent(err));
  }
});


// Login routes
app.get("/login", (req, res) => {
  res.render("login.ejs");
});

app.post("/user/login", async (req, res) => {
  const username = req.body.username;
    const password = req.body.password;
  try {
    queryLogin = `SELECT * FROM Users WHERE username = ? ;`;
    connection.query(queryLogin,[username], async (errLogin, resultLogin) => {
      if (errLogin) {
        console.log(errLogin);
        // res.send("error with login");
        return res.status(500).json({ success: false, message: 'An error occurred' });
      } else {
        if (resultLogin.length == 0) {
          return res.status(404).json({ success: false, message: 'User not found' });
        } else {
          console.log(resultLogin);
          let hashedPassword = resultLogin[0].PasswordHash;
          let isPasswordMatch = await bcrypt.compare(password, hashedPassword);
          if (isPasswordMatch) {
            // success in login
            let user = resultLogin[0];
            console.log(user);
            return res.status(200).json({ success: true, message: 'Authentication successful', user });
          } else {
            res.status(401).json({ success: false, message: 'Incorrect password' });
          }
        }
      }
    });
  } catch (err){
    console.log(err);
    res.redirect("/login");
  }
});


// about our website
app.get("/about", (req,res) => {
  res.render("about.ejs");
});

// contact us route

app.get("/contact", (req,res) => {
  res.render("contact.ejs");
});

app.get("/getintouch", (req,res) => {
  res.render("get-in-touch.ejs");
});

app.post("/getintouch/post",(req,res) => {
  console.log(req.body);
  let reviewPost = req.body;
  let query = `SELECT * FROM USERS WHERE emailid = ? ;`;
  try {connection.query(query, [reviewPost.email],(err,results) => {
    if(err) {
      console.log(err);
      res.send("Some errors happened please try again");
    }
    else {
      console.log(results);
    }
  })} catch (err){
    console.log(err);
    res.redirect("/getintouch");
  }
  
});



app.listen(port, () => {
  console.log(`server listening to port ${port}`);
});
