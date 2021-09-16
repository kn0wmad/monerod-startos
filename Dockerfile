# Based on https://github.com/monero-project/monero/blob/master/Dockerfile
# Multistage docker build

# Build stage
FROM arm64v8/alpine:3.12 as builder

RUN sed -i 's/http\:\/\/dl-cdn.alpinelinux.org/https\:\/\/alpine.global.ssl.fastly.net/g' /etc/apk/repositories
RUN apk --no-cache add tini
RUN apk --no-cache add autoconf
RUN apk --no-cache add automake
RUN apk --no-cache add bzip2
RUN apk --no-cache add ca-certificates
RUN apk --no-cache add cmake
RUN apk --no-cache add curl
RUN apk --no-cache add doxygen
RUN apk --no-cache add g++
RUN apk --no-cache add gperf
RUN apk --no-cache add graphviz
RUN apk --no-cache add libtool-bin
RUN apk --no-cache add make
RUN apk --no-cache add pkg-config
RUN apk --no-cache add unzip
RUN apk --no-cache add xsltproc

ADD ./monero/target/aarch64-unknown-linux-musl/release/monero /usr/local/bin/monero
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh

WORKDIR /root

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
