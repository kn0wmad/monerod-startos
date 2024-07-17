FROM ghcr.io/sethforprivacy/simple-monero-wallet-rpc:v0.18.3.3 as monero-wallet-rpc
FROM ghcr.io/sethforprivacy/simple-monerod:v0.18.3.3
COPY --from=monero-wallet-rpc "/usr/local/bin/monero-wallet-rpc" /usr/local/bin/
#FROM alpine:3.20.1 as monero-builder

USER root
RUN apk update
RUN apk --no-cache upgrade
#--update --no-cache upgrade
#RUN apk add --no-cache build-base cmake boost-dev openssl-dev zeromq-dev unbound-dev libsodium-dev libunwind-dev xz-dev readline-dev expat-dev gtest-dev ccache doxygen hidapi-dev protobuf-dev protobuf-dev openpgm-dev eudev-dev git ca-certificates bash gpg gpg-agent linux-headers zeromq-dev pcsc-lite-dev pkgconf libusb-dev libtool g++ make dev86
#RUN apk add --no-cache --update --repository=https://dl-cdn.alpinelinux.org/alpine/v3.16/main/ libexecinfo-dev

#RUN mkdir -p /build/pgp
#WORKDIR /build/pgp
#RUN wget https://raw.githubusercontent.com/monero-project/monero/master/utils/gpg_keys/binaryfate.asc ; \
#    wget https://raw.githubusercontent.com/monero-project/monero/master/utils/gpg_keys/erciccione.asc ; \
#    wget https://raw.githubusercontent.com/monero-project/monero/master/utils/gpg_keys/fluffypony.asc ; \
#    wget https://raw.githubusercontent.com/monero-project/monero/master/utils/gpg_keys/hyc.asc ; \
#    wget https://raw.githubusercontent.com/monero-project/monero/master/utils/gpg_keys/luigi1111.asc ; \
#    wget https://raw.githubusercontent.com/monero-project/monero/master/utils/gpg_keys/moneromooo.asc ; \
#    wget https://raw.githubusercontent.com/monero-project/monero/master/utils/gpg_keys/selsta.asc ; \
#    gpg --import *.asc

#WORKDIR /build
#RUN git clone --recursive https://github.com/monero-project/monero
#WORKDIR /build/monero
#RUN git submodule init && git submodule sync && git submodule update --init --recursive
#RUN git verify-tag v0.18.3.2 && git checkout v0.18.3.2
#RUN git submodule sync
#RUN git submodule update --init --recursive
#RUN git submodule update --init --force
##RUN echo "RTE_BACKTRACE_STACK=n" > CONFIG
##RUN make release
##RUN echo "CONFIG_HAVE_EXECINFO_H=n" >> CONFIG
#RUN make release
#FROM alpine:3.20.1

#COPY --from=monero-builder "/build/monero/release/bin" /usr/local/bin/

RUN apk update
RUN apk add curl wget sudo bash tini yq
RUN apk upgrade

# Add entrypoint and healthchecks
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
ADD ./scripts/creds-rpc.sh /usr/local/bin/creds-rpc.sh
ADD ./scripts/check-rpc.sh /usr/local/bin/check-rpc.sh
ADD ./scripts/check-sync.sh /usr/local/bin/check-sync.sh
RUN chmod a+x /usr/local/bin/*.sh

#Add monero user & group:
#RUN addgroup --gid 30234 monero
#RUN adduser -h /dev/null -s /sbin/nologin -D -H -u 30234 -G monero monero
RUN sed -i "s|^monero:x:1000:1000:Linux User,,,:/home/monero:/bin/bash|monero:x:30234:302340:Monero:/dev/null:/sbin/nologin|" /etc/passwd
RUN sed -i "s/^\(monero:x\):1000:$/\1:302340:/" /etc/group
RUN sed -i "s|^\(monerowallet:x:30233:302340:\)Linux User,,,\(:/dev/null:/sbin/nologin\)|\1Monero Wallet RPC User\2|" /etc/passwd
RUN adduser -h /dev/null -s /sbin/nologin -D -H -u 30233 -G monero monerowallet

# # Add config file for monerod
COPY ./assets/*.conf.template /root/
#Copy the backup ignore file that tells the backup functions to not backup the blockchain:
COPY ./assets/.backupignore /data/.bitmonero/

# # Expose p2p, unrestricted RPC, ZMQ, ZMQ-PUB, and restricted RPC ports
EXPOSE 18080/tcp
EXPOSE 18081/tcp
EXPOSE 18082/tcp
EXPOSE 18083/tcp
EXPOSE 18089/tcp
EXPOSE 28088/tcp

WORKDIR "/data/.bitmonero"

# Start monerod
ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
