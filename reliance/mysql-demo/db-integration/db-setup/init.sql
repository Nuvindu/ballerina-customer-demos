-- Create a new user and grant privileges
CREATE USER 'local_user'@'%' IDENTIFIED BY 'password';

GRANT ALL PRIVILEGES ON MUSIC_STORE.* TO 'local_user'@'%';

FLUSH PRIVILEGES;

-- Creates a database.
CREATE DATABASE IF NOT EXISTS BOOK_STORE;

USE BOOK_STORE;

-- Creates `books` table in the database.
CREATE TABLE BOOK_STORE.books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0)
);

-- Creates `orders` table in the database.
CREATE TABLE BOOK_STORE.orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    customer_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    total_price DECIMAL(10, 2) NOT NULL,
    order_date DATETIME NOT NULL,
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

-- Creates `sales` table in the database.
CREATE TABLE BOOK_STORE.sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    sale_date DATETIME NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

-- Adds records to the `books` table.
INSERT INTO BOOK_STORE.books (title, author, price, quantity) VALUES
('Crime And Punishment', 'Fyodor Dostoevsky', 10.99, 50),
('A Game of Thrones', 'George R.R. Martin', 7.99, 30),
('1984', 'George Orwell', 8.99, 40);

-- Adds records to the `orders` table.
INSERT INTO BOOK_STORE.orders (book_id, customer_id, quantity, total_price, order_date) VALUES
(1, 101, 2, 21.98, '2024-06-27 10:30:00'),
(2, 102, 1, 7.99, '2024-06-27 11:00:00'),
(3, 103, 3, 26.97, '2024-06-27 11:30:00');

-- Adds records to the `sales` table.
INSERT INTO BOOK_STORE.sales (book_id, sale_date, quantity, total_amount) VALUES
(1, '2024-06-27 10:30:00', 2, 21.98),
(2, '2024-06-27 11:00:00', 1, 7.99),
(3, '2024-06-27 11:30:00', 3, 26.97);
