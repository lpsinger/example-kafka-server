#!/bin/bash
mkdir -p /var/{lib,log}/kafka/{broker,zookeeper}
echo $SERVER_ID > /var/lib/kafka/zookeeper/myid
LOG_DIR=/var/log/kafka/zookeeper zookeeper-server-start.sh -daemon /usr/local/config/zookeeper.properties
LOG_DIR=/var/log/kafka/broker kafka-server-start.sh /usr/local/config/server.properties -override broker.id=$SERVER_ID
