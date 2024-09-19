CREATE TABLE Users_u (
    userid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(50),
    user_lastname VARCHAR(50),
    email VARCHAR(50),
    created_at DATE
);


INSERT INTO Users_u (user_name, user_lastname, email, created_at) 
VALUES 
('Anastasiya', 'Fedorchenko', 'n.fed@kse.org.ua', '2024-02-01'),
('Oleh', 'Skakun', 'o.skakun@kse.org.ua', '2024-02-05'),
('Dmitriy', 'Vasulchuk', 'd.vasulchuk@kse.org.ua', '2024-02-10'),
('Artem', 'Lickiewicz', 'a.lickiewicz@kse.org.ua', '2024-02-08'),

INSERT INTO Users_u (user_name, user_lastname, email, created_at) 
VALUES 
('Ivan', 'Petrenko', 'i.petrenko@kse.org.ua', '2024-02-12'),
('Maria', 'Kovalchuk', 'm.kovalchuk@kse.org.ua', '2024-02-20'),
('Oleksandr', 'Tkachenko', 'o.tkachenko@kse.org.ua', '2024-03-01'),
('Svitlana', 'Bondarenko', 's.bondarenko@kse.org.ua', '2024-03-15'),
('Yulia', 'Hrytsenko', 'y.hrytsenko@kse.org.ua', '2024-03-22');



CREATE TABLE ORDERS_o (
    orderid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,   
    userid INT,                                        
    order_date DATE,                                   
    FOREIGN KEY (userid) REFERENCES Users_u(userid)     
);


INSERT INTO ORDERS_o (userid, order_date) 
VALUES 
(1, '2024-03-01'),
(2, '2024-03-15'),
(3, '2024-04-05'),
(4, '2024-05-10');

CREATE TABLE Categories (
    categorieid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    categorie_name VARCHAR(50)
);

INSERT INTO Categories (categorie_name) 
VALUES 
('Electronics'),
('Clothing'),
('Books'),
('Accessories'); 

CREATE TABLE Products (
    productid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(50),
    price_of_the_product INT,
    categorieid INT,
    FOREIGN KEY (categorieid) REFERENCES Categories(categorieid)
);


INSERT INTO Products (product_name, price_of_the_product, categorieid) 
VALUES 
('Laptop', 1000, 1),
('T-shirt', 20, 2),
('Novel', 15, 3),
('Glasses', 150, 4);


CREATE TABLE Orders_items (
    orders_item_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    quantity INT,
    orderid INT,
    FOREIGN KEY (orderid) REFERENCES ORDERS_o(orderid),
    productid INT,
    FOREIGN KEY (productid) REFERENCES Products(productid)
);

INSERT INTO Orders_items (quantity, orderid, productid) 
VALUES 
(1, 1, 1), 
(1, 2, 2),  
(1, 3, 3),
(1, 4, 4);

WITH User_Orders AS (
    SELECT 
        uu.userid, 
        uu.user_name, 
        uu.user_lastname,
        uu.email,
        COALESCE(GROUP_CONCAT(DISTINCT P.product_name ORDER BY P.product_name SEPARATOR ', '), 'No product') AS products_ordered,
        COALESCE(GROUP_CONCAT(DISTINCT C.categorie_name ORDER BY C.categorie_name SEPARATOR ', '), 'No category') AS categories_ordered,
        COALESCE(SUM(OI.quantity * P.price_of_the_product), 0) AS total_spent,
        COALESCE(SUM(OI.quantity), 0) AS total_quantity
    FROM 
        Users_u uu
    LEFT JOIN 
        ORDERS_o o ON uu.userid = o.userid
    LEFT JOIN 
        Orders_items OI ON o.orderid = OI.orderid
    LEFT JOIN 
        Products P ON OI.productid = P.productid
    LEFT JOIN 
        Categories C ON P.categorieid = C.categorieid
    GROUP BY 
        uu.userid, uu.user_name, uu.user_lastname, uu.email
)
SELECT 
    userid, 
    user_name, 
    user_lastname,
    email, 
    products_ordered,
    categories_ordered,
    total_spent,
    total_quantity
FROM 
    User_Orders
where 1=1
ORDER BY 
    userid;

INSERT INTO Orders_items (quantity, orderid, productid) 
values (5, 11, 4);

INSERT INTO ORDERS_o (userid, order_date)
values (5, '2024-06-14');


SELECT  DISTINCT  uu.userid, uu.user_name, uu.email
FROM Users_u uu
JOIN ORDERS_o o ON uu.userid = o.userid

union all

SELECT uu.userid, uu.user_name, uu.email
FROM Users_u uu
LEFT JOIN ORDERS_o o ON uu.userid = o.userid
WHERE o.userid IS NULL;   
   
 
   
   
   