FROM ghcr.io/sethforprivacy/simple-monero-wallet-rpc:v0.18.3.3 as monero-wallet-rpc
FROM ghcr.io/sethforprivacy/simple-monerod:v0.18.3.2
COPY --from=monero-wallet-rpc "/usr/local/bin/monero-wallet-rpc" /usr/local/bin/

USER root

RUN apk update
RUN apk upgrade
RUN apk add curl wget sudo bash tini yq

# Add entrypoint and healthchecks
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
ADD ./scripts/creds-rpc.sh /usr/local/bin/creds-rpc.sh
ADD ./scripts/check-rpc.sh /usr/local/bin/check-rpc.sh
ADD ./scripts/check-sync.sh /usr/local/bin/check-sync.sh
RUN chmod a+x /usr/local/bin/*.sh

#Change default monero UID and GID, disable user's home and shell
RUN sed -i "s|^monero:x:1000:1000:Linux User,,,:/home/monero:/bin/bash|monero:x:302340:302340:Monero:/dev/null:/sbin/nologin|" /etc/passwd
RUN sed -i "s/^\(monero:x\):1000:$/\1:302340:/" /etc/group
RUN adduser -h /dev/null -s /sbin/nologin -D -H -u 30233 -G monero monerowallet
RUN sed -i "s|^\(monerowallet:x:30233:302340:\)Linux User,,,\(:/dev/null:/sbin/nologin\)|\1Monero Wallet RPC User\2|" /etc/passwd

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
