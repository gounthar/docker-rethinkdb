# build: docker build -t generalmeow/rethinkdb:<TAG>
# run: docker run -d -p 28015:28015 -p <>:8080 --name rethinkdb -v <>:/var/lib/rethinkdb/default -v <>:/var/log/rethinkdb generalmeow/rethinkdb:<TAG>
FROM alpine:latest
MAINTAINER Paul Hoang 2017-01-18
EXPOSE 28015
EXPOSE 8080
RUN mkdir -p /home/rethinkdb/files && mkdir -p /home/rethinkdb/data && mkdir -p /home/rethinkdb/logs && touch /home/rethinkdb/logs/log && \
    apk update && apk add bash protobuf protoc libprotobuf
RUN wget http://dl-cdn.alpinelinux.org/alpine/v3.11/community/aarch64/rethinkdb-2.3.6-r15.apk && apk add --allow-untrusted rethinkdb-2.3.6-r15.apk
COPY ["./files/etc/rethinkdb/instances.d/instance.conf", "/etc/rethinkdb/instances.d/instance.conf"]
VOLUME /var/lib/rethinkdb/default
VOLUME /var/log/rethinkdb
VOLUME /home/rethinkdb/data
ENTRYPOINT ["rethinkdb", "--config-file", "/etc/rethinkdb/instances.d/instance.conf"]
