; This code expects to be run from 0000:1000

; This is the second stage bootloader for Spiderbot. It is comprised of
; four sectors beginning at sector 14 (addr 0x1c00) of the floppy. So to recap,
; Sectors 14, 15, 16, & 17 make up this bootloader.

; It sets up a stack at 0x1121 (should be baseaddr+0x121 for portability), and
; has a few other important bits in the first 0x163 bytes or so. Most importantly
; are the little pieces at 0x1132, which seem to relate to where the real game
; is stored.

bits 16
org 0x1000

pExe equ 0x280		; Segment pointer to loaded Exe. Original Spiderbot used 0x280

jmp begin

; Data block

	; Why doesn't pStack point at 0x1120 or 0x1122? That's aligned to 2 bytes.
	times 0x8f dw 0
	pStack dw 0		; pStack points at 0x1121, and is currently empty/invalid.
	
	db 0	; Padding to align to even byte

	global_retry_count db 0	; How many times to retry a file read.

	dw 0	; Looks blank

	; This is just a temp variable used as a far pointer.
	; The primary use is to determine the segment the exe data actually starts at (to do the relocations)
	; It's also used in the interrupt handler as a destination for the loaded file.
	global_far_pointer:
		.seg dw 0		; Used to store pExe+pEXE.headerlength. Also used in int 21h.
		.offset dw 0	; Used by int 21h that this bootloader sets up.

	times 2 db 0

	; TODO: Make local_retries_left local to fn_load_file
	local_retries_left db 0						; Used in fn_load_file. Set to 3 if .nCylinders != 0

	; This is used by fn_load_file in the manner of a global struct to know where to put the loaded data.
	; The whoever calls fn_load_file needs to set these before calling it.
	global_ram_destination:
		.off dw 0						; goes into the si register later
		.seg dw 0x200					; gets loaded into register es later

	; This is used by fn_load_file in the manner of a global struct to know where to load from.
	; The whoever calls fn_load_file needs to copy data here before calling it.
	global_file_source:
		.cylinder			db 0x01		; CHS Cylinder where data is
		.head				db 0x00		; CHS Head where data is
		.nCylinders			db 0x21		; Number of cylinders to read
		.sect9cyl			db 0x01		; Sector 9 begin cylinder
		.nSect9cyl			db 0x1A		; Number of sector 9 cyls to rd
		.nBytesLastSect		dw 0x0080	; Number of bytes from final sector. This is not part of the sect9cyls

	; Explanation of the above struct:
	;	Start at .cylinder, copy first 8 sectors, increment cylinder. Do this .nCylinders times.
	;	Continue at .sect9Cyl, copy 1 sector, increment cylinder. Do this .nSect9cyl times.
	;	Continue as in the previous step, but only copy nBytesLastSect from that sector.
	;	Each step just concatenates its data onto the last.
	;	Please see File_On_Disk_Structure.txt for far more detail.

	; These are the pointers to the files used in this game.
	ondisk_mz_exec:
				db 0x01, 0x00, 0x21, 0x01, 0x1a, 0x80, 0x00		; The main executive

	ondisk_files:
		file0	db 0x23, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00		; Splash screen
		file1	db 0x22, 0x00, 0x01, 0x22, 0x01, 0x38, 0x00
		file2	db 0x01, 0x01, 0x0d, 0x01, 0x07, 0x62, 0x00
		file3	db 0x0e, 0x01, 0x0f, 0x0e, 0x06, 0x74, 0x01
		file4	db 0x1d, 0x01, 0x09, 0x1d, 0x07, 0x5d, 0x00

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

retrieve_mz_exec:

	; Set global_ram_destination paramater = pExe:0000 for fn_load_file
	mov word [global_ram_destination.seg], pExe
	mov word [global_ram_destination.off], 0x0

	; Copy ondisk_mz_exec into global_file_source
	mov si, ondisk_mz_exec
	mov di, global_file_source
	mov cx, 0x7
	cld							; Probably redundant, clear the direction flag
	rep movsb					; Copy bytes from si to di while cx > 0

	; fn_load_file(pExe:0000, ondisk_mz_exec).
	call fn_load_file			; This loads the executive from disk.

	jnc executive_was_loaded		; if fn_load_file does not set the carry bit, it was successful. Advance
	dec byte [global_retry_count]	; decrement the retry counter
	jnz retrieve_mz_exec			; Try again. When the counter hits zero, reboot.
	int 0x19						; Reboots the system without clearing memory or restoring interrupt vectors.


