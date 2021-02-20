#!/bin/bash

cd /kafka
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic NETFLOW
bin/kafka-topics.sh --list --zookeeper localhost:2181