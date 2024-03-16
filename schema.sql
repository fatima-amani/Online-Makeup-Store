CREATE DATABASE Glamspheredb;
USE Glamspheredb;
SHOW TABLES;


CREATE TABLE Products (
    ProductID SERIAL PRIMARY KEY,
    PName VARCHAR(255),
    Brand VARCHAR(255),
    Manufacturer VARCHAR(255),
    CountryOfOrigin VARCHAR(255),
    PDescription TEXT,
    Price DECIMAL(10, 2),
    QuantityAvailable INT,
    Category VARCHAR(255),
    MainCategory ENUM('makeup', 'skincare'),
    ProductImage VARCHAR(255)
);

CREATE TABLE Users (
    UserID SERIAL PRIMARY KEY,
    FirstName VARCHAR(10),
    LastName VARCHAR(10),
    EmailID VARCHAR(255) UNIQUE,
    Username VARCHAR(255) UNIQUE,
    PasswordHash VARCHAR(255),    
    Phone VARCHAR(20),
    UserRole ENUM('CUSTOMER', 'ADMIN'),
    UserAddress VARCHAR(255),
    imagePath VARCHAR(255)
);

-- ADD PATH TO INSERT
-- SET imagePath = '/images/fatima.png';


CREATE TABLE Shades (
    ShadeID SERIAL PRIMARY KEY,
    ProductID INTEGER REFERENCES Products(ProductID) ON DELETE CASCADE,
    ShadeName VARCHAR(255)
);

CREATE TABLE Orders (
    OrderID SERIAL PRIMARY KEY,
    UserID VARCHAR(10) REFERENCES Users(UserID) ON DELETE CASCADE,
    OrderDate DATE,
    OrderAmount DECIMAL(10, 2),
    OrderStatus ENUM('PLACED','PAID', 'CANCELLED', 'PROCESSING', 'DELIVERED')
);

CREATE TABLE OrderDetail (
    OrderDetailID SERIAL PRIMARY KEY,
    OrderID INTEGER REFERENCES Orders(OrderID)  ON DELETE CASCADE,
    ProductID INTEGER REFERENCES Products(ProductID)  ON DELETE CASCADE,
    Quantity INT,
    Subtotal DECIMAL(10, 2)
);


CREATE TABLE  ProductReviews (
    ReviewID SERIAL PRIMARY KEY,
    UserID INTEGER REFERENCES Users(UserID)  ON DELETE CASCADE,
    ProductID INTEGER REFERENCES Products(ProductID)  ON DELETE CASCADE,
    Rating INT,
    ReviewComment TEXT,
    ReviewDate DATE
);

CREATE TABLE StoreReviews (
	ReviewID SERIAL PRIMARY KEY,
    RName VARCHAR(20) NOT NULL,
    EmailID VARCHAR(255) REFERENCES USERS(EMAILID),
    Content VARCHAR(500) NOT NULL
);
CREATE TABLE CART(
	CartItemID SERIAL PRIMARY KEY,
    UserID INTEGER REFERENCES Users(UserID)  ON DELETE CASCADE,
    ProductID INTEGER REFERENCES Products(ProductID)  ON DELETE CASCADE,
    Quantity INTEGER
);
    

SHOW TABLES;
DESC Products;
DESC Users;
DESC Shades;
DESC Orders;
DESC OrderDetail;
DESC  ProductReviews;
DESC StoreReviews;


-- insert into products 

