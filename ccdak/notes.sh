docker exec -it kafka-0 bash
cd /opt/bitnami/kafka/bin/

####
#### chapter 3
####
./kafka-topics.sh --bootstrap-server localhost:9092 --list
./kafka-topics.sh --bootstrap-server localhost:9092 \
  --create --topic my-topic --partitions 3 --replication-factor 2
./kafka-topics.sh --bootstrap-server localhost:9092 \
  --describe --topic my-topic
# Topic: my-topic TopicId: OTbVsOoOR6aUdSOuI4Ws_Q PartitionCount: 3       ReplicationFactor: 2    Configs: 
#         Topic: my-topic Partition: 0    Leader: 0       Replicas: 0,2   Isr: 0,2
#         Topic: my-topic Partition: 1    Leader: 2       Replicas: 2,1   Isr: 2,1
#         Topic: my-topic Partition: 2    Leader: 1       Replicas: 1,0   Isr: 1,0

####
#### LAB Working with Kafka from Command Line
####
# Your supermarket company has a three-broker Kafka cluster. They want to use Kafka to track purchases so they can keep track of their inventory 
# and are working on some software that will interact with the Kafka cluster to produce and consume this data.
# However, before they can start using the cluster, they need you to create a topic to handle this data. 
# You will also need to test that everything is working by publishing some data to the topic, and then address consuming it. 
# Since the application is being built, you will need to do this using Kafka's command line tools.

# Create a topic that meets the following specifications:

# The topic name should be inventory_purchases.
# Number of partitions: 6
# Replication factor: 3
# Publish some test data to the topic. Since this is just a test, the data can be anything you want, but here is an example:

# product: apples, quantity: 5
# product: lemons, quantity: 7
# Set up a consumer from the command line and verify that you see the test data you published to the topic.

# This cluster is a confluent cluster, so you can access the Kafka command line utilities directly from the path, i.e. kafka-topics.

# If you get stuck, feel free to check out the solution video, or the detailed instructions under each objective. Good luck!

## create topic
./kafka-topics.sh --bootstrap-server localhost:9092 \
  --create --topic inventory_purchases --partitions 6 --replication-factor 3
./kafka-topics.sh --bootstrap-server localhost:9092 \
  --describe --topic inventory_purchases

## produce/consume data
./kafka-console-producer.sh --bootstrap-server localhost:9092 --topic inventory_purchases

product: apples, quantity: 5
product: lemons, quantity: 7

./kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic inventory_purchases --from-beginning

####
#### LAB Consuming Kafka Messages from Multiple Consumers
####
# Your supermarket company is getting ready to use Kafka to process purchase data to track changes in inventory. 
# When a customer purchases an item, data about the name of the item and quantity purchased will be published to a topic called inventory_purchases in the Kafka cluster.
# The company is working on determining the best way to consume this data, and they want you to perform a proof-of-concept for the proposed consumer setup. 
# Your task is to set up some consumers following a specified configuration, and then examine the message data processed by these consumers. 
# Lastly, you will store some sample data that demonstrates what messages get processed by each consumer.

# The system currently is set up so that a stream of sample data gets continuously produced to the topic.

# Consume the data according to the following specifications:

# Consume the data from the inventory_purchases topic.
# Set up a consumer and wait for it to process some data.
# Store the output in /home/cloud_user/output/group1_consumer1.txt.
# Set up a separate consumer group with two consumers in that group.
# Wait for them to process some messages simultaneously.
# Store the output in /home/cloud_user/output/group2_consumer1.txt and /home/cloud_user/output/group2_consumer2.txt.
# You have been given a three-broker Kafka cluster to complete this task but should perform all of your work on Broker 1.

# If you get stuck, feel free to check out the solution video, or the detailed instructions under each objective. Good luck!
./kafka-console-producer.sh --bootstrap-server localhost:9092 --topic inventory_purchases

product: apples, quantity: 5
product: lemons, quantity: 7


# single consumer
./kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic inventory_purchases --group group1 --from-beginning
# multiple consumers
./kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic inventory_purchases --group group2 --from-beginning

####
#### chapter 4
####
git clone https://github.com/linuxacademy/content-ccdak-kafka-java-connect.git -b end-state
./gradlew run

./kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic count-topic --from-beginning

git clone https://github.com/linuxacademy/content-ccdak-kafka-simple-consumer.git -b end-state


