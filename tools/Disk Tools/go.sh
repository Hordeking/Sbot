#!/bin/bash
SOURCE="$1"

#if [ ! -f "SOURCE" ]; then
#	echo "$SOURCE doesn't exist." >> /dev/stderr
#	exit 1;
#fi

./Extract_bootstage1.sh "$SOURCE" > stage1.bin
./Extract_bootstage2.sh "$SOURCE" > stage2.bin
./Extract_MZ.sh "$SOURCE" > spiderbot.exe
./Extract_File0.sh "$SOURCE" > File0.bin
./Extract_File1.sh "$SOURCE" > File1.bin
./Extract_File2.sh "$SOURCE" > File2.bin
./Extract_File3.sh "$SOURCE" > File3.bin
./Extract_File4.sh "$SOURCE" > File4.bin
