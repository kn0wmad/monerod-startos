FROM sethsimmons/simple-monerod:latest

USER root

RUN apk update
RUN apk add curl wget sudo bash tini yq

# Add entrypoint and healthchecks
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
ADD ./scripts/check-rpc.sh /usr/local/bin/check-rpc.sh
ADD ./scripts/check-sync.sh /usr/local/bin/check-sync.sh
RUN chmod a+x /usr/local/bin/*.sh

# # Add config file for monerod
RUN mkdir -p /data/.bitmonero
WORKDIR /data/.bitmonero
#Create the monero user if it doesn't exist:
#RUN if [[ $(users|grep ^monero$|wc -l) -eq 0 ] ; then usersadduser --home /data/.bitmonero --shell /sbin/nologin monero ; fi
COPY ./assets/monero.conf.template /data/.bitmonero/monero.conf.template
RUN chown -R monero:monero /data
RUN chmod 700 /data /data/.bitmonero

# # Expose p2p, restricted RPC, and Hidden Service ports
EXPOSE 18080
EXPOSE 18081
EXPOSE 18083
#EXPOSE 18089

# Add HEALTHCHECK against get_info endpoint
#HEALTHCHECK --interval=30s --timeout=10s CMD curl --fail http://localhost:18081/get_info || exit 1

# Start monerod
ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
