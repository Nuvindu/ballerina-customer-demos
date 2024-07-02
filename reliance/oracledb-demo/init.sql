CONNECT oracle/dummypassword@localhost:1521/XEPDB1

ALTER SESSION SET CURRENT_SCHEMA = BOOK_STORE;

-- Creates `books` table in the schema.
CREATE TABLE books (
    book_id NUMBER PRIMARY KEY,
    title VARCHAR2(255) NOT NULL,
    author VARCHAR2(255) NOT NULL,
    price NUMBER(10, 2) NOT NULL,
    quantity NUMBER NOT NULL CHECK (quantity > 0)
);

-- Creates `orders` table in the schema.
CREATE TABLE orders (
    order_id NUMBER PRIMARY KEY,
    book_id NUMBER NOT NULL,
    customer_id NUMBER NOT NULL,
    quantity NUMBER NOT NULL CHECK (quantity > 0),
    total_price NUMBER(10, 2) NOT NULL,
    order_date TIMESTAMP NOT NULL,
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

-- Creates `sales` table in the schema.
CREATE TABLE sales (
    sale_id NUMBER PRIMARY KEY,
    book_id NUMBER NOT NULL,
    sale_date TIMESTAMP NOT NULL,
    quantity NUMBER NOT NULL CHECK (quantity > 0),
    total_amount NUMBER(10, 2) NOT NULL,
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

CREATE SEQUENCE BOOK_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE ORDER_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SALE_SEQ START WITH 1 INCREMENT BY 1;

ALTER TABLE books ADD CONSTRAINT check_books_quantity CHECK (quantity > 0);
ALTER TABLE sales ADD CONSTRAINT check_sales_quantity CHECK (quantity > 0);
ALTER TABLE orders ADD CONSTRAINT check_orders_quantity CHECK (quantity > 0);

-- Adds records to the `books` table.
INSERT INTO books (book_id, title, author, price, quantity) VALUES
(BOOK_SEQ.NEXTVAL, 'Crime And Punishment', 'Fyodor Dostoevsky', 10.99, 50);
INSERT INTO books (book_id, title, author, price, quantity) VALUES
(BOOK_SEQ.NEXTVAL, 'A Game of Thrones', 'George R.R. Martin', 7.99, 30);
INSERT INTO books (book_id, title, author, price, quantity) VALUES
(BOOK_SEQ.NEXTVAL, '1984', 'George Orwell', 8.99, 40);

-- Adds records to the `orders` table.
INSERT INTO orders (order_id, book_id, customer_id, quantity, total_price, order_date) VALUES
(ORDER_SEQ.NEXTVAL, 1, 101, 2, 21.98, TO_TIMESTAMP('2024-06-27 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO orders (order_id, book_id, customer_id, quantity, total_price, order_date) VALUES
(ORDER_SEQ.NEXTVAL, 2, 102, 1, 7.99, TO_TIMESTAMP('2024-06-27 11:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO orders (order_id, book_id, customer_id, quantity, total_price, order_date) VALUES
(ORDER_SEQ.NEXTVAL, 3, 103, 3, 26.97, TO_TIMESTAMP('2024-06-27 11:30:00', 'YYYY-MM-DD HH24:MI:SS'));

-- Adds records to the `sales` table.
INSERT INTO sales (sale_id, book_id, sale_date, quantity, total_amount) VALUES
(SALE_SEQ.NEXTVAL, 1, TO_TIMESTAMP('2024-06-27 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 21.98);
INSERT INTO sales (sale_id, book_id, sale_date, quantity, total_amount) VALUES
(SALE_SEQ.NEXTVAL, 2, TO_TIMESTAMP('2024-06-27 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 7.99);
INSERT INTO sales (sale_id, book_id, sale_date, quantity, total_amount) VALUES
(SALE_SEQ.NEXTVAL, 3, TO_TIMESTAMP('2024-06-27 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 26.97);
