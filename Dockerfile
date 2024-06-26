FROM ghcr.io/sethforprivacy/simple-monerod:v0.18.3.2

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
RUN sed -i "s|monero:x:1000:1000:Linux User,,,:/home/monero:/bin/bash|monero:x:302340:302340:Monero:/dev/null:/sbin/nologin|" /etc/passwd
RUN sed -i "s/^\(monero:x\):1000:$/\1:302340:/" /etc/group

# # Add config file for monerod
COPY ./assets/monero.conf.template /root/

# # Expose p2p, unrestricted RPC, ZMQ, and restricted RPC ports
#EXPOSE 18080
EXPOSE 18081
#EXPOSE 18082
EXPOSE 18089

# Start monerod
ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
