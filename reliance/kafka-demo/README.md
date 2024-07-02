# [Ballerina] Order Management System

## Prerequisites

- Ballerina Swan Lake Update 8+

## Deploying the system

### 1. Start a Kafka broker instance

Run the following docker command to start a Kafka broker.

```sh
    docker compose up
```

### 2. Run the Kafka service

Execute the following command in the project directory.

```ballerina
bal run producer.bal
```

### 3. Run the Kafka consumer

Execute the following command in the project directory in another terminal.

```ballerina
bal run consumer.bal
```

### 4. Produce data to a Kafka topic

Use the following cURL command to produce data for a Kafka topic.

```curl
curl http://localhost:9090/orders -H "Content-type:application/json" -d "{\"orderId\": 1, \"productName\": \"New Order\", \"price\": 27.5, \"isValid\": true}"
```
