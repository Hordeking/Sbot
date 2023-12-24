; This code resides on at LBA 0 on the disk (the first sector)
; This is the first stage bootloader.
; It expects to be run at 0000:7c00

; TL;DR, it reads in 4 sectors from elsewhere on the disk, and jumps to that.
; These four sectors begin at (C:H:S)=(0:1:6), address 0x1c00, or sector 14

; This disk is a little bit strange. It seems to be a DOS 3.2 formatted floppy,
; and has a valid FAT. The filesystem itself has one file, sbot.com, which just
; serves to reboot the machine to allow the bootloader to take over.
; However, the boot sector structure appears to be missing a few standard fields
; which normally follow the volume label.

ORG 0x7c00

jmp begin
nop

	;BootParameterBlock for 360k DSDD 5.25" floppy
	oemName						db "MSDOS3.2"
	bytesPerSector				dw 512
	sectPerCluster				db 2
	szReservedArea				dw 1
	nFileAllocTbls				db 2
	nMaxFilesinRoot				dw 112
	nSectors					dw 720
	mediaType					db 0xfd
	szFAT						dw 2
	nSectPerTrack				dw 9
	nHeadsPerCyl				dw 2
	nSectBeforeStartPartition	dd 0
	nSectInFS					dd 0

	driveNumber					db 0
	notUsed						db 0
	extendedBootSig				db 0
	volSerNum					dd 0
	volLabel					db 0,0,0,0,0x0f,0,0,0,0,0x01,0

begin:
	sub ax, ax						; Zero out AX
	cli								; Interrupts off
	mov ss, ax						; Stack Segment set to seg 0
	mov sp, 0x7c00					; Stack grows down from 0000:7c00
	sti								; Interrupts on
	mov byte [retries_left], 0xa	; Retry 10 times before failing
	nop

load_stage2_from_disk:

	; Load Sectors from Disk

	xor ax, ax
	mov es, ax
	mov bx, 0x1000				; Destination address 0000:1000

	mov dl, 0x0					; Disk 0 (FD0)
	mov dh, 0x1					; Head 1
	mov ch, 0x0					; Cylinder 0
	mov cl, 0x6					; Sector 0x06
	mov ax, 0x204				; Int 13h fn 2, 4 sectors
	int 0x13					; Read 4 sectors from disk

	test ah, 0xdb					; Check return value
	jz success

	; Reset disk controller
	xor ax, ax
	int 0x13

	dec byte [retries_left]				; Decrement the reset tries
	jnz load_stage2_from_disk			; Retry loading
	int 0x19					; Reboot w/o memory clear

success:

	; Point ES:DI at 0x410, the Equipment Word in the bios data area.
	mov ax, 0x40
	mov es, ax
	mov di, 0x10

	;I think we're just setting the machine graphics mode to 80x25 here. Not sure why we do it this way.
	mov al, [es:di]		; Read byte at 0x410
	and al, 0xcf		; Clear bits 4,5
	or al, 0x20		; Set bits 4,5 to 0b10
	mov [es:di], al		; Store the byte back

	; Going to far jump to 0000:1000
	xor ax, ax
	push ax			; Push segment
	mov ax, 0x1000
	push ax			; Push address
	retf
	
retries_left db 0xa

times 510-($-$$) db 0		; Zero-fill whatever we don't use
bootsect_sig dw 0xAA55
