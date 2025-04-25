require("dotenv").config();
const credentials = process.env;


const express = require("express");
const app = express();
const port = 3000;
const path = require("path");
const bcrypt = require("bcrypt");

// payment gateway
const Razorpay = require("razorpay");
const crypto = require("crypto");

app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));
app.use(express.static(path.join(__dirname, "public")));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// mysql2
const mysql = require("mysql2");
const { error } = require("console");


const connection = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT,
});

// Payment gateway credentials

const razorpayInstance = new Razorpay({
  key_id: process.env.RAZORPAY_KEY_ID,
  key_secret: process.env.RAZORPAY_KEY_SECRET,
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
  if (!queryString) {
    queryProducts =
      "SELECT productid, pname, price, category, quantityAvailable,imagePath FROM products;";
  } else {
    queryProducts =
      "SELECT productid, pname, price, category, quantityAvailable,imagePath FROM products WHERE MainCategory = ?;";
  }

  connection.query(
    queryProducts,
    [queryString],
    (errProducts, resultProducts) => {
      if (errProducts) {
        console.log(errProducts);
        res.send("Some error in fetching products from the database");
      } else {
        // console.log(resultProducts);
        res.render("products.ejs", { products: resultProducts });
      }
    }
  );
});

app.get("/products/view", (req, res) => {
  const pid = req.query.id;
  // console.log(pid);
  let query = "SELECT * FROM Products WHERE ProductID = ?; ";
  try {
    connection.query(query, [pid], (errProd, resProd) => {
      if (errProd) {
        console.log(errProd);
        res.redirect("/products");
      } else {
        // console.log(resProd[0]);
        res.render("viewProduct.ejs", { item: resProd[0] });
      }
    });
  } catch (error) {
    console.log(error);
    res.redirect("/products");
  }
});

app.post("/cart", (req, res) => {
  // console.log(req.body);
  let userid = parseInt(req.body.username);
  // console.log(userid);
  let query =
    "SELECT c.CartItemID, c.ProductID, c.UserID, p.PName, p.Price,p.imagePath, c.quantity FROM Cart c,Products p where c.productid = p.productid and c.userid=?;";
  try {
    connection.query(query, [parseInt(userid)], (errCart, resultCart) => {
      if (errCart) {
        console.log(errCart);
        res.redirect("/login?alert=kindly login to access cart!!");
      } else {
        // console.log(resultCart);

        // total
        let totalAmount = 0;
        let totalItem = 0;
        resultCart.forEach((item) => {
          const price = parseInt(item.Price);
          totalAmount += price * item.quantity;
          totalItem +=item.quantity;

        });

        let totalDetail = {
          total: totalAmount,
          totalItems: totalItem,
        };

        res.render("cart.ejs", {
          cartItems: resultCart,
          totalDetail: totalDetail,
        });
      }
    });
  } catch (err) {
    console.log(err);
    res.redirect("/home");
  }
});

app.post("/addtocart", (req, res) => {
  // console.log(req.body);
  let query =
    "SELECT CartItemID, Quantity FROM Cart WHERE UserID = ? AND ProductID = ?;";
  let details = [req.body.userid, req.body.productid];
  connection.query(query, details, (errItem, resItem) => {
    if (errItem) {
      console.log(errItem);
      res.status(500).send("Internal Server Error");
    } else {
      // console.log(resItem);
      if (resItem.length == 0) {
        let queryAddCart =
          "INSERT INTO CART(UserID, ProductID, Quantity) VALUES (?,?,1);";
        connection.query(queryAddCart, details, (errAddCart, resAddCart) => {
          if (errAddCart) {
            console.log(errAddCart);
            res.status(500).send("Internal Server Error");
          } else {
            res.status(200).send("Added to cart");
            // console.log("Added to cart");
          }
        });
      } else {
        let currentQuantity = resItem[0].Quantity;
        let queryUpdateCart =
          "UPDATE Cart SET Quantity = ? WHERE UserID = ? AND ProductID = ?;";
        connection.query(
          queryUpdateCart,
          [currentQuantity + 1, req.body.userid, req.body.productid],
          (errUpdateCart, resUpdateCart) => {
            if (errUpdateCart) {
              console.log(errUpdateCart);
              res.status(500).send("Internal Server Error");
            } else {
              res.status(200).send("Cart updated");
              // console.log("Cart updated");
            }
          }
        );
      }
    }
  });
});


