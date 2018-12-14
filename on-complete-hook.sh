#!/bin/sh

set -e

NUMBER_OF_FILES=$2
FILES_PATH=$3

if ! [ "$NUMBER_OF_FILES" = "1" ]; then
	echo "More than one file ! : $NUMBER_OF_FILES"
	exit 1
fi

echo "Moving $FILES_PATH in /downloads/done/"
mv "$FILES_PATH" /downloads/done/

exit 0
