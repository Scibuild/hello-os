;GDT or global discriptor table tells the cpu some info about the RAM and how it
;Should access data in 32bit protected mode
;Basicly there are just a lot of bytes which each do different things
;go to OSdev.org for more info

gdt_begin:

gdt_null:
db 0x00
db 0x00

gdt_kernel_executable:
dw 0xFFFF  ;end of RAM
dw 0x00     ;begining of RAM
db 0x00     ;other part of begining of RAM
db 10011010b ;acess bits
db 11001111b ;flags then 6 bits I don't understand

gdt_kernel_data:  ;same as before but for data not excecutable
dw 0xFFFF
dw 0x0
db 0x0
db 10010010b
db 11001111b
db 0x0

gdt_end:

gdt_descriptor:   ;tells start and end of gdt
dw gdt_end - gdt_begin - 1
dd gdt_begin

;This is like #define in C
KERNEL_EXEC_SEG equ gdt_kernel_executable - gdt_begin
KERNEL_DATA_SEG equ gdt_kernel_data - gdt_begin
