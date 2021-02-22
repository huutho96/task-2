#!/bin/bash

cd /spark
sbin/start-master.sh
sbin/start-slave.sh spark://louis:7077