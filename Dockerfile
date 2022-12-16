FROM sethsimmons/simple-monerod:latest

USER root

RUN apk update
RUN apk add curl wget sudo bash tini yq

# Add entrypoint and healthchecks
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
ADD ./scripts/check-rpc.sh /usr/local/bin/check-rpc.sh
ADD ./scripts/check-sync.sh /usr/local/bin/check-sync.sh
RUN chmod a+x /usr/local/bin/*.sh

# WORKDIR /monero

# # Add config file for monerod
# COPY monero.conf /etc/monero/monero.conf

# # Expose p2p, restricted RPC, and Hidden Service ports
EXPOSE 18080
EXPOSE 18081
EXPOSE 18083
EXPOSE 18089

# Add HEALTHCHECK against get_info endpoint
HEALTHCHECK --interval=30s --timeout=10s CMD curl --fail http://localhost:18081/get_info || exit 1

# Start monerod
ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