; We have our executive loaded. Now we need to set up the relocation table.
; We're reading the exe and making adjustments to the far pointers in it.
executive_was_loaded:

	%define pExe.nRelocations 0x06
	%define pExe.sizeHeader 0x08
	%define pExe.ss 0x0e
	%define pExe.sp 0x10
	%define pExe.entry 0x14
	%define pExe.cs 0x16
	%define pExe.reloc_table_offset 0x18

	cld
	
	; Basic MZ Exe structure: Header{Options, Relocation_Table}, Payload

	; Read the exe header, compute the absolute segment where the payload starts
	mov ax, pExe
	mov ds, ax
	mov si, pExe.sizeHeader
	lodsw							; Load word from ds:si = pExe:0008
	add ax, pExe					; ax = pExe + [pExe:0008]
	mov [cs:global_far_pointer.seg], ax		; global_far_pointer.seg = pExe + pExe.sizeHeader

	mov si, pExe.nRelocations
	lodsw							; Load word from ds:si = pExe:0006
	mov cx, ax						; cx = pExe.num_relocs

	mov si, pExe.reloc_table_offset	; ds:si = [pExe:reloc_table_offset]
	lodsw							; ax = pExe + [pExe:0018]
	mov si, ax						; si = [pExe.reloc_table_offset]


