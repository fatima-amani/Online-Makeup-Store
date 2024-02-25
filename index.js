const express = require('express');
const app = express();
const port = 3000;
const path = require("path");


app.set("view engine","ejs");
app.set("views", path.join(__dirname,"views"));
app.use(express.static(path.join(__dirname,"public")));

// mysql2
const mysql = require('mysql2');

const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    database: 'GlamSphereDB',
    password: "sql123",
    port:"3306"
});

app.get('/home', (req, res) => {
    let queryReviews = "SELECT r.UserID, r.ReviewComment, u.UserName FROM Reviews R JOIN Users u ON r.UserID = u.UserID;";
    connection.query(queryReviews, (errReviews, resultReviews) => {
        if (errReviews) {
            console.log(errReviews);
            res.send("some error in Database");
        } else {
            // console.log(resultReviews);
            let queryProducts = "SELECT productid, pname, price, category, quantityAvailable FROM products ORDER BY quantityAvailable DESC LIMIT 4;";
            connection.query(queryProducts, (errProducts, resultProducts) => {
                if (errProducts) {
                    console.log(errProducts);
                    res.send("Some error in fetching products from the database");
                } else {
                    // console.log(resultProducts);

                    res.render('index.ejs', { reviews: resultReviews, products: resultProducts });
                }
            });
        }
    });
});

app.get("/products",(req,res) => {
    let queryProducts = "SELECT productid, pname, price, category, quantityAvailable FROM products;";
    connection.query(queryProducts, (errProducts,resultProducts) => {
        if (errProducts) {
            console.log(errProducts);
            res.send("Some error in fetching products from the database");
        } else {
            // console.log(resultProducts);
            res.render('products.ejs', {products : resultProducts});
        }
    });
    
});

// user authentication
//  https://www.youtube.com/watch?v=Ud5xKCYQTjM&ab_channel=WebDevSimplified
//  https://www.youtube.com/watch?v=jI4K7L-LI58&ab_channel=WebDevSimplified

app.get("/aa",(req, res) => {
    res.render("contact.ejs")
});

app.listen(port,()=> {
    console.log(`server listening to port ${port}`);
});