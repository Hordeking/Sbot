#!/bin/bash
SOURCE="$1"

#if [ ! -f "SOURCE" ]; then
#	echo "$SOURCE doesn't exist." >> /dev/stderr
#	exit 1;
#fi

dd if="$SOURCE" status=none bs=512 count=8 skip=27
dd if="$SOURCE" status=none bs=512 count=8 skip=45
dd if="$SOURCE" status=none bs=512 count=8 skip=63
dd if="$SOURCE" status=none bs=512 count=8 skip=81
dd if="$SOURCE" status=none bs=512 count=8 skip=99
dd if="$SOURCE" status=none bs=512 count=8 skip=117
dd if="$SOURCE" status=none bs=512 count=8 skip=135
dd if="$SOURCE" status=none bs=512 count=8 skip=153
dd if="$SOURCE" status=none bs=512 count=8 skip=171
dd if="$SOURCE" status=none bs=512 count=8 skip=189
dd if="$SOURCE" status=none bs=512 count=8 skip=207
dd if="$SOURCE" status=none bs=512 count=8 skip=225
dd if="$SOURCE" status=none bs=512 count=8 skip=243

dd if="$SOURCE" status=none bs=512 count=1 skip=35
dd if="$SOURCE" status=none bs=512 count=1 skip=53
dd if="$SOURCE" status=none bs=512 count=1 skip=71
dd if="$SOURCE" status=none bs=512 count=1 skip=89
dd if="$SOURCE" status=none bs=512 count=1 skip=107
dd if="$SOURCE" status=none bs=512 count=1 skip=125
dd if="$SOURCE" status=none bs=512 count=1 skip=143

dd if="$SOURCE" status=none bs=1 count=98 skip=$[161*512]
