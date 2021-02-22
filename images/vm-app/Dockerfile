FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install curl wget -y

# Setup JAVA
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME
RUN $JAVA_HOME/bin/java -version


# Install Spark
RUN wget https://archive.apache.org/dist/spark/spark-2.3.0/spark-2.3.0-bin-hadoop2.7.tgz
RUN tar -xzvf spark-2.3.0-bin-hadoop2.7.tgz
RUN rm -rf spark-2.3.0-bin-hadoop2.7.tgz
RUN mv spark-2.3.0-bin-hadoop2.7 spark
ENV PATH=$PATH:/spark/sbin

COPY ./volumes/spark/spark-env.sh /spark/conf/spark-env.sh
COPY ./volumes/spark/sparkKafka.py /spark/python/sparkKafka.py
COPY ./volumes/spark/sparkMachineLearning.py /spark/python/sparkMachineLearning.py

# Install Elastic Search
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.2.3.tar.gz
RUN tar -xvzf elasticsearch-6.2.3.tar.gz
RUN rm -rf elasticsearch-6.2.3.tar.gz
RUN mv elasticsearch-6.2.3 elasticsearch

COPY ./volumes/elasticsearch/logging.yml /elasticsearch/config/
COPY ./volumes/elasticsearch/elasticsearch.yml /elasticsearch/config/
ENV PATH=$PATH:/elasticsearch/bin

# Setup local user to run ES
RUN groupadd -g 1000 elasticsearch 
RUN useradd elasticsearch -u 1000 -g 1000

WORKDIR /elasticsearch
RUN set -ex && for path in data logs config config/scripts; do \
    mkdir -p "$path"; \
    chown -R elasticsearch:elasticsearch "$path"; \
    done

WORKDIR /

# Install libraries
RUN apt-get install python-setuptools -y
RUN curl https://bootstrap.pypa.io/2.7/get-pip.py --output get-pip.py
RUN python get-pip.py
RUN pip install elasticsearch
RUN pip install --user numpy
RUN pip install --user pyspark
RUN pip install --user requests
RUN pip install --user sklearn
RUN pip install --user pandas


# Install Kibana
RUN wget https://artifacts.elastic.co/downloads/kibana/kibana-6.2.3-linux-x86_64.tar.gz
RUN tar -xvzf kibana-6.2.3-linux-x86_64.tar.gz
RUN rm -rf kibana-6.2.3-linux-x86_64.tar.gz
RUN mv kibana-6.2.3* kibana

COPY ./volumes/kibana/kibana.yml /kibana/config/
ENV PATH=$PATH:/kibana/bin


# Install Logstash
RUN wget https://artifacts.elastic.co/downloads/logstash/logstash-6.2.4.tar.gz
RUN tar -xvzf logstash-6.2.4.tar.gz
RUN rm -rf logstash-6.2.4.tar.gz
RUN mv logstash-6.2.4 logstash

COPY ./volumes/logstash/logstash.yml /logstash/config/
ENV PATH=$PATH:/logstash/bin


# Install Stream Sets
RUN wget https://archives.streamsets.com/datacollector/3.1.2.0/tarball/streamsets-datacollector-core-3.1.2.0.tgz
RUN tar -xvzf streamsets-datacollector-core-3.1.2.0.tgz
RUN rm -rf streamsets-datacollector-core-3.1.2.0.tgz
RUN mv streamsets-datacollector-3.1.2.0 streamsets

ENV PATH=$PATH:/streamsets/bin


# Install Kafka
RUN wget https://archive.apache.org/dist/kafka/1.0.0/kafka_2.11-1.0.0.tgz
RUN tar -xvzf kafka_2.11-1.0.0.tgz
RUN rm -rf kafka_2.11-1.0.0.tgz
RUN mv kafka_2.11-1.0.0 kafka

COPY ./volumes/kafka/server.properties /kafka/config/


# 
COPY ./scripts /scripts
WORKDIR /scripts

USER elasticsearch
EXPOSE 9200 9300 5601 18630