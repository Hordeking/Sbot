#!/bin/bash
SOURCE="$1"
TARGET="$2"
echo "Converting Source: $SOURCE to Target: $TARGET"
echo "WARNING: This conversion works for the absolute CHS addressing used to access the data, but will break the FAT12."

# Fill a blank image with 0xf6
awk 'BEGIN { while(1) printf "%c", "\xf6" }' | dd of="$TARGET" bs=512 count=2880 2>/dev/null 1>/dev/null

# Copy the first 9 sectors of each side, cylinder by cylinder.
for track in {0..39}; do
	# Copy Head 0, then Head 1
	dd if="$SOURCE" of="$TARGET" bs=512 count=9 conv=notrunc skip=$(( (2*$track+0)*9 )) seek=$(( 2*(2*$track+0)*9 )) 2>/dev/null 1>/dev/null
	dd if="$SOURCE" of="$TARGET" bs=512 count=9 conv=notrunc skip=$(( (2*$track+1)*9 )) seek=$(( 2*(2*$track+1)*9 )) 2>/dev/null 1>/dev/null
done;
