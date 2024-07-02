import ballerina/ftp;
import ballerina/io;

configurable string host = ?;
configurable int port = ?;
configurable string username = ?;
configurable string password = ?;
configurable string fileName = ?;
configurable string privateKeyPath = ?;

public function main() returns error? {
    ftp:Client fileClient = check new ({
        protocol: ftp:SFTP,
        host,
        port,
        auth: {
            credentials: {
                username,
                password
            },
            privateKey: {
                path: privateKeyPath
            }
        }
    });

    stream<io:Block, io:Error?> fileStream = check io:fileReadBlocksAsStream("./local/log_file.txt", 1024);
    check fileClient->put(string `/upload/${fileName}`, fileStream);
    check fileStream.close();
}
