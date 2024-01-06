#!/bin/bash
SOURCE="$1"

#if [ ! -f "SOURCE" ]; then
#	echo "$SOURCE doesn't exist." >> /dev/stderr
#	exit 1;
#fi

dd if="$SOURCE" status=none bs=512 count=1 skip=0
