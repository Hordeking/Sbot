#!/bin/bash
SOURCE="$1"

#if [ ! -f "SOURCE" ]; then
#	echo "$SOURCE doesn't exist." >> /dev/stderr
#	exit 1;
#fi

dd if="$SOURCE" status=none bs=512 count=8 skip=261
dd if="$SOURCE" status=none bs=512 count=8 skip=279
dd if="$SOURCE" status=none bs=512 count=8 skip=297
dd if="$SOURCE" status=none bs=512 count=8 skip=315
dd if="$SOURCE" status=none bs=512 count=8 skip=333
dd if="$SOURCE" status=none bs=512 count=8 skip=351
dd if="$SOURCE" status=none bs=512 count=8 skip=369
dd if="$SOURCE" status=none bs=512 count=8 skip=387
dd if="$SOURCE" status=none bs=512 count=8 skip=405
dd if="$SOURCE" status=none bs=512 count=8 skip=423
dd if="$SOURCE" status=none bs=512 count=8 skip=441
dd if="$SOURCE" status=none bs=512 count=8 skip=459
dd if="$SOURCE" status=none bs=512 count=8 skip=477
dd if="$SOURCE" status=none bs=512 count=8 skip=495
dd if="$SOURCE" status=none bs=512 count=8 skip=513

dd if="$SOURCE" status=none bs=512 count=1 skip=269
dd if="$SOURCE" status=none bs=512 count=1 skip=287
dd if="$SOURCE" status=none bs=512 count=1 skip=305
dd if="$SOURCE" status=none bs=512 count=1 skip=323
dd if="$SOURCE" status=none bs=512 count=1 skip=341
dd if="$SOURCE" status=none bs=512 count=1 skip=359

dd if="$SOURCE" status=none bs=1 count=372 skip=$[377*512]
