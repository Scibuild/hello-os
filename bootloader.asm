[org 0x7c00]

mov     ax, cs
mov     ds, ax
mov     es, ax
mov     ss, ax

mov [BOOT_DRIVE], dl

mov bp, 0x9000	;base pointer
mov sp, bp			;stack pointer

mov bx, 0x9000  ;Where to put the data (the stack)

mov cl, 2				; sector to read
mov dl, [BOOT_DRIVE]
call load_disk

jmp bp

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

times 510 -($-$$) db 0
dw 0xaa55
;sector 2
mov ax, 0x0120
mov ds, ax
mov bx, hello
call print_string
jmp $
print_string:
	push ax
	mov ah, 0x0e
print_character_loop:
	mov al, [bx]
	cmp al, 0
	je print_finished
	int 0x10
	add bx, 1
	jmp print_character_loop
print_finished:
	pop ax
	ret
hello db "Hello World!",10, 13, "How are you? Sorry you cant type yet.", 10, 13, 0
