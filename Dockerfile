# build: docker build -t generalmeow/rethinkdb:<TAG>
# run: docker run -d -p 28015:28015 -p <>:8080 --name rethinkdb -v <>:/var/lib/rethinkdb/default -v <>:/var/log/rethinkdb generalmeow/rethinkdb:<TAG>
FROM debian:buster-slim
MAINTAINER Paul Hoang 2017-01-18
EXPOSE 28015
EXPOSE 8080
RUN mkdir -p /home/rethinkdb/files && mkdir -p /home/rethinkdb/data && mkdir -p /home/rethinkdb/logs && touch /home/rethinkdb/logs/log && \
    apt update && apt dist-upgrade -y && apt install -y bash build-essential python2 perl libprotobuf-dev libprotoc-dev 
RUN wget https://github.com/srh/rethinkdb/archive/v2.4.0-srh-win-1.tar.gz && tar -xzf v2.4.0-srh-win-1.tar.gz && cd rethinkdb-2.4.0-srh-win-1 && \
    ./configure --allow-fetch --fetch coffee --fetch npm --fetch protobuf && grep MACHINE config.mk && sed -i 's/.*aarch64-alpine-linux-musl.*/MACHINE := aarch64/' config.mk && \
  sed -i 's/.*2.5.0.*/version=2.6.0/' ./mk/support/pkg/protobuf.sh && \
  sed -i 's|\(^.*src_url_sha1=.*\)62c10dcdac4b69cc8c6bb19f73db40c264cb2726\(.*$\)|\16d9dc4c5899232e2397251f9323cbdf176391d1b\2|i' ./mk/support/pkg/protobuf.sh && \
  find . -name protobuf.sh && cat ./mk/support/pkg/protobuf.sh && sed -i 's|\(^.*proto.*\)2.5.0\(.*$\)|\12.6.0\2|i' config.mk && \
  cat config.mk | grep -i proto && make -j$(nproc)
COPY ["./files/install.sh", "/home/rethinkdb/files/install.sh"]
RUN ["/home/rethinkdb/files/install.sh"]
COPY ["./files/etc/rethinkdb/instances.d/instance.conf", "/etc/rethinkdb/instances.d/instance.conf"]
VOLUME /var/lib/rethinkdb/default
VOLUME /var/log/rethinkdb
VOLUME /home/rethinkdb/data
ENTRYPOINT ["rethinkdb", "--config-file", "/etc/rethinkdb/instances.d/instance.conf"]
