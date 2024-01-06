#!/bin/bash
SOURCE="$1"

#if [ ! -f "SOURCE" ]; then
#	echo "$SOURCE doesn't exist." >> /dev/stderr
#	exit 1;
#fi

dd if="$SOURCE" status=none bs=512 count=8 skip=18
dd if="$SOURCE" status=none bs=512 count=8 skip=36
dd if="$SOURCE" status=none bs=512 count=8 skip=54
dd if="$SOURCE" status=none bs=512 count=8 skip=72
dd if="$SOURCE" status=none bs=512 count=8 skip=90
dd if="$SOURCE" status=none bs=512 count=8 skip=108
dd if="$SOURCE" status=none bs=512 count=8 skip=126
dd if="$SOURCE" status=none bs=512 count=8 skip=144
dd if="$SOURCE" status=none bs=512 count=8 skip=162
dd if="$SOURCE" status=none bs=512 count=8 skip=180
dd if="$SOURCE" status=none bs=512 count=8 skip=198
dd if="$SOURCE" status=none bs=512 count=8 skip=216
dd if="$SOURCE" status=none bs=512 count=8 skip=234
dd if="$SOURCE" status=none bs=512 count=8 skip=252
dd if="$SOURCE" status=none bs=512 count=8 skip=270
dd if="$SOURCE" status=none bs=512 count=8 skip=288
dd if="$SOURCE" status=none bs=512 count=8 skip=306
dd if="$SOURCE" status=none bs=512 count=8 skip=324
dd if="$SOURCE" status=none bs=512 count=8 skip=342
dd if="$SOURCE" status=none bs=512 count=8 skip=360
dd if="$SOURCE" status=none bs=512 count=8 skip=378
dd if="$SOURCE" status=none bs=512 count=8 skip=396
dd if="$SOURCE" status=none bs=512 count=8 skip=414
dd if="$SOURCE" status=none bs=512 count=8 skip=432
dd if="$SOURCE" status=none bs=512 count=8 skip=450
dd if="$SOURCE" status=none bs=512 count=8 skip=468
dd if="$SOURCE" status=none bs=512 count=8 skip=486
dd if="$SOURCE" status=none bs=512 count=8 skip=504
dd if="$SOURCE" status=none bs=512 count=8 skip=522
dd if="$SOURCE" status=none bs=512 count=8 skip=540
dd if="$SOURCE" status=none bs=512 count=8 skip=558
dd if="$SOURCE" status=none bs=512 count=8 skip=576
dd if="$SOURCE" status=none bs=512 count=8 skip=594

dd if="$SOURCE" status=none bs=512 count=1 skip=26
dd if="$SOURCE" status=none bs=512 count=1 skip=44
dd if="$SOURCE" status=none bs=512 count=1 skip=62
dd if="$SOURCE" status=none bs=512 count=1 skip=80
dd if="$SOURCE" status=none bs=512 count=1 skip=98
dd if="$SOURCE" status=none bs=512 count=1 skip=116
dd if="$SOURCE" status=none bs=512 count=1 skip=134
dd if="$SOURCE" status=none bs=512 count=1 skip=152
dd if="$SOURCE" status=none bs=512 count=1 skip=170
dd if="$SOURCE" status=none bs=512 count=1 skip=188
dd if="$SOURCE" status=none bs=512 count=1 skip=206
dd if="$SOURCE" status=none bs=512 count=1 skip=224
dd if="$SOURCE" status=none bs=512 count=1 skip=242
dd if="$SOURCE" status=none bs=512 count=1 skip=260
dd if="$SOURCE" status=none bs=512 count=1 skip=278
dd if="$SOURCE" status=none bs=512 count=1 skip=296
dd if="$SOURCE" status=none bs=512 count=1 skip=314
dd if="$SOURCE" status=none bs=512 count=1 skip=332
dd if="$SOURCE" status=none bs=512 count=1 skip=350
dd if="$SOURCE" status=none bs=512 count=1 skip=368
dd if="$SOURCE" status=none bs=512 count=1 skip=386
dd if="$SOURCE" status=none bs=512 count=1 skip=404
dd if="$SOURCE" status=none bs=512 count=1 skip=422
dd if="$SOURCE" status=none bs=512 count=1 skip=440
dd if="$SOURCE" status=none bs=512 count=1 skip=458
dd if="$SOURCE" status=none bs=512 count=1 skip=476

dd if="$SOURCE" status=none bs=1 count=128 skip=$[494*512]
