#!/bin/bash
SOURCE="$1"

#if [ ! -f "SOURCE" ]; then
#	echo "$SOURCE doesn't exist." >> /dev/stderr
#	exit 1;
#fi

dd if="$SOURCE" status=none bs=512 count=8 skip=531
dd if="$SOURCE" status=none bs=512 count=8 skip=549
dd if="$SOURCE" status=none bs=512 count=8 skip=567
dd if="$SOURCE" status=none bs=512 count=8 skip=585
dd if="$SOURCE" status=none bs=512 count=8 skip=603
dd if="$SOURCE" status=none bs=512 count=8 skip=621
dd if="$SOURCE" status=none bs=512 count=8 skip=639
dd if="$SOURCE" status=none bs=512 count=8 skip=657
dd if="$SOURCE" status=none bs=512 count=8 skip=675

dd if="$SOURCE" status=none bs=512 count=1 skip=539
dd if="$SOURCE" status=none bs=512 count=1 skip=557
dd if="$SOURCE" status=none bs=512 count=1 skip=575
dd if="$SOURCE" status=none bs=512 count=1 skip=593
dd if="$SOURCE" status=none bs=512 count=1 skip=611
dd if="$SOURCE" status=none bs=512 count=1 skip=629
dd if="$SOURCE" status=none bs=512 count=1 skip=647


dd if="$SOURCE" status=none bs=1 count=93 skip=$[665*512]
