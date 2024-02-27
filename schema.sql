CREATE DATABASE Glamspheredb;
USE Glamspheredb;


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

ALTER TABLE products
ADD COLUMN imagePath VARCHAR(255);



CREATE TABLE Users (
    UserID SERIAL PRIMARY KEY,
    FirstName VARCHAR(10),
    LastName VARCHAR(10),
    EmailID VARCHAR(255) UNIQUE,
    Username VARCHAR(255) UNIQUE,
    PasswordHash VARCHAR(255),    
    Phone VARCHAR(20),
    UserRole ENUM('CUSTOMER', 'ADMIN'),
    UserAddress VARCHAR(255)
);



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
    OrderStatus ENUM('PLACED', 'CANCELLED', 'PROCESSING', 'DELIVERED')
);

CREATE TABLE OrderDetail (
    OrderDetailID SERIAL PRIMARY KEY,
    OrderID VARCHAR(10) REFERENCES Orders(OrderID)  ON DELETE CASCADE,
    ProductID VARCHAR(10) REFERENCES Products(ProductID)  ON DELETE CASCADE,
    Quantity INT,
    Subtotal DECIMAL(10, 2)
);

CREATE TABLE Reviews (
    ReviewID SERIAL PRIMARY KEY,
    UserID VARCHAR(10) REFERENCES Users(UserID)  ON DELETE CASCADE,
    ProductID VARCHAR(10) REFERENCES Products(ProductID)  ON DELETE CASCADE,
    Rating INT,
    ReviewComment TEXT,
    ReviewDate DATE
);

SHOW TABLES;
DESC Products;
DESC Users;
DESC Shades;
DESC Orders;
DESC OrderDetail;
DESC Reviews;


-- insert into products 

INSERT INTO Products (PName, Brand, Manufacturer, CountryOfOrigin, PDescription, Price, QuantityAvailable, Category, MainCategory, imagePath)
VALUES 
('Nykaa Matte to Last! Transfer Proof Liquid Lipstick', 'Nykaa', 'FSN E-Commerce Ventures Limited', 'India', 'Nykaa''s Matte to Last! boasts serious staying power, promising transfer-proof color that won''t feather or flake. This liquid lipstick delivers a bold, ultra-matte finish in a spectrum of shades, from everyday nudes to dramatic reds. Enriched with Vitamin E, it aims to keep lips comfortable despite the matte texture. Reviewers praise its long-lasting wear but mention it can feel drying, suggesting lip balm prep. At a mid-range price, it''s a tempting option for those seeking budge-proof color, but be prepared for a true matte experience.', 599, 25, 'LIPSTICK','makeup',"\\images\\nykaamattetolast.png"),
('M.A.C Strobe Cream', 'MAC', 'Estee Lauder Companies', 'Belgium', 'M∙A∙C Strobe Cream is your skin''s instant pick-me-up. This lightweight, illuminating moisturizer hydrates and brightens, banishing dullness with subtle shimmer. Packed with vitamins and green tea, it nourishes while fine, light-reflecting particles create a dewy, radiant glow. Apply alone for a natural boost, or mix with foundation for an all-over lit-from-within look. Available in 5 shades (pink, peach, silver, red, gold) to flatter all skin tones', 3950, 50, 'PRIMER','makeup',"\\images\\macstrobecream.png"),
('Kay Beauty Hydrating Foundation', 'Kay Beauty', 'Nykaa-KK Beauty Pvt Ltd', 'India', 'Kay Beauty''s Hydrating Foundation is your key to radiant, flawless skin. This lightweight, ultra-creamy formula melts into your skin, providing buildable coverage from natural to high. It evens out skin tone, blurs imperfections, and delivers a dewy, luminous finish. Enriched with hydrating ingredients, it keeps your skin moisturized and comfortable all day. Breathable, second-skin feel makes it perfect for all skin types. It''s the foundation for any look, from subtle glam to flawless coverage.', 1299, 30, 'FOUNDATION','makeup',"\\images\\kaybeautyfoundation.png"),
('Maybelline New York Instant Age Rewind Concealer', 'Maybelline', 'Yichang Tianmi International Cosmetics Co.', 'China', 'Maybelline''s Instant Age Rewind Concealer is your multi-tasking magic wand for brighter, younger-looking eyes. This do-it-all formula, infused with goji berry and Haloxyl, not only conceals dark circles and blemishes, but also claims to visibly reduce fine lines and firm the under-eye area. Its unique micro-corrector applicator with a built-in sponge blends seamlessly, providing light to medium coverage with a radiant, crease-resistant finish. Plus, SPF 18 shields your delicate skin from sun damage. Hydrating and lightweight, this concealer is suitable for most skin types and promises up to 12 hours of wear. Get ready to rewind the years and reveal a refreshed, luminous you!', 729, 38, 'CONCEALER','makeup',"\\images\\maybellineinstantagerewindconcealor.png"),
('Huda Beauty Empowered Eyeshadow Palette', 'Huda Beauty', 'Huda Beauty LLC', 'Italy', 'The Huda Beauty Empowered Eyeshadow Palette is a versatile eyeshadow palette that includes 18 shades in a variety of finishes, including matte, metallic, shimmer, and gel-liner hybrid. The shades are all highly pigmented and blendable, making it easy to create a variety of eye looks. The palette also includes a mirror and two double-ended brushes.', 5900, 10, 'EYESHADOW','makeup',"\\images\\hudabeautyempoweredpallete.png");

SELECT * FROM Products;

INSERT INTO Users (FirstName, LastName, EmailID, Username, PasswordHash, Phone, UserRole, UserAddress)
VALUES 
('Fatima', 'Amani', 'fatima@gmail.com', 'fatima','fatty123', '9470806786', 'ADMIN', 'Mantri Serenity'),
('Darshana', 'Nagar', 'darshana@gmail.com', 'darshana','diya123', '9844420212', 'ADMIN', 'Saraswati Nilaya'),
('Alakananda', 'G M', 'alakananda@gmail.com','alaka', 'fruity123', '9999988888', 'CUSTOMER', 'Lakshmi Niwas'),
('Aamna', 'Siddiqui', 'aamna@gmail.com',  'aamna','aamin123',  '9999977777', 'CUSTOMER', 'Alfred Street'),
('Apeksha', 'Ankola', 'apeksha@gmail.com','apeksha', 'peksy123', '9999966666', 'CUSTOMER', 'Vijayanagar');






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


INSERT INTO Reviews (UserID, ProductID, Rating, ReviewComment, ReviewDate,imagePath)
VALUES
(5, 5, 1, '5900 IS TOO EXPENSIVE FOR AN EYESHADOW !!!!', '2024-02-20'),
(5, 5, 1, '5900 IS TOO EXPENSIVE FOR AN EYESHADOW !!!!', '2024-02-20'),
(1, 1, 5, 'LIPSTICK IS AMAZING !! BOMBAE IS MY FAVOURITE SHADE', '2024-02-25');



SELECT * FROM Products;
SELECT * FROM Users;
SELECT * FROM Shades;
SELECT * FROM Orders;
SELECT * FROM OrderDetail;
SELECT * FROM Reviews;
