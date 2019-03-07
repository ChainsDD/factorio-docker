#!/bin/sh -x
set -e

id

mkdir -p $SAVES $CONFIG $MODS $SCENARIOS $SCRIPTOUTPUT

if [ ! -f $CONFIG/rconpw ]; then
    echo $(pwgen 15 1) > $CONFIG/rconpw
fi

if [ ! -f $CONFIG/server-settings.json ]; then
    cp /opt/factorio/data/server-settings.example.json $CONFIG/server-settings.json
fi

if [ ! -f $CONFIG/map-gen-settings.json ]; then
    cp /opt/factorio/data/map-gen-settings.example.json $CONFIG/map-gen-settings.json
fi

if [ ! -f $CONFIG/map-settings.json ]; then
    cp /opt/factorio/data/map-settings.example.json $CONFIG/map-settings.json
fi

if find -L $SAVES -iname \*.tmp.zip -mindepth 1 -print | grep -q .; then
    rm -f $SAVES/*.tmp.zip
fi

if ! find -L $SAVES -iname \*.zip -mindepth 1 -print | grep -q .; then
    /opt/factorio/bin/x64/factorio \
        --create $SAVES/_autosave1.zip \
        --map-gen-settings $CONFIG/map-gen-settings.json \
        --map-settings $CONFIG/map-settings.json
fi

exec /opt/factorio/bin/x64/factorio \
    --port $PORT \
    --start-server-load-latest \
    --server-settings $CONFIG/server-settings.json \
    --use-server-whitelist \
    --server-whitelist $CONFIG/server-whitelist.json \
    --server-banlist $CONFIG/server-banlist,json \
    --server-adminlist $CONFIG/server-adminlist.json \
    --rcon-port $RCON_PORT \
    --rcon-password "$(cat $CONFIG/rconpw)" \
    --server-id /factorio/config/server-id.json \
    $@
