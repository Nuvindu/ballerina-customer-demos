import ballerinax/oracledb;
import ballerinax/oracledb.driver as _;
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
    oracledb:Client database = check new (host, user, password, databaseName, port);
    string bookTitle = "Crime and Punishment";
    string author = "Fyodor Dostoevsky";
    int quantity = 1000;

    transaction {
        sql:ParameterizedQuery query = 
            `SELECT book_id FROM books WHERE LOWER(title) = LOWER(${bookTitle}) and LOWER(author) = LOWER(${author})`;
        int bookId = check database->queryRow(query);

        _ = check database->execute(
            `INSERT INTO orders (order_id, book_id, customer_id, quantity, total_price, order_date) 
                VALUES (ORDER_SEQ.NEXTVAL, ${bookId}, 123, ${quantity}, 
                    (SELECT price FROM books WHERE book_id = ${bookId}), SYSTIMESTAMP)`);

        _ = check database->execute(
            `INSERT INTO sales (sale_id, book_id, sale_date, quantity, total_amount) 
                VALUES (SALE_SEQ.NEXTVAL, ${bookId}, SYSTIMESTAMP, 1, 
                    (SELECT price FROM books WHERE book_id = ${bookId}))`);

        _ = check database->execute(`UPDATE books SET quantity = quantity - ${quantity} WHERE book_id = ${bookId}`);
        check commit;
        io:println("Transaction is successful");
    } on fail error e {
        return error(string `Transaction is failed: ${e.message()}`);
    }
}
