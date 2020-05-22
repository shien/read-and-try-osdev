BOOT_LOAD equ 0x7C00
ORG BOOT_LOAD

; entry point
entry:
	jmp ipl
	times 90 - ($ - $$) db 0x90


; program loader
ipl:
	cli ; deny interrupt

	mov ax, 0x0000
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, BOOT_LOAD

	sti ; allow interrupt

	mov [BOOT.DRIVE], dl ; save boot drive

	mov al, 'A' ; output charactor
	mov ah, 0x0E ; one char
	mov bx, 0x0000 ; page number and char color
	int 0x10 ; video BIOS call

	jmp $


ALIGN 2, db 0

BOOT:
.DRIVE: dw 0 ; drive number

; bootflag

	times 510 - ($ - $$) db 0x00
	db 0x55, 0xAA
