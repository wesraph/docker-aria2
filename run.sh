#!/bin/sh
set -e

[ "$ARIA2_RPC_SECRET" ] || {
	echo "Missing aria2 rcp secret"
	exit 1
}

[ "$ARIA2_UID" ] && usermod -u "$ARIA2_UID" aria2
[ "$ARIA2_GID" ] && groupmod -g "$ARIA2_GID" aria2

ARIA2_CONFIG_DIR="/home/aria2"

mkdir -p /downloads/doing /downloads/done
mkdir -p /home/aria2/web

# Update the secret in the index
encoded_secret=$(echo "$ARIA2_RPC_SECRET" | base64)
sed "s/secret:\"\"/secret:\"$encoded_secret\"/g" \
	/home/aria2/index.html > /home/aria2/web/index.html

# Mount permissions
chown -R aria2:aria2 "$ARIA2_CONFIG_DIR"
chown -R aria2:aria2 /downloads

# Run aria2 as the aria2 user
su -c "aria2c --conf-path=$ARIA2_CONFIG_DIR/aria2.conf --rpc-secret=$ARIA2_RPC_SECRET -D" - aria2
exec su -c "/usr/local/bin/caddy -conf /home/aria2/Caddyfile" - aria2
