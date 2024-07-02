import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/io;
import ballerina/sql;

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
    int quantity = 1000;

    transaction {
        sql:ParameterizedQuery query = `SELECT book_id FROM books WHERE title = ${bookTitle} and author = ${author}`;
        int bookId = check database->queryRow(query);

        _ = check database->execute(
            `INSERT INTO orders (book_id, customer_id, quantity, total_price, order_date)
                VALUES (${bookId}, 123, ${quantity}, (SELECT price FROM books WHERE book_id = ${bookId}), NOW())`);

        _ = check database->execute(
            `INSERT INTO sales (book_id, sale_date, quantity, total_amount)
                VALUES (${bookId}, NOW(), ${quantity}, (SELECT price FROM books WHERE book_id = ${bookId}))`);

        _ = check database->execute(`UPDATE books SET quantity = quantity - ${quantity} WHERE book_id = ${bookId}`);
        check commit;
        io:println("Transaction is successful");
    } on fail error e {
        return error(string `Transaction is failed: ${e.message()}`);
    }
}