####
#### chapter 5
####
## s5_01_basic.py
./kafka-console-producer.sh --bootstrap-server localhost:9092 --topic streams-input-topic --property parse.key=true --property key.separator=@
{"mykey":"hello"}@{"myvalue": "world"}
{"mykey":"world"}@{"myvalue": "hello"}

./kafka-console-producer.sh --bootstrap-server localhost:9092 --topic streams-input-topic --property parse.key=true --property key.separator=:
hello:world

## s5_02_stateless.py
./kafka-console-producer.sh --bootstrap-server localhost:9092 --topic stateless-transformations-input-topic --property parse.key=true --property key.separator=:
akey:avalue
akey:bvalue
bkey:avalue

## s5_03_aggregation.py
./kafka-console-producer.sh --bootstrap-server localhost:9092 --topic aggregations-input-topic --property parse.key=true --property key.separator=:

a:a
b:hello
b:world
c:hello

./kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic aggregations-output-charactercount-topic --property print.key=true \
  --property value.deserializer=org.apache.kafka.common.serialization.IntegerDeserializer

./kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic aggregations-output-count-topic --property print.key=true \
  --property value.deserializer=org.apache.kafka.common.serialization.LongDeserializer

./kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic aggregations-output-reduce-topic --property print.key=true

## s5_04_join.py
./kafka-console-producer.sh --bootstrap-server localhost:9092 --topic joins-input-topic-left --property parse.key=true --property key.separator=:
a:a
b:foo

./kafka-console-producer.sh --bootstrap-server localhost:9092 --topic joins-input-topic-right --property parse.key=true --property key.separator=:
a:a
b:bar
c:foo

## s5_05_windowing.py
./kafka-console-producer.sh --bootstrap-server localhost:9092 --topic windowing-input-topic --property parse.key=true --property key.separator=:
a:a
b:hello
b:world
c:hello
c:world

b:hello

####
#### LAB Working with Stream Processing
####
git clone -b end-state https://github.com/linuxacademy/content-ccdak-kafka-streams-lab.git

# Your supermarket company is working toward using Kafka to automate some aspects of inventory management. 
# Currently, they are trying to use Kafka to keep track of purchases so that inventory systems can be updated as items are bought. 
# So far, the company has created a Kafka topic where they are publishing information about the types and quantities of items being purchased.

# When a customer makes a purchase, a record is published to the inventory_purchases topic for each item type (i.e., "apples"). 
# These records have the item type as the key and the quantity purchased in the transaction as the value. 
# An example record would look like this, indicating that a customer bought five apples:

# apples:5

# Your task is to build a Kafka streams application that will take the data about individual item purchases 
#   and output a running total purchase quantity for each item type. 
# The output topic is called total_purchases. So, for example, with the following input from inventory_purchases:

# apples:5
# oranges:2
# apples:3

# Your streams application should output the following to total_purchases:

# apples:8
# oranges:2

# Be sure to output the total quantity as an Integer. 
# Note that the input topic has the item quantity serialized as a String, so you will need to work around this using type conversion.

# To get started, use the starter project located at https://github.com/linuxacademy/content-ccdak-kafka-streams-lab. 
# This GitHub project also contains an end-state branch with an example solution for the lab.

# You should be able to perform all work on the Broker 1 server.

# If you get stuck, feel free to check out the solution video, or the detailed instructions under each objective. Good luck!

./kafka-topics.sh --bootstrap-server localhost:9092 --create --topic inventory-purchases

./kafka-console-producer.sh --bootstrap-server localhost:9092 --topic inventory-purchases --property parse.key=true --property key.separator=:

####
#### chapter 6
####

#### Kafka Config
### Broker Config
broker config - server.properties, command line, AdminClient API

read-only - require broker restart to get updated
per-broker - can be dynamically updated for each individual broker
cluster-wide - can be dynamically updated and applies to cluster as a whole

./kafka-configs.sh --bootstrap-server localhost:9092 --entity-type brokers --entity-name 1 --describe
# Dynamic configs for broker 1 are:
# - command line only shows updated (or different from default) configs

./kafka-configs.sh --bootstrap-server localhost:9092 --entity-type brokers --entity-name 1 --alter --add-config log.cleaner.threads=2
# Completed updating config for broker 1.