; reloc_table_offset[i] is an array of pointers.
;
; What we are doing here is this.
; The MZ header reloc_table_offset points at an array of EXE_RELOC
;   struct EXE_RELOC {
;     unsigned short offset;
;     unsigned short segment;
;   };
; Each one of these entries points at a location relative to THE END OF THE HEADER.
;  Another way to put it might be "relative to the text/code section". I don't know if data sections also get relocation entries.
;
; Far pointers are absolute, so they have to be adjusted, unlike regular offset 16b pointers.
; When an exe is loaded, it is not loaded at segment 0x0000 (That's the Interrupt Vector Table). So wherever we load the exe,
; we also need to adjust the far pointers to account for that. Not only that, but the raw far pointers are given relative to
; the end of the header, so if we want an absolute location segment in ram, we have to transform them from relative to the
; header end to relative to the beginning of ram.
;
; Offsets don't change, only segments.
;
; In essence, we are going to dereference absolute_pointer = local_pointer+(local_reference-new_referemce)
;  local reference is just wherever the header ends in ram, and we want our new reference to be memory location 0.
;
; Example: Our local pointer is 0410:0018, our exe was loaded at 0280:0000, and our header is 0x20 paragraphs long.
;          In order to find the absolute location in memory, we have to adjust our offsets by 0x280 + 0x20 = 0x2a0 paragraphs.
;          Local 0410:0018 relative to the code section becomes 06b0:0018 in absolute terms.
;
; Once we have the absolute location of the thing pointed at by the entry, we just need to adjust the value there by the same amount.
;
; More or less it's far_pointer = *(reloc_reference+load_location_adjustment)+load_location_adjustment.
;  In the example above, Local 0410:0018 (absolute 06b0:0018) points at a far pointer 0d38:xxxx (local).
;  Adjusted, it becomes 1088:xxxx (absolute).

adjust_relocations:

	; Parameters:
	; 	cs:global_far_pointer.seg = the payload begin paragraph
	;	ds:si points at the first relocation etable entry
	;	cx is set to the number of relocation entries

	;This code cycles through each entry in the relocation table
	mov ax, [si+0x2]					; Fetch relocation entry
	add ax, [cs:global_far_pointer.seg]	; Adjust it to account for the segment we loaded the file AND the paragraph length of the header
	mov es, ax							; Now the relocation entry points at the actual segment in memory there the subject is
	mov di, [si]						; Offset within that paragraph stays the same
	mov ax, [es:di]						; Retrieve the subject
	add ax, [cs:global_far_pointer.seg]	; Offset the the subject by the same amount. This is the segment of a far reference.
	stosw								; Store it back, adjusted.
	add si, byte +0x4					; Increment which relocation table entry we're pointing at.
	loop adjust_relocations				; One down, get the next one that we just pointed at.

	;This bit also adjusts the entry point in the header itself
	mov si, pExe.cs
	mov ax, [si]						; ax = *(pEXE+0x16) = 0x410
	add ax, [cs:global_far_pointer.seg]	; Adjust entry point as well.
	mov [si], ax						; Store it back

	; Install the new int 0x21 handler.
install_int_21:
	push ds								; Save ds
	sub ax, ax							; Zero ax
	mov ds, ax							; IVT is in segment 0x0000
	mov [0x21*4+2], cs					; interrupt_21h is located in segment 0x0000
	mov word [0x21*4], interrupt_21h	; And also do the offset
	pop ds								; Restore ds, the interrupt is installed.

	; Get ready for a far jump to our exe!

	; Set stack to what the EXE wants.
	mov ax, [pExe.ss]					; ax = preferred stack segment pExe.ss
	add ax, [cs:global_far_pointer.seg]	; Adjust the preferred stack segment to absolute terms.
	cli									; Don't want interrupts while doing this
	mov ss, ax							; Set stack segment to preferred pExe.ss
	mov sp, [pExe.sp]					; Set stack segment to preferred pExe.sp
	sti									; Done setting stack, turn interrupts back on.

	jmp far [pExe.entry]				; Jump to the entry point in the header. jmp far [pExe.Entry]


;=========================================================================
; Called to load a file into ram.
; 
; Parameters (all globals): global_ram_destination, global_file_source
;
; cs:global_file_source where to fetch the data from disk.
; cs:global_ram_destination is a far pointer to where the file is saved.
;
; Sets CF on error, CF clear on success.
; 
;=========================================================================

fn_load_file:

	; Load the executive from disk.
	; Returns 0 if successful, 1 if fail
	; Additionally sets the carry bit on fail.

	; This function appears to be responsible for loading the executive
	; Technically, the caller should be pushing the args onto the stack
	; and cleaning up afterwards, not using globals to pass around things.

	; The executive is stored in an odd format, and this subroutine basically
	; builds the executive from the blocks on the disk like this:

	; From cylinders 1-33, it works upward through each cylinder, placing the first 8
	; sectors of each cylinder consecutively in memory at the target location.
	; Then it swings back through cylinders 1-16 (not the same number of cylinders
	; as before), placing the 9th sector of each consecutively. Finally, there's
	; one further 9th sector one cylinder out, but this is a partial sector, so
	; we only copy the last nBytesLastSect from the buffer after reading that sector.

	; Once the executive is built, it still needs to have its relocation done.
	; This sub doesn't handle that.

		; Save ds, es
		push ds
		push es

		; Copy cs into ds, es
		mov ax, cs
		mov ds, ax
		mov es, ax

		cmp byte [global_file_source.nCylinders], 0x0		; if we have zero cylinders left, go ahead and skip ahead.
		jz .sect9_loads

	.load_next_batch:
		mov byte [local_retries_left], 0x3				; How many tries before failing each disk read.

	.load_part_one:

		; We're going to copy sectors from the disk to our target location.
		; This is probably the REAL executive.
		mov dh, [global_file_source.head]				; Copy head (head) into dh
		mov dl, 0x0									; dl = 0 (disk 0x00 aka first floppy)
		mov ch, [global_file_source.cylinder]			; Copy cylinder (cylinder) into ch
		mov cl, 0x1									; cl = 1 (sector 1)
		mov bx, buffer								; Set destination buffer

		; Copy cs into es
		push cs
		pop es

		; Copy 8 sectors from disk into the buffer
		; int 0x13(ah=2) sets the carry flag if it encountered an error.
		mov ax, 0x208
		int 0x13

		jnc .buffer_to_target		; If no error, CF is clear, jump past. If error, fall through

		; If read failed, we get here.
		; Reset the disk system, decrement the retry counter, and try again.
		sub ax, ax
		int 0x13						; AX=0 + int 0x13 -> Reset disk system.

		dec byte [local_retries_left]		; Decrement the retry counter
		jnz .load_part_one			; Try again.
		jmp .read_failure_exit			; Oops, no more retries. Exit with a failure.

	.buffer_to_target:

		; Looks like we're going to copy the 8 sectors from the buffer to [global_ram_destination]
		; According to the bootloader, that's going to start at 0280:0000 or 0x2800
		mov si, buffer
		mov di, [global_ram_destination.off]
		mov es, [global_ram_destination.seg]
		mov cx, 0x800
		cld
		rep movsw

		add word [global_ram_destination.seg], 0x100			; global_ram_destination.seg += 0x100 Advance global_ram_destination by 8 sectors
		inc byte [global_file_source.cylinder]	; Move to the next cylinder
		dec byte [global_file_source.nCylinders]	; nCylinders--
		jnz .load_next_batch


	; Once we've finished loading the cylinders with sectors 1-8, we get here.
	; Or if nCylinders == 0 at the very beginning, skip to here.

	.sect9_loads:
		cmp byte [global_file_source.nSect9cyl], 0x0	; If no cyls left, skip ahead.
		jz .check_for_nBytes_at_end

	.label_0000_1264:
		mov byte [local_retries_left], 0x3

	.label_0000_1269:

		; This reads the 9th sector from the current cylinder(?)
		mov dh, [global_file_source.head]
		mov dl, 0x0
		mov ch, [global_file_source.sect9cyl]
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
		mov di, [global_ram_destination.off]
		mov es, [global_ram_destination.seg]
		mov cx, 0x100
		cld
		rep movsw
		add word [global_ram_destination.seg], byte +0x20		; global_ram_destination.seg += 0x20 Advance global_ram_destination one (1) sector
		inc byte [global_file_source.sect9cyl]		; Advance cylinder to next
		dec byte [global_file_source.nSect9cyl]		; nSect9cyl--
		jnz .label_0000_1264
		
	.check_for_nBytes_at_end:
		; This is the last section. If we have any bytes. read in the sector from disk and copy just those bytes out.
		cmp word [global_file_source.nBytesLastSect], byte +0x0	; If nBytesLastSect is zero, skip ahead to success.
		jz .exit_success
		mov byte [local_retries_left], 0x3

	.read_nLastBytes:

		; Read one (1) sector from the last cylinder which, is the last cylinder
		; previously used +1 (it gets incremented each time we finish a cylinder)

		; Grab the sector from disk
		mov dh, [global_file_source.head]
		mov dl, 0x0
		mov ch, [global_file_source.sect9cyl]
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
		jnz .read_nLastBytes

	; We only get here if we run out of retries
	.read_failure_exit:
		mov ax, 0x1		; Not sure why ax is being set. Return value?
		stc				; Set the carry bit for error
		pop es
		pop ds
		ret

	.label_0000_12e3:
		;Copy number of bytes in nBytesLastSect from buffer to the target location
		mov di, [global_ram_destination.off]
		mov es, [global_ram_destination.seg]
		mov si, buffer
		mov cx, [global_file_source.nBytesLastSect]
		cld
		rep movsb

	.exit_success:
		sub ax, ax		; Return 0
		clc				; No error. Clear the carry.
		pop es
		pop ds
		ret

;======================================================
; int 0x21: Spiderbot's custom read-file ISR
;
; AL = Valid inputs 0, 1, 2, 3, 4 (index into ondisk_files[AL] array)
; DS = target seg
; DX = target offset
;
; Outputs: CF set if error?
;
; This ISR is called by several functions when they load
;	files from the native "file system". There are only
;	five possible files. Technically six, but this ISR
;	can't be called with AL=-1 to load the MZ.
;
;======================================================

interrupt_21h:
		
		; Save the registers (are PUSHA and PUSHF not available?)
		push bx
		push cx
		push dx
		push si
		push di
		push ds
		push es
		
		; Save global_ram_destination = ds:dx
		mov [cs:global_ram_destination.off], dx
		mov [cs:global_ram_destination.seg], ds

		sti
		
		; Using "tiny" model for this interrupt.
		; CS = 0x0000
		mov dx, cs	
		mov es, dx
		mov ds, dx
		
		sub ah, ah							; Zero out AH
		cmp al, 0x4
		ja .clean_up_and_exit				; Apparently valid ax = {0,1,2,3,4}

		mov cl, 0x7
		mul cl								; ax = al*0x07 = {0x00, 0x07, 0x0E, 0x15, 0x1c}
		add ax, ondisk_files				; ax = {1140, 1147, 114E, 1155, 115C}
		mov [cs:global_far_pointer.offset], ax	; The pointer is now pointed at one of the ondisk files.

		; At this point, cs:global_far_pointer.offset should be pointing at file[0-4]'s location.

		mov byte [cs:global_retry_count], 0xa	; Set up to retry loading the exec 10 times.

	.read_from_disk:

		; Copy the struct to the global fn_load_file uses.
		mov si, [cs:global_far_pointer.offset]
		mov di, global_file_source
		mov cx, 0x7
		cld
		rep movsb

		; fn_load_file(global_ram_destination, global_file_source)
		call fn_load_file		; Loads the file to wherever the caller wants.
		jnc .clean_up_and_exit
		dec byte [global_retry_count]
		jnz .read_from_disk

	.clean_up_and_exit:
		pop es
		pop ds
		pop di
		pop si
		pop dx
		pop cx
		pop bx
		iret

buffer times 2048-($-$$) db 0
