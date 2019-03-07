FROM frolvlad/alpine-glibc

ARG USER=factorio
ARG GROUP=factorio
ARG PUID=845
ARG PGID=845
ARG VERSION=0.17.6

ENV PORT=34197 \
    RCON_PORT=27015 \
    FACTORIO_FILE=/tmp/factorio-headless-x64-$VERSION.tar.xz \
    SAVES=/factorio/saves \
    CONFIG=/factorio/config \
    MODS=/factorio/mods \
    SCENARIOS=/factorio/scenarios \
    SCRIPTOUTPUT=/factorio/script-output

RUN mkdir -p /opt /factorio && \
    apk add --no-cache pwgen && \
    apk add --no-cache --virtual build-deps curl && \
    curl -sSL https://www.factorio.com/get-download/$VERSION/headless/linux64 \
	-o $FACTORIO_FILE && \
    tar -xf $FACTORIO_FILE --directory /opt && \
    chmod ugo=rwx /opt/factorio && \
    rm $FACTORIO_FILE && \
    ln -s $SAVES /opt/factorio/saves && \
    ln -s $MODS /opt/factorio/mods && \
    ln -s $SCENARIOS /opt/factorio/scenarios && \
    ln -s $SCRIPTOUTPUT /opt/factorio/script-output && \
    apk del build-deps && \
    addgroup -g $PGID -S $GROUP && \
    adduser -u $PUID -G $GROUP -s /bin/sh -SDH $USER && \
    chown -R $USER:$GROUP /opt/factorio /factorio

VOLUME /factorio

EXPOSE $PORT/udp $RCON_PORT/tcp

COPY files/ /

USER $USER

ENTRYPOINT ["/docker-entrypoint.sh"]
