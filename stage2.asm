; This code expects to be run from 0000:1000

; This is the second stage bootloader for Spiderbot. It is comprised of
; four sectors beginning at sector 14 (addr 0x1c00) of the floppy. So to recap,
; Sectors 14, 15, 16, & 17 make up this bootloader.

; It sets up a stack at 0x1121 (should be baseaddr+0x121 for portability), and
; has a few other important bits in the first 0x163 bytes or so. Most importantly
; are the little pieces at 0x1132, which seem to relate to where the real game
; is stored.

org 0x1000

jmp begin

;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;Everything above is stack

;pStack: 0x00, 0x00, 0x01,

;global_retry_count: 0x00,

;0x00, 0x00,

;WORD_0000_1127: 0x00, 0x00,
;WORD_0000_1129: 0x00, 0x00,

;0x00, 0x00,

;local_retries_left: 0x00,

;targloc.off: 0x00, 0x00,
;targloc.seg: 0x00, 0x02,

;executive_target: 0x01, 0x00, 0x21, 0x01, 0x1A, 0x80, 0x00,
;const_default_executive_target: 0x01, 0x00, 0x21, 0x01, 0x1A, 0x80, 0x00,

;DAT_0000_1140:
;0x23, 0x00,

;0x04,
;0x00, 0x00, 0x00, 0x00, 0x22, 0x00, 0x01, 0x22, 0x01, 0x38, 0x00, 0x01, 0x01, 0x0D, 0x01, 0x07,
;0x62, 0x00, 0x0E, 0x01, 0x0F, 0x0E, 0x06, 0x74, 0x01, 0x1D, 0x01, 0x09, 0x1D, 0x07, 0x5D, 0x00

; Data block
	times 0x11e db 0

	pStack times 3 db 0	; pStack should be at 0x1121

	global_retry_count db 0	; Appears to be a boot attempt countdown

	dw 0	; Looks blank

	word_0000_1127 dw 0
	word_0000_1129 dw 0

	times 2 db 0
	
	; TODO: Make local_retries_left local to fn_load_executive
	local_retries_left db 0						; Possibly a countdown. Set to 3 in fn_load_executive if.cylinders_left != 0

	; This is the final target location segment:offset
	targloc:
		.off dw 0						; goes into the si register later
		.seg dw 0x200					; gets loaded into register es later
	
	; This is a struct that tells where the rest of the data is
	executive_target:
		.cylinder			db 0x01
		.head				db 0x00
		.cylinders_left		db 0x21
		.sect9cyl			db 0x01
		.sect9cyl_left		db 0x1A
		.nBytesLastSect		dw 0x0080
	
	; This is the source of the previous one. Also good as a backup.
	const_default_executive_target:
		.cylinder			db 0x01		; CHS Cylinder where data is
		.head				db 0x00		; CHS Head where data is
		.cylinders_max		db 0x21		; cylinders to read + 1
		.sect9cyl			db 0x01		; Sector 9 current cyl 
		.sect9cyl_max		db 0x1A		; Sector 9 cyls to rd + 1
		.nBytesLastSect		dw 0x0080	; Number of bytes from final sector
	
	;Explanation of the above struct:
	;	The executive is stored a little strangely. It isn't stored linearly.
	;	Each side of each cylinder has 9 sectors. Only one side is actually
	;	used. Essentially we concatenate the first 8 sectors of each cylinder
	;	cyl[0x01] thru cyl[0x20]. Then we circle back and do something
	;	similar for just the 9th sector of each cylinder, in our case, cyl[0x01]
	;	thru cyl[0x19]. Finally, we grab the 9th sector of the /next/ cylinder
	;	but we don't need the whole thing, so we just read the bytes we do need.
	;	It doesn't make much sense to me, either, unless it's related to how it
	;	was stored on the Commodore 64 or something.

	; Don't know what this is yet, but the interrupt uses it.
	DAT_0000_1140:
		dw 0x23

	; Definitely not random data. Not sure what it is yet, but it's required to
	; run the part of the executive after the joystick config.
	;times 0x21 db 0
	db 0x04,
	db 0x00, 0x00, 0x00, 0x00, 0x22, 0x00, 0x01, 0x22, 0x01, 0x38, 0x00, 0x01, 0x01, 0x0D, 0x01, 0x07,
	db 0x62, 0x00, 0x0E, 0x01, 0x0F, 0x0E, 0x06, 0x74, 0x01, 0x1D, 0x01, 0x09, 0x1D, 0x07, 0x5D, 0x00

