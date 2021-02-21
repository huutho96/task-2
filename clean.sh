#!/bin/bash
rm -rf volumes/elasticsearch/data/*
rm -rf volumes/elasticsearch/logs/*
rm -rf volumes/kibana/data/*
rm -rf volumes/logstash/data/*
rm -rf volumes/logstash/logs/*
sudo rm -rf volumes/streamsets/log/*
sudo rm -rf volumes/streamsets/data/*