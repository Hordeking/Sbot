#!/bin/bash

# Zero out the B side of a 360k floppy image.
# Actually, this zeroes out the entire B side, plus the suspected
#   unused sectors of the 360k Spiderbot disk image.
#   This is based specifically on what the stage 2 bootloader
#   actually loads from disk (an apparently valid MZ executable).

# THIS IS ONLY FOR THE 360k DISK IMAGE VERSION.
# IT WILL DAMAGE OTHER DISK LAYOUTS.
# YOU HAVE BEEN WARNED.

IMAGE="$1"

# Zero out B side
dd if=/dev/zero bs=512 count=9 seek=27 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=45 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=63 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=81 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=99 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=117 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=135 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=153 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=171 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=189 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=207 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=225 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=243 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=261 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=279 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=297 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=315 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=333 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=351 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=369 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=387 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=405 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=423 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=441 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=459 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=477 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=495 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=513 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=531 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=549 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=567 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=585 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=603 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=621 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=639 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=657 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=675 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=693 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=9 seek=711 of=$IMAGE conv=notrunc 2>/dev/null

# Zero out the 384 bytes in that quarter sector
dd if=/dev/zero bs=1 count=384 seek=253056 of=$IMAGE conv=notrunc 2>/dev/null

# Zero out everything after track 0x33
dd if=/dev/zero bs=512 count=18 seek=612 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=18 seek=630 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=18 seek=648 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=18 seek=666 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=18 seek=684 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=18 seek=702 of=$IMAGE conv=notrunc 2>/dev/null

# And don't forget the sector 9's from track 27 to 33, those aren't used
dd if=/dev/zero bs=512 count=1 seek=512 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=1 seek=530 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=1 seek=548 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=1 seek=566 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=1 seek=584 of=$IMAGE conv=notrunc 2>/dev/null
dd if=/dev/zero bs=512 count=1 seek=602 of=$IMAGE conv=notrunc 2>/dev/null