INSERT INTO Products (PName, Brand, Manufacturer, CountryOfOrigin, PDescription, Price, QuantityAvailable, Category, MainCategory, imagePath)
VALUES 
('Nykaa Matte to Last! Transfer Proof Liquid Lipstick', 'Nykaa', 'Nykaa''s Matte to Last! boasts serious staying power, promising transfer-proof color that won''t feather or flake. This liquid lipstick delivers a bold, ultra-matte finish in a spectrum of shades, from everyday nudes to dramatic reds. Enriched with Vitamin E, it aims to keep lips comfortable despite the matte texture. Reviewers praise its long-lasting wear but mention it can feel drying, suggesting lip balm prep. At a mid-range price, it''s a tempting option for those seeking budge-proof color, but be prepared for a true matte experience.', 599, 25, 'LIPSTICK','makeup',"\\images\\nykaamattetolast.png"),
('M.A.C Strobe Cream', 'MAC', 'Estee Lauder Companies',  'M∙A∙C Strobe Cream is your skin''s instant pick-me-up. This lightweight, illuminating moisturizer hydrates and brightens, banishing dullness with subtle shimmer. Packed with vitamins and green tea, it nourishes while fine, light-reflecting particles create a dewy, radiant glow. Apply alone for a natural boost, or mix with foundation for an all-over lit-from-within look. Available in 5 shades (pink, peach, silver, red, gold) to flatter all skin tones', 3950, 50, 'PRIMER','makeup',"\\images\\macstrobecream.png"),
('Kay Beauty Hydrating Foundation', 'Kay Beauty', 'Kay Beauty''s Hydrating Foundation is your key to radiant, flawless skin. This lightweight, ultra-creamy formula melts into your skin, providing buildable coverage from natural to high. It evens out skin tone, blurs imperfections, and delivers a dewy, luminous finish. Enriched with hydrating ingredients, it keeps your skin moisturized and comfortable all day. Breathable, second-skin feel makes it perfect for all skin types. It''s the foundation for any look, from subtle glam to flawless coverage.', 1299, 30, 'FOUNDATION','makeup',"\\images\\kaybeautyfoundation.png"),
('Maybelline New York Instant Age Rewind Concealer', 'Maybelline','Maybelline''s Instant Age Rewind Concealer is your multi-tasking magic wand for brighter, younger-looking eyes. This do-it-all formula, infused with goji berry and Haloxyl, not only conceals dark circles and blemishes, but also claims to visibly reduce fine lines and firm the under-eye area. Its unique micro-corrector applicator with a built-in sponge blends seamlessly, providing light to medium coverage with a radiant, crease-resistant finish. Plus, SPF 18 shields your delicate skin from sun damage. Hydrating and lightweight, this concealer is suitable for most skin types and promises up to 12 hours of wear. Get ready to rewind the years and reveal a refreshed, luminous you!', 729, 38, 'CONCEALER','makeup',"\\images\\maybellineinstantagerewindconcealor.png"),
('Huda Beauty Empowered Eyeshadow Palette', 'Huda Beauty', 'The Huda Beauty Empowered Eyeshadow Palette is a versatile eyeshadow palette that includes 18 shades in a variety of finishes, including matte, metallic, shimmer, and gel-liner hybrid. The shades are all highly pigmented and blendable, making it easy to create a variety of eye looks. The palette also includes a mirror and two double-ended brushes.', 5900, 10, 'EYESHADOW','makeup',"\\images\\hudabeautyempoweredpallete.png");

INSERT INTO Products (PName, Brand, PDescription, Price, QuantityAvailable, Category, MainCategory, imagePath)
VALUES
('Nivea Cherry Shine Lip Care','Nivea',"Our Developer Darshana's favourite Nivea Cherry Shine Lip Balm promises a burst of cherry flavor and a touch of shine for your lips. This lip balm is formulated to hydrate and protect your lips, leaving them feeling soft and smooth. Enriched with cherry extract and jojoba oil, it provides long-lasting moisture and a subtle pink tint, enhancing your natural lip color. This lip balm is suitable for everyday use and protects your lips from dryness and chapping, keeping them kissably soft and healthy.",250,25,'LipBalm','skincare',"\\images\\niveacherryshine.png"),
('Arata Matte Finish Sunscreen Cream','Arata',"Our Star Customer Aamna Siddiqui's favourite Arata Sunscreen boasts all-natural, vegan sunscreens for all skin types. Their SPF 50+ cream offers broad-spectrum UVA/UVB protection with tomato extracts (vitamin C & lycopene) for hydration and anti-aging. It has a matte finish and is free of harsh chemicals, emulsifiers, dyes, and preservatives. They are also cruelty-free and use recycled packaging.",499,100,'Sunscreen','skincare',"\\images\\aratasunscreen.png"),
('The Face Shop Rice Water Bright Foaming Cleanser','The Face Shop'," Our Developer Fatima's favourite The Face Shop's Rice Water Bright Cleansing Foam is a gentle cleanser formulated with rice water extracts, known for brightening properties. This whipped cream-like cleanser claims to remove impurities, makeup, and dead skin cells, leaving your skin feeling clean, bright, and even-toned. Suitable for all skin types, it's free of harsh chemicals and boasts a light, refreshing fragrance. ",849,75,'FaceWash','skincare',"\\images\\ricewatercleanser.png");

