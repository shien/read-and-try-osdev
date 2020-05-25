	BOOT_LOAD equ 0x7C00
	ORG BOOT_LOAD

%include "../include/macro.s"

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

	cdecl puts, .s0

	cdecl reboot

	jmp $

.s0 db "Booting...", 0x0A, 0x0D, 0 ; 0x0A LF , 0x0D CR
.s1 db "--------", 0x0A, 0x0D, 0 ; 0x0A LF , 0x0D CR

ALIGN 2, db 0

BOOT:
.DRIVE: dw 0 ; drive number

; modules

%include "../modules/real/puts.s"
%include "../modules/real/reboot.s"

; bootflag

	times 510 - ($ - $$) db 0x00
	db 0x55, 0xAA
