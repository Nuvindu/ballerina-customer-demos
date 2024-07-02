import ballerina/sql;
import ballerinax/oracledb;
import ballerinax/oracledb.driver as _;
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
    oracledb:Client database = check new (host, user, password, databaseName, port);
    Book book = {
        book_id: "",
        title: "Sapiens",
        author: "Yual Noah Harari",
        price: "8.99",
        quantity: 75
    };

    sql:ParameterizedQuery query = 
        `INSERT INTO books (book_id, title, author, price, quantity) VALUES 
            (BOOK_SEQ.NEXTVAL, ${book.title}, ${book.author}, ${book.price}, ${book.quantity})`;
    sql:ExecutionResult execute = check database->execute(query);
    if execute.affectedRowCount < 1 {
        return error("Error occurred while inserting the record");
    }

    Book result = check database->queryRow(`SELECT * FROM books WHERE title = ${book.title}`);
    io:println("Book: ", result);
}
