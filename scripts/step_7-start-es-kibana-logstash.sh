#!/bin/bash

elasticsearch &
kibana &
logstash --modules netflow --setup