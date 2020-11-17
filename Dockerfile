FROM arm64v8/node:6.11-stretch

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -yq \
    && apt-get install -yq --no-install-recommends \
        g++-4.9 \
        gcc-4.9 \
        libboost-all-dev \
        libcurl4-openssl-dev \
        libncurses5-dev \
        libprotobuf-dev \
        libssl-dev \
        m4 \
        protobuf-compiler \
        python \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://github.com/rethinkdb/rethinkdb/archive/v2.4.0.tar.gz > rethinkdb-latest.tgz \
    && tar xf rethinkdb-latest.tgz \
    && rm rethinkdb-latest.tgz

RUN cd rethinkdb-* \
    && ./configure --allow-fetch --with-system-malloc \
    && make -j4 \
    && make install

WORKDIR /data

CMD ["rethinkdb", "--bind", "all"]

VOLUME ["/data"]
EXPOSE 28015 29015 8080
