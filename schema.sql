CREATE DATABASE Glamspheredb;
USE Glamspheredb;

CREATE TABLE Products (
    ProductID VARCHAR(10) PRIMARY KEY,
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
    UserID VARCHAR(10) PRIMARY KEY,
    Username VARCHAR(255) UNIQUE,
    PasswordHash VARCHAR(255),
    EmailID VARCHAR(255) UNIQUE,
    UserAddress VARCHAR(255),
    Phone VARCHAR(20),
    UserRole ENUM('CUSTOMER', 'ADMIN'),
    CONSTRAINT chk_phone CHECK (LENGTH(Phone) = 10 AND Phone REGEXP '^[0-9]+$'), -- phone constraint
    CONSTRAINT chk_email CHECK (EmailID REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') -- Email checker constrain
);

CREATE TABLE Shades (
    ShadeID SERIAL PRIMARY KEY,
    ProductID VARCHAR(10),
    ShadeName VARCHAR(255),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Orders (
    OrderID VARCHAR(10) PRIMARY KEY,
    UserID VARCHAR(10),
    OrderDate DATE,
    OrderAmount DECIMAL(10, 2),
    OrderStatus ENUM('PLACED', 'CANCELLED', 'PROCESSING', 'DELIVERED'),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE OrderDetail (
    OrderDetailID SERIAL PRIMARY KEY,
    OrderID VARCHAR(10),
    ProductID VARCHAR(10),
    Quantity INT,
    Subtotal DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Reviews (
    ReviewID SERIAL PRIMARY KEY,
    UserID VARCHAR(10),
    ProductID VARCHAR(10),
    Rating INT,
    ReviewComment TEXT,
    ReviewDate DATE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

SHOW TABLES;
DESC Products;
DESC Users;
DESC Shades;
DESC Orders;
DESC OrderDetail;
DESC Reviews;


-- insert into products 
INSERT INTO Products (ProductID, PName, Brand, Manufacturer, CountryOfOrigin, PDescription, Price, QuantityAvailable, Category, MainCategory, ProductImage)
VALUES 
('P1', 'Nykaa Matte to Last! Transfer Proof Liquid Lipstick', 'Nykaa', 'FSN E-Commerce Ventures Limited', 'India', 'Nykaa''s Matte to Last! boasts serious staying power, promising transfer-proof color that won''t feather or flake. This liquid lipstick delivers a bold, ultra-matte finish in a spectrum of shades, from everyday nudes to dramatic reds. Enriched with Vitamin E, it aims to keep lips comfortable despite the matte texture. Reviewers praise its long-lasting wear but mention it can feel drying, suggesting lip balm prep. At a mid-range price, it''s a tempting option for those seeking budge-proof color, but be prepared for a true matte experience.', 599, 25, 'LIPSTICK','makeup',"C:\Users\Fatima\OneDrive\Desktop\DBMS website\backend\images\nykaa matte to last.png"),
('P2', 'M.A.C Strobe Cream', 'MAC', 'Estee Lauder Companies', 'Belgium', 'M∙A∙C Strobe Cream is your skin''s instant pick-me-up. This lightweight, illuminating moisturizer hydrates and brightens, banishing dullness with subtle shimmer. Packed with vitamins and green tea, it nourishes while fine, light-reflecting particles create a dewy, radiant glow. Apply alone for a natural boost, or mix with foundation for an all-over lit-from-within look. Available in 5 shades (pink, peach, silver, red, gold) to flatter all skin tones', 3950, 50, 'PRIMER','makeup',"C:\Users\Fatima\OneDrive\Desktop\DBMS website\backend\images\mac strobe cream.png"),
('P3', 'Kay Beauty Hydrating Foundation', 'Kay Beauty', 'Nykaa-KK Beauty Pvt Ltd', 'India', 'Kay Beauty''s Hydrating Foundation is your key to radiant, flawless skin. This lightweight, ultra-creamy formula melts into your skin, providing buildable coverage from natural to high. It evens out skin tone, blurs imperfections, and delivers a dewy, luminous finish. Enriched with hydrating ingredients, it keeps your skin moisturized and comfortable all day. Breathable, second-skin feel makes it perfect for all skin types. It''s the foundation for any look, from subtle glam to flawless coverage.', 1299, 30, 'FOUNDATION','makeup',"C:\Users\Fatima\OneDrive\Desktop\DBMS website\backend\images\kay beauty foundation.png"),
('P4', 'Maybelline New York Instant Age Rewind Concealer', 'Maybelline', 'Yichang Tianmi International Cosmetics Co.', 'China', 'Maybelline''s Instant Age Rewind Concealer is your multi-tasking magic wand for brighter, younger-looking eyes. This do-it-all formula, infused with goji berry and Haloxyl, not only conceals dark circles and blemishes, but also claims to visibly reduce fine lines and firm the under-eye area. Its unique micro-corrector applicator with a built-in sponge blends seamlessly, providing light to medium coverage with a radiant, crease-resistant finish. Plus, SPF 18 shields your delicate skin from sun damage. Hydrating and lightweight, this concealer is suitable for most skin types and promises up to 12 hours of wear. Get ready to rewind the years and reveal a refreshed, luminous you!', 729, 38, 'CONCEALER','makeup',"C:\Users\Fatima\OneDrive\Desktop\DBMS website\backend\images\maybelline instant age rewind concealor.png"),
('P5', 'Huda Beauty Empowered Eyeshadow Palette', 'Huda Beauty', 'Huda Beauty LLC', 'Italy', 'The Huda Beauty Empowered Eyeshadow Palette is a versatile eyeshadow palette that includes 18 shades in a variety of finishes, including matte, metallic, shimmer, and gel-liner hybrid. The shades are all highly pigmented and blendable, making it easy to create a variety of eye looks. The palette also includes a mirror and two double-ended brushes.', 5900, 10, 'EYESHADOW','makeup',"C:\Users\Fatima\OneDrive\Desktop\DBMS website\backend\images\huda beauty empowered pallete.png");

SELECT * FROM Products;

INSERT INTO Users (UserID, Username, PasswordHash, EmailID, UserAddress, Phone, UserRole)
VALUES 
("UID1", 'fatimaamani', 'fatty123', 'fatima@gmail.com', 'Mantri Serenity', '9470806786', 'ADMIN'),
("UID2", 'darshananagar', 'diya123', 'darshana@gmail.com', 'Saraswati Nilaya', '9844420212', 'ADMIN'),
("UID3", 'alakanandagm', 'fruity123', 'alakananda@gmail.com', 'Lakshmi Niwas', '9999988888', 'CUSTOMER'),
("UID4", 'aamnasiddiqui', 'aamin123', 'aamna@gmail.com', 'Alfred Street', '9999977777', 'CUSTOMER'),
("UID5", 'apekshaankola', 'peksy123', 'apeksha@gmail.com', 'Vijayanagar', '9999966666', 'CUSTOMER');

INSERT INTO Shades (ProductID, ShadeName)
VALUES
("P1", 'BOMBAE'),
("P1", 'MADRAAS KAPI'),
("P1", 'JHANVI'),
("P2", 'PINKLITE'),
("P2", 'GOLDLITE'),
("P2", 'PEACHLITE'),
("P3", 'COOL IVORY'),
("P3", 'NEUTRAL FAIR'),
("P3", 'LIGHT BEIGE'),
("P3", 'MEDIUM NEUTRAL'),
("P3", 'TAN WARM'),
("P4", 'FAIR'),
("P4", 'MEDIUM'),
("P4", 'LIGHT');

INSERT INTO Orders (OrderID,UserID, OrderDate, OrderAmount, OrderStatus)
VALUES
("GS001","UID4", '2024-02-14', 5900, 'PLACED'),
("GS002","UID3", '2024-02-15', 1898, 'PLACED');

INSERT INTO OrderDetail (OrderID, ProductID, Quantity, Subtotal)
VALUES
("GS001", "P5", 1, 5900),
("GS002", "P1", 1, 599),
("GS002", "P3", 1, 1299);


INSERT INTO Reviews (UserID, ProductID, Rating, ReviewComment, ReviewDate)
VALUES
("UID5", "P5", 1, '5900 IS TOO EXPENSIVE FOR AN EYESHADOW !!!!', '2024-02-20'),
("UID1", "P1", 5, 'LIPSTICK IS AMAZING !! BOMBAE IS MY FAVOURITE SHADE', '2024-02-25');


SELECT * FROM Products;
SELECT * FROM Users;
SELECT * FROM Shades;
SELECT * FROM Orders;
SELECT * FROM OrderDetail;
SELECT * FROM Reviews;


