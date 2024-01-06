#!/bin/bash
SOURCE="$1"

dd if="$SOURCE" status=none bs=512 count=9 skip=612 
dd if="$SOURCE" status=none bs=1 count=56 skip=$[638*512]

