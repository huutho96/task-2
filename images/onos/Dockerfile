# Install Bazel, https://bazel.build/versions/master/docs/install.html#ubuntu
FROM openjdk:8

RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list \
    && curl https://bazel.build/bazel-release.pub.gpg | apt-key add -

RUN apt-get update \
    && apt-get install -y bazel-3.7.2 \
    && rm -rf /var/lib/apt/lists/*

# Set up workspace
RUN mkdir -p /usr/src/app
ENV WORKSPACE /usr/src/app
WORKDIR /usr/src/app

RUN git clone https://gerrit.onosproject.org/onos
WORKDIR /usr/src/app/onos
RUN echo "#!/bin/bash" >> ~/.bash_profile
RUN echo "export ONOS_ROOT=\"`pwd`\"" >> ~/.bash_profile
RUN echo "source $ONOS_ROOT/tools/dev/bash_profile" >> ~/.bash_profile

RUN apt-get update
RUN apt-get install zip unzip -y
RUN bazel-3.7.2 build onos