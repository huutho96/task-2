#!/bin/bash


cd /spark
bin/spark-submit --packages org.apache.spark:spark-streaming-kafka-0-8_2.11:2.3.0 python/sparkMachineLearning.py | grep -v INFO | grep -v WARN