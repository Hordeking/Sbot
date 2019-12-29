; This short program just resets the machine so that the on-disk bootloader can take over.
; It loads the magic number 0x1234 at memory location 0x472 (0040:0072), then jumps to the
; 8086 reset vector, 0xffff0 (ffff:0000)

; Load the magic number into 0x472
mov ax,0x40
mov ds,ax
mov word [0x72],0x1234

; Jump to standard intel reset vector
; In effect, we reset the processor.
mov ax,0xffff
push ax
mov ax,0x0
push ax
retf
