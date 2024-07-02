import ballerina/ftp;
import ballerina/io;

configurable string host = ?;
configurable int port = ?;
configurable string username = ?;
configurable string password = ?;
configurable string fileNamePattern = ?;

listener ftp:Listener fileListener = check new ({
    protocol: ftp:FTP,
    host,
    port,
    auth: {
        credentials: {
            username,
            password
        }
    },
    fileNamePattern
});

service on fileListener {
    remote function onFileChange(ftp:WatchEvent & readonly event, ftp:Caller caller) returns error? {
        foreach ftp:FileInfo addedFile in event.addedFiles {
            io:println("New file is added: " + addedFile.pathDecoded);
        }
    }
}