./kafka-configs.sh --bootstrap-server localhost:9092 --entity-type brokers --entity-name 1 --describe
# Dynamic configs for broker 1 are:
#   log.cleaner.threads=2 sensitive=false synonyms={DYNAMIC_BROKER_CONFIG:log.cleaner.threads=2, DEFAULT_CONFIG:log.cleaner.threads=1}

### Topic Config
topic config - kafka-topics or kafka-configs

all topic configs have a broker-wide default and will be used unless overriden
use --config argument

./kafka-topics.sh --bootstrap-server localhost:9092 --create --topic configured-topic --partitions 1 --replication-factor 1 --config max.message.bytes=64000
# Created topic configured-topic.

./kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics --entity-name configured-topic --describe
# Dynamic configs for topic configured-topic are:
#   max.message.bytes=64000 sensitive=false synonyms={DYNAMIC_TOPIC_CONFIG:max.message.bytes=64000, DEFAULT_CONFIG:message.max.bytes=1048588}

# override existing config
./kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics --entity-name configured-topic --alter --add-config max.message.bytes=65000
# Completed updating config for topic configured-topic.

./kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics --entity-name configured-topic --describe
# Dynamic configs for topic configured-topic are:
#   max.message.bytes=65000 sensitive=false synonyms={DYNAMIC_TOPIC_CONFIG:max.message.bytes=65000, DEFAULT_CONFIG:message.max.bytes=1048588}

## topic config can also take broker level default, message.max.bytes is cluster-wide config
./kafka-configs.sh --bootstrap-server localhost:9092 --entity-type brokers --entity-name 1 --alter --add-config message.max.bytes=66000
# Completed updating config for broker 1.

./kafka-configs.sh --bootstrap-server localhost:9092 --entity-type brokers --entity-name 1 --describe
# Dynamic configs for broker 1 are:
#   message.max.bytes=66000 sensitive=false synonyms={DYNAMIC_BROKER_CONFIG:message.max.bytes=66000, DEFAULT_CONFIG:message.max.bytes=1048588}
#   log.cleaner.threads=2 sensitive=false synonyms={DYNAMIC_BROKER_CONFIG:log.cleaner.threads=2, DEFAULT_CONFIG:log.cleaner.threads=1}

### Client Config
producer, consumer, stream, connect, admin client ... programmatically

###
### LAB Configuring Kafka Topics
###
# Your supermarket company is using Kafka to handle data related to inventory. 
# They have a topic called inventory_purchases that manages some of this data, 
# but initial testing has determined that some configuration changes are needed.

# Implement the following configuration changes in the cluster:

# For the inventory_purchases topic, it is more important to maintain availability than data consistency 
# since inventory errors can be reconciled later. 
# Turn on unclean.leader.election for the inventory_purchases topic (unclean.leader.election.enable=true).

# The majority of uses cases planned for this cluster do not require a lengthy retention period. 
# Set the default retention period for the cluster (log.retention.ms) to 3 days (259200000 ms).

# Change the retention period (retention.ms) for the existing inventory_purchases topic to 3 days (259200000 ms).

# If you get stuck, feel free to check out the solution video, or the detailed instructions under each objective. Good luck!

## create topic
./kafka-topics.sh --bootstrap-server localhost:9092 --create \
  --topic inventory_purchases --partitions 3 --replication-factor 3
# WARNING: Due to limitations in metric names, topics with a period ('.') or underscore ('_') could collide. To avoid issues it is best to use either, but not both.
# Created topic inventory_purchases.

## turn on unclean.leader.election
./kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics \
  --entity-name inventory_purchases --alter --add-config unclean.leader.election.enable=true
# Completed updating config for topic inventory_purchases.

./kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics --entity-name inventory_purchases --describe
# Dynamic configs for topic inventory_purchases are:
#   unclean.leader.election.enable=true sensitive=false synonyms={DYNAMIC_TOPIC_CONFIG:unclean.leader.election.enable=true, DEFAULT_CONFIG:unclean.leader.election.enable=false}

## update broker retention period
./kafka-configs.sh --bootstrap-server localhost:9092 --entity-type brokers --entity-name 1 \
  --alter --add-config log.retention.ms=259200000
# Completed updating config for broker 1.

./kafka-configs.sh --bootstrap-server localhost:9092 --entity-type brokers --entity-name 1 --describe
# Dynamic configs for broker 1 are:
#   log.retention.ms=259200000 sensitive=false synonyms={DYNAMIC_BROKER_CONFIG:log.retention.ms=259200000, STATIC_BROKER_CONFIG:log.retention.hours=168, DEFAULT_CONFIG:log.retention.hours=168}

