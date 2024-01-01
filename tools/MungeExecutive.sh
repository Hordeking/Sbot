#!/bin/bash

# HIS MUNGES THE MZ FOR 360k DISKS ONLY!
# DO NOT USE THIS FOR ANY OTHER SIZE DISK IMAGE.
# YOU HAVE BEEN WARNED.

# This script produces the munged MZ executable
# from the 360k disk image of the Spiderbot Game.

# This is not the final product. You have to
# concatenate it right after the second stage
# boot loader.

# On disk, the data is stored in 512B sectors.
# However, we can't just address it by the sector
# number like we would on a SD card. The floppy
# controller was pretty primitive, and it just
# operated the motors on the disk and decoded/wrote
# whatever data needed to be. Either you have to use
# the bios functions to access the disk, or you
# had to write your own driver.

# Once you have the basic disk image with the boot
# sector (LBA 0) and 2nd stage boot loader (LBA 14),
# you need to write this to LBA 18. Each block is
# 512 bytes long.

# On linux, this can be done with:
# dd if="$MUNGED" of="$IMAGE" bs=512 skip=18 conv=notrunc
# where MUNGED is the output from this script.
# and IMAGE is the actual 360k disk image.

# What follows is how the executable is stored on disk.

# The bios was stock function is pretty basic,
# and uses what amounts to cylindrical coords
# to determine how to operate the motors.
# Cylinder# is a bit like radius, track# is
# analagous to theta, while head# acts like z.
# Naturally, all of these are digital, and a disk
# only has 2 heads (0,1). In theory, it can have
# as many cylinders as the disk can fit, but 360k
# floppies had 40 cylinders. Each side of each cyl
# has 9 sectors, numbered 1-9 (modern expectation is
# 0-8). Spiderbot stores things a little non-consec.

# The process is:
# For each cylinder 1-33, read the first 8 sectors.
#    Concatenate each of these 8 sectors as we read
#    up through the cylinders.
# Once we finish with cyl 33, start back at cyl 1,
#    but this time just grab the 9th sector of each.
#    Concatenate just like we did before, but cyl
#    1-26.
# The final bit of data comes from cylinder 27, we
#    just need to grab the first 128 bytes of this
#    sector.

# When all is said and done, you should have produced
#    MZ executable for spiderbot.

# Note: The bootloader does tweak this image when it
#    loads it into memory. This is probably just
#    normal stuff one would do to load an exec.

SOURCE=$1

dd if=$SOURCE skip=0 bs=512 count=8 2>/dev/null   # First 8 sectors of side 0
dd if=$SOURCE skip=264 bs=512 count=1 2>/dev/null # 9th sector of side 0
dd if=/dev/zero        bs=512 count=9 2>/dev/null # All nine sectors of side 1

dd if=$SOURCE skip=8 bs=512 count=8 2>/dev/null   # 1
dd if=$SOURCE skip=265 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=16 bs=512 count=8 2>/dev/null  # 2
dd if=$SOURCE skip=266 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=24 bs=512 count=8 2>/dev/null  # 3
dd if=$SOURCE skip=267 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=32 bs=512 count=8 2>/dev/null  # 4
dd if=$SOURCE skip=268 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=40 bs=512 count=8 2>/dev/null  # 5
dd if=$SOURCE skip=269 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=48 bs=512 count=8 2>/dev/null  # 6
dd if=$SOURCE skip=270 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=56 bs=512 count=8 2>/dev/null  # 7
dd if=$SOURCE skip=271 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=64 bs=512 count=8 2>/dev/null  # 8
dd if=$SOURCE skip=272 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=72 bs=512 count=8 2>/dev/null  # 9
dd if=$SOURCE skip=273 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=80 bs=512 count=8 2>/dev/null  # 10
dd if=$SOURCE skip=274 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=88 bs=512 count=8 2>/dev/null  # 11
dd if=$SOURCE skip=275 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=96 bs=512 count=8 2>/dev/null  # 12
dd if=$SOURCE skip=276 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=104 bs=512 count=8 2>/dev/null  # 13
dd if=$SOURCE skip=277 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=112 bs=512 count=8 2>/dev/null  # 14
dd if=$SOURCE skip=278 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=120 bs=512 count=8 2>/dev/null  # 15
dd if=$SOURCE skip=279 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=128 bs=512 count=8 2>/dev/null  # 16
dd if=$SOURCE skip=280 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=136 bs=512 count=8 2>/dev/null  # 17
dd if=$SOURCE skip=281 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=144 bs=512 count=8 2>/dev/null  # 18
dd if=$SOURCE skip=282 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=152 bs=512 count=8 2>/dev/null  # 19
dd if=$SOURCE skip=283 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=160 bs=512 count=8 2>/dev/null  # 20
dd if=$SOURCE skip=284 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=168 bs=512 count=8 2>/dev/null  # 21
dd if=$SOURCE skip=285 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=176 bs=512 count=8 2>/dev/null  # 22
dd if=$SOURCE skip=286 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=184 bs=512 count=8 2>/dev/null  # 23
dd if=$SOURCE skip=287 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=192 bs=512 count=8 2>/dev/null  # 24
dd if=$SOURCE skip=288 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=200 bs=512 count=8 2>/dev/null  # 25	Last one with 9 sectors.
dd if=$SOURCE skip=289 bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=208 bs=512 count=8 2>/dev/null  # 26	This one has a 128 B then garbage
dd if=$SOURCE skip=148480 bs=1 count=128 2>/dev/null
dd if=/dev/zero        bs=1 count=384 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=216 bs=512 count=8 2>/dev/null  # 27
dd if=/dev/zero        bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=224 bs=512 count=8 2>/dev/null  # 28
dd if=/dev/zero        bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=232 bs=512 count=8 2>/dev/null  # 29
dd if=/dev/zero        bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=240 bs=512 count=8 2>/dev/null  # 30
dd if=/dev/zero        bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=248 bs=512 count=8 2>/dev/null  # 31
dd if=/dev/zero        bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

dd if=$SOURCE skip=256 bs=512 count=8 2>/dev/null  # 32
dd if=/dev/zero        bs=512 count=1 2>/dev/null
dd if=/dev/zero        bs=512 count=9 2>/dev/null

echo "Don't forget to \"dd\" this into your 360k floppy using seek=18 bs=512 conv=notrunc!" 