select * from users;
INSERT INTO Users (FirstName, LastName, EmailID, Username, PasswordHash, Phone, UserRole, UserAddress)
VALUES 
('Fatima', 'Amani', 'fatima@gmail.com', 'fatima','$2b$10$ubKFnDFgVA96sNqXUSMwKuN26kbSJHbuax50djlWu3oG8MxeGOhza', '9470806786', 'ADMIN', 'Mantri Serenity'),
('Darshana', 'Nagar', 'darshana@gmail.com', 'darshana','$10$fOmJ.f61zosufu4c72PbAu6m4HdQkUrmdzehchr6mr4B6SEBhYH/K', '9844420212', 'ADMIN', 'Saraswati Nilaya'),
('Alakananda', 'G M', 'alakananda@gmail.com','alaka', '$10$fCmH/92CSBS7Iv9g.0sAsO53RsCqJ6Pn.d9x18zwa2Fm.eNQuwZfq', '9999988888', 'CUSTOMER', 'Lakshmi Niwas'),
('Aamna', 'Siddiqui', 'aamna@gmail.com',  'aamna','$10$3QWbU8zPQ5tZQqhB.RLROumLlFB2QLZ8SiGu4r5SRE.rJ.a74txAi',  '9999977777', 'CUSTOMER', 'Alfred Street'),
('Apeksha', 'Ankola', 'apeksha@gmail.com','apeksha', '$10$HJD61LM5jmS6ZU83ZPCX5.f2/KhxEs3BsACJdKVOLkSM48OIQ4316', '9999966666', 'CUSTOMER', 'Vijayanagar');


INSERT INTO Shades (ProductID, ShadeName)
VALUES
(1, 'BOMBAE'),
(1, 'MADRAAS KAPI'),
(1, 'JHANVI'),
(2, 'PINKLITE'),
(2, 'GOLDLITE'),
(2, 'PEACHLITE'),
(3, 'COOL IVORY'),
(3, 'NEUTRAL FAIR'),
(3, 'LIGHT BEIGE'),
(3, 'MEDIUM NEUTRAL'),
(3, 'TAN WARM'),
(4, 'FAIR'),
(4, 'MEDIUM'),
(4, 'LIGHT');

INSERT INTO Orders (UserID, OrderDate, OrderAmount, OrderStatus)
VALUES
(4, '2024-02-14', 5900, 'PLACED'),
(3, '2024-02-15', 1898, 'PLACED');

INSERT INTO OrderDetail (OrderID, ProductID, Quantity, Subtotal)
VALUES
(1, 5, 1, 5900),
(2, 1, 1, 599),
(2, 3, 1, 1299);


INSERT INTO  ProductReviews (UserID, ProductID, Rating, ReviewComment, ReviewDate)
VALUES
(5, 5, 1, '5900 IS TOO EXPENSIVE FOR AN EYESHADOW !!!!', '2024-02-20'),
(5, 5, 1, '5900 IS TOO EXPENSIVE FOR AN EYESHADOW !!!!', '2024-02-20'),
(1, 1, 5, 'LIPSTICK IS AMAZING !! BOMBAE IS MY FAVOURITE SHADE', '2024-02-25');

INSERT INTO  ProductReviews (UserID, ProductID, Rating, ReviewComment, ReviewDate)
VALUES
(4,10,5,"Arata Sunscreen is my go to sunscreen. I saw it on SharkTank and ordered it asap!! ",'2024-02-28'),
(2,9,5,"This lip balm is amazing, I will not have books in my bag but defnitely a lip balm ", '2024-02-28');

INSERT INTO StoreReviews (RName, EmailID, Content)
VALUES 
('Aamna', 'aamna@gmail.com','Sunscreen lagani hoti hai yaar roz!and their sunscreen collection is soo soo good! they have multiple kinds of sunscreen to select from!'),
("Apeksha", "apeksha@gmail.com","Their collection! OMG they have everything you'll ever need for your skin! The customer service is good. Delivery is on time and every package comes with a personalized note with it! That's the best part for me tbh! Keep growin !!"),
('Alakananda','alakananda@gmail.com',"Fatima ke suggestions are the only suggestions I listen to! So ofcourse i had to try and experience the beauty of their products. I love them all! GlamSphere's products never cease to amaze mw! I love this store ");

INSERT INTO Cart (UserID ,ProductID , Quantity)
VALUES 
(1,2,1),
(1,3,1),
(2,5,1),
(2,3,2);


SELECT * FROM Products;
SELECT * FROM Users;
SELECT * FROM Shades;
SELECT * FROM Orders;
SELECT * FROM OrderDetail;
SELECT * FROM ProductReviews;
SELECT * FROM Cart;

delete from orders where orderid > 2;


UPDATE USERS
SET PASSWORDHASH= "$2b$10$HJD61LM5jmS6ZU83ZPCX5.f2/KhxEs3BsACJdKVOLkSM48OIQ4316"
WHERE USERID = 5;


show tables;

DELETE FROM PRODUCTS WHERE PRODUCTID > 5;