## update topic retention period
./kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics \
  --entity-name inventory_purchases --alter --add-config retention.ms=259200000
# Completed updating config for topic inventory_purchases.

./kafka-configs.sh --bootstrap-server localhost:9092 --entity-type topics --entity-name inventory_purchases --describe
# Dynamic configs for topic inventory_purchases are:
#   retention.ms=259200000 sensitive=false synonyms={DYNAMIC_TOPIC_CONFIG:retention.ms=259200000}
#   unclean.leader.election.enable=true sensitive=false synonyms={DYNAMIC_TOPIC_CONFIG:unclean.leader.election.enable=true, DEFAULT_CONFIG:unclean.leader.election.enable=false}

###
### LAB Configuring Kafka Client
###
Your supermarket company has a Kafka producer application that is written in Java. 
You have been asked to implement some configuration changes in this application, and then execute it to test those changes. 
The base application code has already been written. You can clone a copy of the source code from GitHub to modify and test it. 
Implement the required configuration changes and run the program to verify that everything works as expected.

These are the configuration changes you will need to implement for the producer:

1. Set acks to all to ensure maximum data integrity in case a partition leader fails.
2. A smaller amount of memory needs to allocated for the producer to buffer messages. Set buffer.memory to 12582912 (about 12 MB).
3. The producer will need to clean up idle connections more quickly then the default setting specifies. 
Set connections.max.idle.ms to 300000 ms (5 minutes).

You can find the producer project code at https://github.com/linuxacademy/content-ccdak-kafka-client-config-lab.git. Clone this project into /home/cloud_user on Broker 1. The producer is implemented in the Main class located at src/main/java/com/linuxacademy/ccdak/client/config/Main.java.

You can execute the producer to test your changes by running this command while in the /home/cloud_user/content-ccdak-kafka-client-config-lab directory:

./gradlew run
If you want to view the output data published to the topic by the publisher, then use this command:

kafka-console-consumer --bootstrap-server localhost:9092 --topic inventory_purchases --property print.key=true --from-beginning
If you get stuck, feel free to check out the solution video, or the detailed instructions under each objective. Good luck!

# public class Main {
#     public static void main(String[] args) {
#         Properties props = new Properties();
#         props.put("bootstrap.servers", "localhost:9092");
#         props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
#         props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");
        
#         props.put("acks", "all");
#         props.put("buffer.memory", "12582912");
#         props.put("connections.max.idle.ms", "300000");
        
#         Producer<String, String> producer = new KafkaProducer<>(props);
#         producer.send(new ProducerRecord<>("inventory_purchases", "apples", "1"));
#         producer.send(new ProducerRecord<>("inventory_purchases", "apples", "3"));
#         producer.send(new ProducerRecord<>("inventory_purchases", "oranges", "12"));
#         producer.send(new ProducerRecord<>("inventory_purchases", "bananas", "25"));
#         producer.send(new ProducerRecord<>("inventory_purchases", "pears", "15"));
#         producer.send(new ProducerRecord<>("inventory_purchases", "apples", "6"));
#         producer.send(new ProducerRecord<>("inventory_purchases", "pears", "7"));
#         producer.send(new ProducerRecord<>("inventory_purchases", "oranges", "1"));
#         producer.send(new ProducerRecord<>("inventory_purchases", "grapes", "56"));
#         producer.send(new ProducerRecord<>("inventory_purchases", "oranges", "11"));
#         producer.close();
#     }
# }

####
#### chapter 7
####

###
### LAB Building a Kafka Producer
###

# Your supermarket company is using Kafka to manage data related to inventory. 
# They have some files containing data about transactions and want you to build a producer 
#   that is capable of reading these files and publishing the data to Kafka.

# There is a sample transaction log file containing an example of some of this data. 
# The file contains data in the format <product>:<quantity>, for example: apples:5. 
# Each line in the file represents a new transaction. 

# Build a producer that reads each line in the file and publishes a record to the inventory_purchases topic. 
# Use the product name as the key and the quantity as the value.

# The company also wants to track purchases of apples in a separate topic (in addition to the inventory_purchases topic). 
# So, for records that have a key of apples, publish them both to the inventory_purchases and the apple_purchases topic.

