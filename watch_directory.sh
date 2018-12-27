#!/bin/sh
[ "$ARIA2_RPC_SECRET" ] || {
	echo "Missing aria2 rcp secret"
	exit 1
}

RPC_URL="http://127.0.0.1:6800/jsonrpc"
WATCH_DIRECTORY="/watch"

while :
do
    for torrent in "$WATCH_DIRECTORY"/*.torrent; do
        [ -e "$torrent" ] || break

        echo "Adding $torrent"

        echo -n "{\"jsonrpc\": \"2.0\", \"id\":\"$(cat /dev/urandom | head -c 15 | base32)\", \"method\": \"aria2.addTorrent\", \"params\": [\"token:$ARIA2_RPC_SECRET\", \"" > /tmp/jsondata
        base64 "$torrent" >> /tmp/jsondata
        echo -n "\", [], {}] }" >> /tmp/jsondata

        curl --data-binary @/tmp/jsondata  -H 'content-type: text/plain;' $RPC_URL
        rm "$torrent"
    done

    for magnet in "$WATCH_DIRECTORY"/*.magnet; do
        [ -e "$magnet" ] || break

        echo "Adding $magnet"

        echo -n "{\"jsonrpc\": \"2.0\", \"id\":\"$(cat /dev/urandom | head -c 15 | base32)\", \"method\": \"aria2.addUri\", \"params\": [\"token:$ARIA2_RPC_SECRET\", [\"" > /tmp/jsondata
        cat "$magnet" >> /tmp/jsondata
        echo -n "\"], {}] }" >> /tmp/jsondata

        curl --data-binary @/tmp/jsondata  -H 'content-type: text/plain;' $RPC_URL
        rm "$magnet" 
    done
    sleep 10
done
