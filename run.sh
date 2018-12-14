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

# Update the secret in the index
encoded_secret=$(echo "$ARIA2_RPC_SECRET" | base64)
sed -i "s/secret:\"\"/secret:\"$encoded_secret\"/g" /home/aria2/web/index.html

# Add secret to aria
if ! grep "rpc-secret" /home/aria2/aria2.conf; then
	echo "rpc-secret=$ARIA2_RPC_SECRET" >> /home/aria2/aria2.conf
fi

# Mount permissions
chown -R aria2:aria2 "$ARIA2_CONFIG_DIR"
chown -R aria2:aria2 /downloads

# Run aria2 as the aria2 user
su -c "/usr/bin/aria2c --conf-path $ARIA2_CONFIG_DIR/aria2.conf -D" - aria2
exec su -c "/usr/local/bin/caddy -conf /home/aria2/Caddyfile" - aria2