// checkout
app.get("/checkout", (req, res) => {
  // console.log("you have enetered checkout section");
  // console.log(req.query); // { userid: '6' }

  let user = parseInt(req.query.userid);
  // console.log(user);

  let cartQuery =
    "SELECT c.ProductID,c.Quantity,p.Price FROM Cart c, Products p where c.ProductID = p.ProductID and c.UserID = ? ;";
  connection.query(cartQuery, [user], (errCart, resCart) => {
    if (errCart) {
      console.log("error with database fetching cart: ", errCart);
      return res
        .status(500)
        .json({ success: false, message: "Error in fetching the cart" });
    } else {
      // console.log(resCart);
      // create a new order
      queryOrder =
        "INSERT INTO Orders (UserID, OrderDate, OrderAmount, OrderStatus) VALUES (?, DATE_FORMAT(NOW(), '%Y%m%d'), ?, 'PLACED');";
      // console.log(calcTotal(resCart));
      let totalAmount = calcTotal(resCart);
      listOrder = [user, totalAmount];
      connection.query(queryOrder, listOrder, (errOrder, resOrder) => {
        if (errOrder) {
          console.log("Error in creating order: ", errOrder);
          return res
            .status(500)
            .json({ success: false, message: "Error in placing Order" });
        } else {
          connection.query(
            "SELECT OrderID FROM Orders ORDER BY orderID DESC LIMIT 1;",
            (errOrderNum, resOrderNum) => {
              if (errOrder) {
                console.log("Error in creating order: ", errOrderNum);
                return res
                  .status(500)
                  .json({ success: false, message: "Error in placing Order" });
              } else {
                let receiptNum = resOrderNum[0].OrderID;
                let RpOrder = {
                  amount: (totalAmount * 100).toString(),
                  currency: "INR",
                  receipt: receiptNum.toString(),
                  notes: {
                    description: "Makeup from Glamsphere",
                  },
                };

                razorpayInstance.orders.create(RpOrder, (err, order) => {
                  if (!err) {
                    createOrderDetail(user, receiptNum, resCart);
                    clearCart(user);
                    // console.log(order);
                    return res.status(200).json({
                      success: true,
                      message: "checked out successfully",
                      myOrder: order,
                    });
                  } else {
                    return res.status(500).json({
                      success: false,
                      message: "Error in placing Order",
                    });
                  }
                });
              }
            }
          );
        }
      });
    }
  });
});

function createOrderDetail(user, orderID, cart) {
  query =
    "INSERT INTO OrderDetail (OrderID, ProductID, Quantity, Subtotal) VALUES(?, ?,?,?);";
  for (item of cart) {
    details = [
      parseInt(orderID),
      item.ProductID,
      item.Quantity,
      parseFloat(item.Price) * item.Quantity,
    ];
    // console.log(details);
    connection.query(query, details, (err, res) => {
      if (err) {
        console.log("error in entering Order Details: ", err);
      } else {
        console.log("success in entering order details");
      }
    });
  }
}

// payment gateway routes

app.post("/verifyOrder", (req, res) => {
  console.log("entered verifyOrder");
  // STEP 7: Receive Payment Data
  const { order_id, payment_id, OrderID } = req.body;
  const razorpay_signature = req.headers["x-razorpay-signature"];

  // Pass yours key_secret here
  const key_secret = credentials.key_secret;

  // STEP 8: Verification & Send Response to User

  // Creating hmac object
  let hmac = crypto.createHmac("sha256", key_secret);

  // Passing the data to be hashed
  hmac.update(order_id + "|" + payment_id);

  // Creating the hmac in the required format
  const generated_signature = hmac.digest("hex");

  if (razorpay_signature == generated_signature) {
    modifyOrder(OrderID, "PAID");
    res.json({ success: true, message: "Payment has been verified" });
  } else {
    res.json({ success: false, message: "Payment verification failed" });
  }
});

