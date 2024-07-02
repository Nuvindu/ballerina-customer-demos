# [Ballerina] MySQL Database Integration

## Prerequisites

- Ballerina Swan Lake Update 8+

## Use Case 1: Basic Database Access

This implementation accesses a MySQL database with credentials inserts a new record into a table and then retrieves it.

![Database Access](../resources/db_access.png)

## Deploying the system

### 1. Setup a MySQL Database

Run the following docker command to set up the MySQL database.

```sh
    docker compose up
```

### 2. Run the Ballerina project

Navigate to the db-integration directory and run the Ballerina project.

```ballerina
cd db-integration
bal run
```
