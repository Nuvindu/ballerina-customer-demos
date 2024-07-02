import ballerina/ftp;
import ballerina/io;

configurable string host = ?;
configurable int port = ?;
configurable string username = ?;
configurable string password = ?;
configurable string fileName = ?;

public function main() returns error? {
    ftp:Client fileClient = check new ({
        host,
        port,
        auth: {
            credentials: {
                username,
                password
            }
        }
    });

    stream<io:Block, io:Error?> fileStream = check io:fileReadBlocksAsStream("./local/logFile.txt", 1024);
    check fileClient->put(fileName, fileStream);
    check fileStream.close();
}
