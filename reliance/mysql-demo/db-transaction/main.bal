import ballerina/io;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

configurable string host = ?;
configurable string user = ?;
configurable string password = ?;
configurable string databaseName = ?;
configurable int port = ?;

type Book record {|
    string book_id;
    string title;
    string author;
    string price;
    int quantity;
|};

public function main() returns error? {
    mysql:Client database = check new (host, user, password, databaseName, port);
    string bookTitle = "Crime and Punishment";
    string author = "Fyodor Dostoevsky";
    int quantity = 1;

    transaction {
        sql:ParameterizedQuery query = `SELECT book_id FROM books WHERE title = ${bookTitle} and author = ${author}`;
        int bookId = check database->queryRow(query);
        int availableQuantity = check database->queryRow(`SELECT quantity FROM books WHERE book_id = ${bookId}`);
        if availableQuantity < quantity {
            rollback;
            io:println("Book is not available");
        } else {
            _ = check database->execute(
                `INSERT INTO orders (book_id, customer_id, quantity, total_price, order_date) 
                    VALUES (${bookId}, 123, 1, (SELECT price FROM books WHERE book_id = ${bookId}), NOW())`);

            _ = check database->execute(
                `INSERT INTO sales (book_id, sale_date, quantity, total_amount)
                    VALUES (${bookId}, NOW(), 1, (SELECT price FROM books WHERE book_id = ${bookId}))`);

            _ = check database->execute(`UPDATE books SET quantity = quantity - 1 WHERE book_id = ${bookId}`);
            check commit;
            io:println("Transaction is successful");
        }
    } on fail error e {
        return error(string `Transaction is failed: ${e.message()}`);
    }
}
