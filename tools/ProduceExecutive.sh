#!/bin/bash

# This script produces a proper MZ executable from the
# 360k disk image of the Spiderbot Game.

# The data on disk is probably stored so as to
# be optimized for disk access speed or something.
# It isn't especially relevant when dealing with
# disk images and other fully linear storage.

# On disk, the data is stored in 512B sectors.
# However, we can't just address it by the sector
# number like we would on a SD card. The floppy
# controller was pretty primitive, and it just
# operated the motors on the disk and decoded/wrote
# whatever data needed to be. Either you have to use
# the bios functions to access the disk, or you
# had to write your own driver.

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

dd if=$SOURCE skip=18 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=36 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=54 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=72 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=90 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=108 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=126 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=144 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=162 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=180 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=198 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=216 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=234 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=252 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=270 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=288 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=306 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=324 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=342 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=360 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=378 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=396 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=414 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=432 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=450 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=468 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=486 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=504 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=522 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=540 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=558 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=576 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=594 bs=512 count=8 2>/dev/null
dd if=$SOURCE skip=26 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=44 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=62 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=80 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=98 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=116 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=134 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=152 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=170 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=188 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=206 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=224 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=242 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=260 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=278 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=296 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=314 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=332 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=350 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=368 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=386 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=404 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=422 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=440 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=458 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=476 bs=512 count=1 2>/dev/null
dd if=$SOURCE skip=252928 bs=1 count=128 2>/dev/null