; Code begins in earnest
begin:
	; Copy code segment into source and destination segments
	mov ax, cs
	mov ds, ax
	mov es, ax
	
	; Set the stack pointer (stack size: 0x120)
	; (Why isn't the stack pointer aligned to a 4B boundary?)
	cli
	mov bx, pStack
	mov sp, bx
	mov ss, ax
	sti
	
	mov byte [global_retry_count], 0x3	; Set the retry count to 3

label_0000_1177:

	; Not sure what these two do, refers to 0280:0000 aka addr 0x2800
	; These appear to be the default location where the executive goes.
	mov word [targloc.seg], 0x280
	mov word [targloc.off], 0x0
	
	; Copy const_default_executive_target into executive_target
	mov si, const_default_executive_target
	mov di, executive_target
	mov cx, 0x7
	cld							; Probably redundant, clear the direction flag
	rep movsb

	call fn_load_executive		; This loads the executive from disk.

	jnc executive_was_loaded		; if fn_load_executive does not set the carry bit, it was successful. Advance
	dec byte [global_retry_count]	; decrement the retry counter
	jnz label_0000_1177				; when the counter hits zero, reboot.
	int 0x19

; We have our executive loaded.
executive_was_loaded:
	cld							; Probably redundant, clear the direction flag

	; Since the executive looks like it actually has some sort of exe structure
	; (it isn't just a flat binary), we need to read it and pull out the important
	; parts, like the code and data segments, along with the starting addresses
	; Only then can we jump to that.

	; Retrieve the word at 0280:0008, add 0x280 to that, and save it in word_0000_1127
	; 0280:0008 is somewhere in the executive we loaded earlier
	mov ax, 0x280
	mov ds, ax
	mov si, 0x8
	lodsw							; Load word from ds:si = 0280:0008
	add ax, 0x280
	mov [cs:word_0000_1127], ax		; word_0000_1127 = [0280:0008] + 0x280
	;Executive has 0x0020 at 0280:0008, [cs:word_0000_1127] = 0x2a0

	mov si, 0x6						; ds still equals 0x280
	lodsw
	mov cx, ax						; cx = [0280:0006] (probably a count of some kind)
	;Executive has 0x0060 at 0280:0006, our counter is loaded with 0x60 (96d)

	; si = [0280:0018]
	mov si, 0x18					; ds still equals 0x280
	lodsw
	mov si, ax						; si = [0x2818]
	;Executive has 0x001e stored at 0280:0018, so now si = 0x1e


; This is a loop, based on whatever we loaded from the executive into cx
; Is it decoding something?
label_0000_11b9:
	mov ax, [si+0x2]				;ax = 0x410
	add ax, [cs:word_0000_1127]		;ax = ax + 0x2a0 = 0x6b0
	mov es, ax						;es = 0x6b0 (segment points at 0x6b00)
	mov di, [si]					;di = 0x18
	mov ax, [es:di]					;ax = [0018:06b0]
	add ax, [cs:word_0000_1127]		;ax = 
	stosw
	add si, byte +0x4
	loop label_0000_11b9

; This stuff saves the interrupt vector and sets the one provided below.
	
	; Then it installs the interrupt, for some reason.
	; It appears to take over int 0x21
	; Possibly used as a way to reload the game at some point?
	mov si, 0x16
	mov ax, [si]
	add ax, [cs:word_0000_1127]
	mov [si], ax
	push ds
	sub ax, ax
	mov ds, ax
	mov [0x86], cs
	mov word [0x84], interrupt_21h
	pop ds
	mov ax, [0xe]
	add ax, [cs:word_0000_1127]
	cli
	mov ss, ax
	mov sp, [0x10]
	sti
	jmp far [0x14]


fn_load_executive:

	; Load the executive from disk.
	; Returns 0 if successful, 1 if fail
	; Additionally sets the carry bit on fail.

	; This function appears to be responsible for loading the executive
	; Technically, the caller should be pushing the args onto the stack
	; and cleaning up afterwards, not using globals to pass around things.
	
	; It stores the executive in an odd format, but basically builds the executive
	; from the blocks on the disk like this:
	
	; From cylinders 1-32, it works upward through each cylinder, placing the first 8
	; sectors of each cylinder consecutively in memory at the target location.
	; Then it swings back through cylinders 1-16 (not the same number of cylinders
	; as before), placing the 9th sector of each consecutively. Finally, there's
	; one further 9th sector one cylinder out, but this is a partial sector, so
	; we have to copy this one byte by byte.
	
	; Once the executive is built, it can be executed.

		; Save ds, es
		push ds
		push es

		; Copy cs into ds, es
		mov ax, cs
		mov ds, ax
		mov es, ax
		
		cmp byte [executive_target.cylinders_left], 0x0		; if we have zero cylinders left, go ahead and skip ahead.
		jz .sect9_loads

	.load_next_batch:
		mov byte [local_retries_left], 0x3				; Probably a countdown?

	.label_0000_1217:

		; We're going to copy sectors from the disk to our target location.
		; This is probably the REAL executive.
		mov dh, [executive_target.head]				; Copy head (head) into dh
		mov dl, 0x0									; dl = 0 (disk 0x00 aka first floppy)
		mov ch, [executive_target.cylinder]			; Copy cylinder (cylinder) into ch
		mov cl, 0x1									; cl = 1 (sector 1)
		mov bx, buffer								; Set destination buffer

		; Copy cs into es
		push cs
		pop es

		; Copy 8 sectors from disk into the buffer
		; int 0x13(ah=2) sets the carry flag if it encountered an error.
		mov ax, 0x208
		int 0x13
		
		jnc .buffer_to_targloc		; If no error, CF is clear, jump past. If error, fall through

		; If read failed, we get here.
		; Reset the disk system, decrement the retry counter, and try again.
		sub ax, ax
		int 0x13						; AX=0 + int 0x13 -> Reset disk system.
		
		dec byte [local_retries_left]		; Decrement the retry counter
		jnz .label_0000_1217			; Try again.
		jmp .read_failure_exit			; Oops, no more retries. Exit with a failure.

	.buffer_to_targloc:

		; Looks like we're going to copy the 8 sectors from the buffer to [targloc.seg:targloc.off]
		; According to the bootloader, that's going to start at 0280:0000 or 0x2800
		mov si, buffer
		mov di, [targloc.off]
		mov es, [targloc.seg]
		mov cx, 0x800
		cld
		rep movsw
		
		add word [targloc.seg], 0x100			; targloc.seg += 0x100 Advance targloc by 8 sectors
		inc byte [executive_target.cylinder]	; Move to the next cylinder
		dec byte [executive_target.cylinders_left]	; cylinders_left--
		jnz .load_next_batch


	; Once we've loaded the 32 cylinders (cyl 1 through cyl 32), we get here. 
	; Or if cylinders_left == 0 at the very beginning, skip to here.

	.sect9_loads:
		cmp byte [executive_target.sect9cyl_left], 0x0	; If no cyls left, skip ahead.
		jz .label_0000_12ae

	.label_0000_1264:
		mov byte [local_retries_left], 0x3

	.label_0000_1269:
	
		; This reads the 9th sector from the current cylinder(?)	
		mov dh, [executive_target.head]
		mov dl, 0x0
		mov ch, [executive_target.sect9cyl]
		mov cl, 0x9
		mov bx, buffer
		push cs
		pop es
		mov ax, 0x201
		int 0x13
		jnc .label_0000_128e	; If read fails, fall through and try again.

		; Reset the disk system
		sub ax, ax
		int 0x13

		dec byte [local_retries_left]
		jnz .label_0000_1269			; Decrement the counter and try again
		jmp .read_failure_exit
		nop

	.label_0000_128e:
		mov si, buffer
		mov di, [targloc.off]
		mov es, [targloc.seg]
		mov cx, 0x100
		cld
		rep movsw
		add word [targloc.seg], byte +0x20		; targloc.seg += 0x20 Advance targloc one (1) sector
		inc byte [executive_target.sect9cyl]		; Advance cylinder to next
		dec byte [executive_target.sect9cyl_left]		; sect9cyl_left--
		jnz .label_0000_1264

	.label_0000_12ae:
		cmp word [executive_target.nBytesLastSect], byte +0x0	; If nBytesLastSect is zero, skip ahead to success.
		jz .exit_success
		mov byte [local_retries_left], 0x3

	.label_0000_12ba:

		; Read one (1) sector from the last cylinder which, is the last cylinder
		; previously used +1
		
		; Grab the sector from disk
		mov dh, [executive_target.head]
		mov dl, 0x0
		mov ch, [executive_target.sect9cyl]
		mov cl, 0x9
		mov bx, buffer
		push cs
		pop es
		mov ax, 0x201
		int 0x13

		; Check for success, if so jump ahead.
		; If failure, retry a few times.
		jnc .label_0000_12e3
		sub ax, ax
		int 0x13
		dec byte [local_retries_left]
		jnz .label_0000_12ba

	; We only get here if we run out of retries
	.read_failure_exit:
		mov ax, 0x1		; Not sure why ax is being set. Return value?
		stc				; Set the carry bit for error
		pop es
		pop ds
		ret

	.label_0000_12e3:
		;Copy number of bytes in nBytesLastSect from buffer to the target location
		mov di, [targloc.off]
		mov es, [targloc.seg]
		mov si, buffer
		mov cx, [executive_target.nBytesLastSect]
		cld
		rep movsb

	.exit_success:
		sub ax, ax		; Return 0
		clc				; No error. Clear the carry.
		pop es
		pop ds
		ret

; This appears to be replacing int 0x21
interrupt_21h:
		push bx
		push cx
		push dx
		push si
		push di
		push ds
		push es
		mov [cs:targloc.off], dx		; [targloc.off] = dx
		mov [cs:targloc.seg], ds		; [targloc.seg] = ds
		sti
		mov dx, cs
		mov es, dx
		mov ds, dx
		sub ah, ah
		cmp al, 0x4
		ja .label_0000_1343			; Apparently valid ax = {0,1,2,3}
		mov cl, 0x7
		mul cl
		add ax, DAT_0000_1140
		mov [cs:word_0000_1129], ax
		mov byte [cs:global_retry_count], 0xa

	.label_0000_132a:
		mov si, [cs:word_0000_1129]
		mov di, executive_target
		mov cx, 0x7
		cld
		rep movsb
		call fn_load_executive
		jnc .label_0000_1343
		dec byte [global_retry_count]
		jnz .label_0000_132a

	.label_0000_1343:
		pop es
		pop ds
		pop di
		pop si
		pop dx
		pop cx
		pop bx
		iret

buffer times 2048-($-$$) db 0
