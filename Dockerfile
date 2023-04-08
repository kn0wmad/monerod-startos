FROM sethsimmons/simple-monerod:v0.18.2.0

USER root

RUN apk update
RUN apk add curl wget sudo bash tini yq

# Add entrypoint and healthchecks
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
ADD ./scripts/check-rpc.sh /usr/local/bin/check-rpc.sh
ADD ./scripts/check-sync.sh /usr/local/bin/check-sync.sh
RUN chmod a+x /usr/local/bin/*.sh

# # Add config file for monerod
COPY ./assets/monero.conf.template /root/

# # Expose p2p, restricted RPC, and Hidden Service ports
EXPOSE 18080
EXPOSE 18081

USER monero

# Start monerod
ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
