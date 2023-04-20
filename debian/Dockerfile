FROM debian:bullseye-slim

LABEL description="TeamSpeak 3 Server"

# install dependencies und clean up
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    wget tar lbzip2 tzdata gosu ca-certificates libstdc++6 libpq5 && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# setting timezone
ARG TIMEZONE=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && echo $TIMEZONE > /etc/timezone

# prepare installation
WORKDIR /var/ts3server
COPY install.sh .
RUN chmod 755 install.sh

# install teamspeak server
RUN bash install.sh UID GID
RUN rm install.sh
ENV PATH="$PATH:/opt/ts3server"

# add entrypoint
COPY entrypoint.sh /opt/ts3server
RUN chmod +x /opt/ts3server/entrypoint.sh

# finish
EXPOSE 9987/udp 10011 30033
VOLUME /var/ts3server
ENTRYPOINT ["/opt/ts3server/entrypoint.sh"]
CMD ["ts3server"]
