all: stage2.bin stage1.bin sbot.com

spiderbot.img: stage1 stage2 sbot.com
	@dd if=/dev/zero of=Spiderbot.img bs=512 count=720 2>/dev/null
	@dd if=stage1.bin of=Spiderbot.img bs=512 count=1 conv=notrunc 2>/dev/null && echo "Wrote 1st Stage Bootloader to disk image."
	@dd if=stage2.bin of=Spiderbot.img bs=512 count=4 seek=14 conv=notrunc 2>/dev/null && echo "Wrote 2nd Stage Bootloader to disk image."
	@dd if=Spiderbot.360k.img of=Spiderbot.img bs=512 skip=18 seek=18 conv=notrunc 2>/dev/null && echo "Wrote the MZ file to disk image."
	@#echo "Currently no executive to write to disk image."

sbot.com: sbot.asm
	nasm sbot.asm -Ox -fbin -osbot.com

stage2.bin: stage2.asm
	nasm stage2.asm -Ox -fbin -ostage2.bin

stage1.bin: stage1.asm
	nasm stage1.asm -Ox -fbin -ostage1.bin

