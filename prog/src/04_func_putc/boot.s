%include "../modules/real/putc.s"

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

	push word'A'
	call putc
	add sp, 2

	push word'B'
	call putc
	add sp, 2

	push word'C'
	call putc
	add sp, 2

	jmp $


ALIGN 2, db 0

BOOT:
.DRIVE: dw 0 ; drive number

; bootflag

	times 510 - ($ - $$) db 0x00
	db 0x55, 0xAA