# Finally, to maintain maximum data integrity set acks to all for your producer.

# There is a starter project located in GitHub which you can use to implement your producer: https://github.com/linuxacademy/content-ccdak-kafka-producer-lab.git. 

# Clone this project and implement the producer in its Main class. 
# You can execute the main class from the project directory with the ./gradlew run command.

# The sample transaction log file can be found inside the starter project at src/main/resources/sample_transaction_log.txt.

# If you get stuck, feel free to check out the solution video, or the detailed instructions under each objective. Good luck!

###
### LAB Building a Kafka Consumer
###

# Your supermarket company is using Kafka to process inventory data. 
# They have a topic called inventory_purchases which is receiving data about the items being purchased and the quantity. 
# However, there is still a legacy system which must ingest this data in the form of a data file.

# You have been asked to create a consumer that will read the data from the topic and output to a data file. 
# Each record should be on its own line, and should have the following format:

# key=<key>, value=<value>, topic=<topic>, partition=<partition>, offset=<offset>

# There is a starter project located in GitHub which you can use to implement your producer: https://github.com/linuxacademy/content-ccdak-kafka-consumer-lab.git. Clone this project and implement the consumer in its Main class. You can execute the main class from the project directory with the ./gradlew run command.

# The output data should go into the following file: /home/cloud_user/output/output.dat.

# If you get stuck, feel free to check out the solution video, or the detailed instructions under each objective. Good luck!

####
#### chapter 8
####
# https://docs.confluent.io/5.2.4/quickstart/ce-docker-quickstart.html
# https://github.com/confluentinc/cp-all-in-one/blob/7.3.0-post/cp-all-in-one/docker-compose.yml
# https://docs.confluent.io/platform/current/kafka-rest/quickstart.html

### producing message
./kafka-topics.sh --bootstrap-server localhost:9092 --create \
  --topic jsontest --partitions 1 --replication-factor 1

curl -X POST \
  -H "Content-Type: application/vnd.kafka.json.v2+json" \
  --data '{"records": [{"key": "message", "value": "Hello"}, {"key": "message", "value": "World"}]}' \
  "http://localhost:8082/topics/jsontest"
# {"offsets":[{"partition":0,"offset":0,"error_code":null,"error":null},{"partition":0,"offset":1,"error_code":null,"error":null}],"key_schema_id":null,"value_schema_id":null}

./kafka-console-consumer.sh --bootstrap-server localhost:9092 \
  --topic jsontest --from-beginning --property print.key=true

### consuming messages
# 1. create a consumer (jsontest) and consumer instance (jsontest_instance)
curl -X POST \
  -H "Content-Type: application/vnd.kafka.v2+json" \
  --data '{"name": "jsontest_instance", "format": "json", "auto.offset.reset": "earliest"}' \
  http://localhost:8082/consumers/jsontest
# {"instance_id":"jsontest_instance","base_uri":"http://localhost:8082/consumers/jsontest/instances/jsontest_instance"}

# 2. subscribe the consumer instance to a topic - can subscribe multiple topics
curl -X POST \
  -H "Content-Type: application/vnd.kafka.v2+json" \
  --data '{"topics":["jsontest"]}' \
  http://localhost:8082/consumers/jsontest/instances/jsontest_instance/subscription

# 3. consume messages
curl -X GET \
  -H "Accept: application/vnd.kafka.json.v2+json" \
  http://localhost:8082/consumers/jsontest/instances/jsontest_instance/records
# [{"topic":"jsontest","key":"message","value":"Hello","partition":0,"offset":0},{"topic":"jsontest","key":"message","value":"World","partition":0,"offset":1}]

# 4. close consumer
curl -X DELETE \
  -H "Content-Type: application/vnd.kafka.v2+json" \
  http://localhost:8082/consumers/jsontest/instances/jsontest_instance

###
### Producing Kafka Messages with Confluent REST Proxy
###
# Your supermarket company is using Kafka to handle messaging as part of its infrastructure. 
# Recently, some data was lost before it could be published to Kafka due to a power failure in a data center. 
# You have been asked to publish these lost records to the necessary topics manually. 
# Luckily, Confluent REST Proxy is installed and can be used to interact with Kafka using simple HTTP requests easily.

# Using Confluent REST Proxy, publish the following records to the Kafka cluster.

# Publish to the inventory_purchases topic:
# Key: apples, Value: 23
# Key: grapes, Value: 160

