[org 0x7c00]
[bits 16]		;still in 16 bit mode
mov bp, 0x9000
mov sp, bp

call switch_to_32pm
jmp $

switch_to_32pm:
	cli    ;Turn of interupts
	lgdt [gdt_descriptor]
	mov eax, cr0  ;copy the cr0 controll register into eax so we can manipulate it
	or eax, 0x1		;if first bit is high will enable protected mode
	mov cr0, eax	; move eax back into cr0
	jmp KERNEL_EXEC_SEG:flush_regesters		;will jump in 32bit mode

[bits 32]			;For the compiler to know everything bellow this is 32 bit code

flush_regesters:
	mov ax, KERNEL_DATA_SEG		;registers work differently now
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ebp, 0x90000 	;Move stack somewhere out of the way
	mov esp, ebp


jmp $


%include 'gdt.asm'
times 510 -($-$$) db 0
dw 0xaa55
