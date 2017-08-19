[org 0x7c00]

mov [BOOT_DRIVE], dl

mov bp, 0x9000	;base pointer
mov sp, bp			;stack pointer

mov bx, 0x9000  ;Where to put the data (the stack)

mov cl, 2				; sector to read
mov dl, [BOOT_DRIVE]
call load_disk

call print_string

jmp $

load_disk:
	push dx
	mov ah, 0x02	;The read instruction
	mov al, 1			;Only read 1 sector
	mov ch, 0x00  ;Cylinder 0
	mov dh, 0x00	;Head 0
	int 0x13
	jc load_disk_error
	pop dx				;interupt overwrote this so we are actually geting the first
								;character in memory
	cmp al, 1
	jne load_disk_error
load_disk_error:


	jmp $

print_string:
	pusha
	mov ah, 0x0e
print_character_loop:
	mov al, [bx]
	cmp al, 0
	je print_finished
	int 0x10
	add bx, 1
	jmp print_character_loop
print_finished:
	popa
	ret

error_message db "Error!",0

BOOT_DRIVE: db 0

times 510 -($-$$) db 0
dw 0xaa55
;sector 2
db "Hello world!",0