# Publish to the member_signups topic:
# Key: 77543, Value: Rosenberg, Willow
# Key: 56878, Value: Giles, Rupert

## inventory purchases
./kafka-topics.sh --bootstrap-server localhost:9092 --create \
  --topic inventory_purchases --partitions 1 --replication-factor 1

curl -X POST \
  -H "Content-Type: application/vnd.kafka.json.v2+json" \
  --data '{"records": [{"key": "apples", "value": "23"}, {"key": "grapes", "value": "160"}]}' \
  http://localhost:8082/topics/inventory_purchases

./kafka-console-consumer.sh --bootstrap-server localhost:9092 \
  --topic inventory_purchases --from-beginning --property print.key=true

## member signups
./kafka-topics.sh --bootstrap-server localhost:9092 --create \
  --topic member_signups --partitions 1 --replication-factor 1

curl -X POST \
  -H "Content-Type: application/vnd.kafka.json.v2+json" \
  --data '{"records": [{"key": "77543", "value": "Rosenberg, Willow"}, {"key": "56878", "value": "Giles, Rupert"}]}' \
  http://localhost:8082/topics/member_signups

./kafka-console-consumer.sh --bootstrap-server localhost:9092 \
  --topic member_signups --from-beginning --property print.key=true

###
### Consuming Kafka Messages with Confluent REST Proxy
###
# Your supermarket company is using Kafka to handle messaging as part of its infrastructure. 
# They want to prepare a report that requires some data that is currently stored in Kafka.

# You have been asked to access the cluster and provide some data points that will be used in this report. 
# Luckily, the Confluent REST Proxy will make it easy for you to gather the necessary data using simple HTTP requests. 
# Obtain the requested data points and place them in the specified output files.

# First, the report will need to include the number of apples sold in the last week. 
# This information can be found in a topic called weekly_sales. The records in this topic represent aggregate data. 
# Find the latest record with a key of apples and write its value to the file located at /home/cloud_user/output/apple_sales.txt.

# Secondly, the report needs to include the current quarterly balance for product purchases. 
# Read from the topic called quarterly_purchases. 
# Find the latest record and write its value to the file located at /home/cloud_user/output/quarterly_balance.txt.

# If you get stuck, feel free to check out the solution video, or the detailed instructions under each objective. Good luck!

# >>> Will just read records from those that are created in the previous lab.

# 1. create a consumer
curl -X POST \
  -H "Content-Type: application/vnd.kafka.v2+json" \
  --data '{"name": "lab_instance", "format": "json", "auto.offset.reset": "earliest"}' \
  http://localhost:8082/consumers/lab

# 2. subscribe the consumer instance to topics
curl -X POST \
  -H "Content-Type: application/vnd.kafka.v2+json" \
  --data '{"topics":["inventory_purchases", "member_signups"]}' \
  http://localhost:8082/consumers/lab/instances/lab_instance/subscription

# 3. consume messages
curl -X GET \
  -H "Accept: application/vnd.kafka.json.v2+json" \
  http://localhost:8082/consumers/lab/instances/lab_instance/records
# [{"topic":"member_signups","key":"77543","value":"Rosenberg, Willow","partition":0,"offset":0},{"topic":"member_signups","key":"56878","value":"Giles, Rupert","partition":0,"offset":1},{"topic":"inventory_purchases","key":"apples","value":"23","partition":0,"offset":0},{"topic":"inventory_purchases","key":"grapes","value":"160","partition":0,"offset":1}]

# 4. close consumer
curl -X DELETE \
  -H "Content-Type: application/vnd.kafka.v2+json" \
  http://localhost:8082/consumers/lab/instances/lab_instance

####
#### chapter 9
####
# Confluent Schema Registry is a versioned, distributed storage for Apache Avro schemas.

# These schemas define an expected format for your data 
#   and can be used for serialize and deserialize complex data formats when interacting with Kafka.

# Avro schemas allow producers to specify a complex format for published data, 
#   and consumers can use the schema to interprete this data. Both communicate with the schema registry
#   to store and retrieve these schemas.

# Schemas can be applied to both keys and values in messages.

# Compatibility
# Backward
# - update consumer followed by update producer
# - because consumer w/ updated schema can read data w/ current schema
# Forward 
# - update producer followed by update consumer
# - because consumer w/ current schema can read data w/ updated schema