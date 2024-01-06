#!/bin/bash
SOURCE="$1"

dd if="$SOURCE" status=none bs=512 count=8 skip=630
dd if="$SOURCE" status=none bs=512 count=8 skip=648
dd if="$SOURCE" status=none bs=512 count=8 skip=666
dd if="$SOURCE" status=none bs=512 count=8 skip=684
