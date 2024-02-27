const express = require("express");
const app = express();
const port = 3000;
const path = require("path");
const bcrypt = require("bcrypt");

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
    "SELECT r.UserID, r.ReviewComment, u.UserName FROM Reviews R JOIN Users u ON r.UserID = u.UserID;";
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
  let queryProducts =
    "SELECT productid, pname, price, category, quantityAvailable FROM products;";
  connection.query(queryProducts, (errProducts, resultProducts) => {
    if (errProducts) {
      console.log(errProducts);
      res.send("Some error in fetching products from the database");
    } else {
      // console.log(resultProducts);
      res.render("products.ejs", { products: resultProducts });
    }
  });
});

// user authentication
//  https://www.youtube.com/watch?v=Ud5xKCYQTjM&ab_channel=WebDevSimplified
//  https://www.youtube.com/watch?v=jI4K7L-LI58&ab_channel=WebDevSimplified

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
        res.send("error with login");
      } else {
        if (resultLogin.length == 0) {
          res.redirect(
            "/login?alert=" + encodeURIComponent("Username does not exist")
          );
        } else {
          let hashedPassword = resultLogin[0].PasswordHash;
          let isPasswordMatch = await bcrypt.compare(password, hashedPassword);
          if (isPasswordMatch) {
            res.send("login successfull");
          } else {
            res.redirect(
              "/login?alert=" + encodeURIComponent("Incorrect Password !!")
            );
          }
        }
      }
    });
  } catch (err){
    console.log(err);
    res.redirect("/login");
  }
});





app.listen(port, () => {
  console.log(`server listening to port ${port}`);
});
