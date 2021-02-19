FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install curl wget -y

# Setup JAVA
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME
RUN $JAVA_HOME/bin/java -version


# Install spark
RUN wget https://archive.apache.org/dist/spark/spark-2.3.0/spark-2.3.0-bin-hadoop2.7.tgz
RUN tar -xzvf spark-2.3.0-bin-hadoop2.7.tgz
COPY ./volumes/spark/spark-env.sh /spark-2.3.0-bin-hadoop2.7/conf/spark-env.sh
COPY ./volumes/spark/sparkKafka.py /spark-2.3.0-bin-hadoop2.7/python/sparkKafka.py

# Install Elastic Search
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.2.3.tar.gz
RUN tar -xvzf elasticsearch-6.2.3.tar.gz

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

# Setup local user to run ES
RUN groupadd -g 1000 elasticsearch 
RUN useradd elasticsearch -u 1000 -g 1000

WORKDIR /elasticsearch-6.2.3
RUN set -ex && for path in data logs config config/scripts; do \
    mkdir -p "$path"; \
    chown -R elasticsearch:elasticsearch "$path"; \
    done

COPY ./volumes/elasticsearch/logging.yml /elasticsearch-6.2.3/config/
COPY ./volumes/elasticsearch/elasticsearch.yml /elasticsearch-6.2.3/config/
COPY ./volumes/kibana/kibana.yml /kibana-6.2.3-linux-x86_64/config/


ENV PATH=$PATH:/elasticsearch-6.2.3/bin
ENV PATH=$PATH:/kibana-6.2.3-linux-x86_64/bin
WORKDIR /

# Install Logstash
RUN wget https://artifacts.elastic.co/downloads/logstash/logstash-6.2.4.tar.gz
RUN tar -xvzf logstash-6.2.4.tar.gz

COPY ./volumes/logstash/logstash.yml /logstash-6.2.4/config/
ENV PATH=$PATH:/logstash-6.2.4/bin


# Install Stream Sets
RUN wget https://archives.streamsets.com/datacollector/3.1.2.0/tarball/streamsets-datacollector-core-3.1.2.0.tgz
RUN tar -xvzf streamsets-datacollector-core-3.1.2.0.tgz


# Install Kafka
RUN wget https://archive.apache.org/dist/kafka/1.0.0/kafka_2.11-1.0.0.tgz
RUN tar -xvzf kafka_2.11-1.0.0.tgz

USER elasticsearch
COPY ./entry.sh /entry.sh
ENTRYPOINT ["/entry.sh"]


EXPOSE 9200 9300 5601