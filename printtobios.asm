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