app.post("/cancelOrder", (req, res) => {
  modifyOrder(req.body.OrderID, "CANCELLED");
  res.json({ success: true, message: "Order Cancelled !" });
});

app.get("/orderfailed", (req, res) => {
  res.render("orderFail.ejs");
});

function modifyOrder(OrderID, status) {
  query = "UPDATE Orders SET OrderStatus=? WHERE OrderID=?; ";
  connection.query(query, [status, OrderID], (err, res) => {
    if (err) {
      console.log(err);
    } else {
      // console.log(res);
    }
  });
}
function calcTotal(cartItems) {
  let total = 0;
  cartItems.forEach((item) => {
    const price = parseInt(item.Price);
    total += price * item.Quantity;
  });
  // console.log(`total is: ${total}`);
  return total;
}

function clearCart(user) {
  let query = "DELETE FROM Cart WHERE UserID = ?;";
  try {
    connection.query(query, [user], (err, res) => {
      if (err) {
        console.log(err);
      } else {
        // console.log("successfully clear cart for userid ", user);
      }
    });
  } catch (error) {
    console.log(error);
  }
}

app.get("/orderplaced", (req, res) => {
  res.render("orderSuccess.ejs");
});

// Signup routes
app.get("/signup", (req, res) => {
  res.render("signup.ejs");
});

app.post("/user/signup", async (req, res) => {
  try {
    const hashedPassword = await bcrypt.hash(req.body.password, 10);
    // console.log(req.body);
    // console.log(hashedPassword);
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
        res.redirect("/login?alert=You have succesfully signed up, login to continue.");
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
    connection.query(queryLogin, [username], async (errLogin, resultLogin) => {
      if (errLogin) {
        console.log(errLogin);
        // res.send("error with login");
        return res
          .status(500)
          .json({ success: false, message: "An error occurred" });
      } else {
        if (resultLogin.length == 0) {
          return res
            .status(404)
            .json({ success: false, message: "User not found" });
        } else {
          // console.log(resultLogin);
          let hashedPassword = resultLogin[0].PasswordHash;
          let isPasswordMatch = await bcrypt.compare(password, hashedPassword);
          if (isPasswordMatch) {
            // success in login
            let user = resultLogin[0];
            // console.log(user);
            return res.status(200).json({
              success: true,
              message: "Authentication successful",
              user,
            });
          } else {
            res
              .status(401)
              .json({ success: false, message: "Incorrect password" });
          }
        }
      }
    });
  } catch (err) {
    console.log(err);
    res.redirect("/login");
  }
});

// profile
app.post("/profile", (req, res) => {
  let userid = req.body.username;
  if (userid == "") {
    res.redirect("/login?alert=kindly login to access profile!!");
  } else {
    queryProfile = `SELECT * FROM Users WHERE userid = ? ;`;
    try {
      connection.query(
        queryProfile,
        [parseInt(userid)],
        (errProfile, resProfile) => {
          if (errProfile) {
            console.log("some error with database", errProfile);
            res.redirect("/home");
          } else {
            // console.log(resProfile);
            res.render("profile.ejs", { user: resProfile[0] });
          }
        }
      );
    } catch {
      console.log("some error occurred with accessing profile");
      res.redirect("/home");
    }
  }
});

// about our website
app.get("/about", (req, res) => {
  res.render("about.ejs");
});

// contact us route

app.get("/contact", (req, res) => {
  res.render("contact.ejs");
});

app.get("/feedback", (req, res) => {
  res.render("feedback.ejs");
});

app.post("/feedback/post", (req, res) => {
  // console.log(req.body);
  let reviewPost = req.body;
  let query =
    "INSERT INTO StoreReviews (RName, EmailID, Content) VALUES (?,?,?); ";
  let review = [req.body.name, req.body.email, req.body.message];
  try {
    connection.query(query, review, (err, results) => {
      if (err) {
        console.log(err);
        res.send("Some errors happened please try again");
      } else {
        res.redirect("/home?alert=review posted successfully");
      }
    });
  } catch (err) {
    console.log(err);
    res.redirect("/feedback");
  }
});

app.listen(port, () => {
  console.log(`server listening to port ${port}`);
});
