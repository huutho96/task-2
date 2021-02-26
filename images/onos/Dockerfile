# Install Bazel, https://bazel.build/versions/master/docs/install.html#ubuntu
FROM openjdk:8

RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list \
    && curl https://bazel.build/bazel-release.pub.gpg | apt-key add -

RUN apt-get update \
    && apt-get install -y bazel-3.7.2 \
    && rm -rf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get install zip unzip maven -y

# Set up workspace
RUN mkdir -p /usr/src/app
ENV WORKSPACE /usr/src/app
WORKDIR /usr/src/app

RUN git clone https://gerrit.onosproject.org/onos
WORKDIR /usr/src/app/onos

RUN echo "export ONOS_ROOT=\"/usr/src/app/onos\"" >> ~/.bash_profile
RUN echo "source /usr/src/app/onos/tools/dev/bash_profile" >> ~/.bash_profile

RUN /bin/bash -c "source ~/.bash_profile"
RUN bazel-3.7.2 build onos

ENV ONOS_POM_VERSION=2.0.0
ENV PATH=$PATH:/usr/src/app/onos/tools/dev/bin
ENV PATH=$PATH:/usr/src/app/onos/tools/package/runtime/bin

RUN /bin/bash -c "source ~/.bash_profile"

RUN onos-create-app app org.foo foo-app 1.0-SNAPSHOT org.foo.app -DarchetypeCatalog=internal
WORKDIR /usr/src/app/onos/foo-app
RUN mvn clean install
# RUN onos-app localhost install! foo-app/target/foo-app-1.0-SNAPSHOT.oar
