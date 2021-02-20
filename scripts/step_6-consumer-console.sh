#!/bin/bash

cd /kafka
bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic NETFLOW