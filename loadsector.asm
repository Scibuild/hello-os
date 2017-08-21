
mov [BOOT_DRIVE], dl

mov bp, 0x9000	;base pointer
mov sp, bp			;stack pointer

mov bx, 0x9000  ;Where to put the data (the stack)

mov cl, 2				; sector to read
mov dl, [BOOT_DRIVE]
call load_disk

load_disk:
	;push dx
	mov ah, 0x02	;The read instruction
	mov al, 1			;Only read 1 sector
	mov ch, 0x00  ;Cylinder 0
	mov dh, 0x00	;Head 0
	int 0x13
	jc load_disk_error
	;pop dx				;interupt overwrote this so we are actually geting the first
								;character in memory
	cmp al, 1
	jne load_disk_error
	ret
load_disk_error:
	mov bx, error_message
	call print_string
	jmp $

  error_message db "Error!", 0

BOOT_DRIVE: db 0
