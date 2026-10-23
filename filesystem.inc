; This macro is here to allow us to mix db and dw in the file pointers.
%macro sbotfile 6
	db %1, %2, %3, %4, %5
	dw %6
%endmacro

; This structure is defined mostly to allow us to cast a filepointer and access the elements by name
struc FileEntry
	.cylinder			resb 1		; CHS Cylinder where data is
	.head				resb 1		; CHS Head where data is
	.nCylinders			resb 1		; Number of cylinders to read
	.sect9cyl			resb 1		; Sector 9 begin cylinder
	.nSect9cyl			resb 1		; Number of sector 9 cyls to rd
	.nBytesLastSect		resw 1		; Number of bytes from final sector. This is not part of the sect9cyls
endstruc
