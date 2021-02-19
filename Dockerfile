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


RUN /elasticsearch-6.2.3/bin/elasticsearch &

WORKDIR /kibana-6.2.3-linux-x86_64
ENTRYPOINT ["bin/kibana"]
EXPOSE 5601