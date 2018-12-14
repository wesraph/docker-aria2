#!/bin/sh
set -e

# $1 is gid.
# $2 is the number of files.
# $3 is the path of the first file.

DOING_DIR=/downloads/doing
DONE_DIR=/downloads/done

[ "$2" = "0" ] && exit 0

file_path=$3
while true; do
	dir=$(dirname "$file_path")
	[ "$dir" = "$DOING_DIR" ] && break
	file_path=$dir
done

echo "Moving $file_path in $DONE_DIR"
mv "$file_path" "$DONE_DIR/"
