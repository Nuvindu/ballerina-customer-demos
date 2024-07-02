import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/io;

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
    Book book = {
        book_id: "",
        title: "Sapiens",
        author: "Yual Noah Harari",
        price: "8.99",
        quantity: 75
    };
    sql:ParameterizedQuery query = 
        `INSERT INTO books (title, author, price, quantity) 
            VALUES (${book.title}, ${book.author}, ${book.price}, ${book.quantity})`;
    sql:ExecutionResult execute = check database->execute(query);
    if execute.affectedRowCount < 1 {
        return error("Error occurred while inserting the record");
    }

    Book result = check database->queryRow(`SELECT * FROM books WHERE title = ${book.title} and author = ${book.author}`);
    io:println("Book: ", result);

    sql:ExecutionResult _ = check database->execute(
        `UPDATE books SET price = 10.99 WHERE book_id = ${result.book_id}`);

    sql:ExecutionResult _ = check database->execute(`DELETE FROM books WHERE book_id = ${result.book_id}`);
}
