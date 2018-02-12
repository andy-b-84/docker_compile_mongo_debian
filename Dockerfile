FROM debian:9

VOLUME ["/out"]

ENV DEBIAN_FRONTEND=noninteractive
ENV FORCE_UNSAFE_CONFIGURE=1
ENV SHELL=/bin/bash

ARG MONGODB_RELEASE=r3.4.11

RUN apt-get -y update \
 && apt-get -y upgrade \
 && apt-get -y install build-essential \
                    gcc \
                    libc6-dev \
                    libssl-dev \
                    python \
                    python-pip \
                    python3 \
                    python3-pip \
                    scons

RUN apt-get install -y git

RUN git clone https://github.com/mongodb/mongo.git

WORKDIR /mongo
RUN git checkout tags/${MONGODB_RELEASE}

RUN pip2 install --user regex

RUN scons mongo mongod mongos --disable-warnings-as-errors -j 8

WORKDIR /
RUN git clone https://github.com/mongodb/mongo-tools.git

WORKDIR /mongo-tools
RUN git checkout tags/${MONGODB_RELEASE}

SHELL ["/bin/bash", "-c"]
RUN apt-get install -y golang-go \
                       libpcap-dev \
 && echo OK: apt-get install \
 && source /mongo-tools/set_gopath.sh \
 && echo OK: source \
 && go build -o bin/bsondump bsondump/main/bsondump.go \
 && echo OK: bsondump \
 && go build -o bin/mongodump mongodump/main/mongodump.go \
 && echo OK: mongodump \
 && go build -o bin/mongoexport mongoexport/main/mongoexport.go \
 && echo OK: mongoexport \
 && go build -o bin/mongofiles mongofiles/main/mongofiles.go \
 && echo OK: mongofiles \
 && go build -o bin/mongoimport mongoimport/main/mongoimport.go \
 && echo OK: mongoimport \
 && go build -o bin/mongooplog mongooplog/main/mongooplog.go \
 && echo OK: mongooplog \
 && go build -o bin/mongoreplay mongoreplay/main/mongoreplay.go \
 && echo OK: mongoperf \
 && go build -o bin/mongorestore mongorestore/main/mongorestore.go \
 && echo OK: mongorestore \
 && go build -o bin/mongostat mongostat/main/mongostat.go \
 && echo OK: mongostat \
 && go build -o bin/mongotop mongotop/main/mongotop.go \
 && echo OK: mongotop

COPY copy.sh /

WORKDIR /

CMD /bin/bash