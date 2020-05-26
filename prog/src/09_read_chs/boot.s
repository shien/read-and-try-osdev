; macro
%include "../include/macro.s"
%include "../include/define.s"

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

	mov [BOOT + drive.no], dl ; save boot drive

	cdecl puts, .s0

	; prepare stage 2

	;  read next 512 bytes
	mov bx, BOOT_SECT - 1
	mov cx, BOOT_LOAD + SECT_SIZE	; CX = next load address
	cdecl read_chs, BOOT, bx, cx

	cmp ax, bx						; if (AX != rest number of sector)
.10Q: jz .10E
.10T: cdecl puts, .e0
	cdecl reboot
.10E:

	; go next stage

	jmp stage_2

	; data

.s0 db "Booting...", 0x0A, 0x0D, 0 ; 0x0A LF , 0x0D CR
.e0 db "Error sector read"

ALIGN 2, db 0

BOOT:
	istruc drive
		at drive.no, dw 0
		at drive.cyln, dw 0
		at drive.head, dw 0
		at drive.sect, dw 2
	iend

; modules

%include "../modules/real/puts.s"
%include "../modules/real/reboot.s"
%include "../modules/real/read_chs.s"

; bootflag 1st stage

	times 510 - ($ - $$) db 0x00
	db 0x55, 0xAA


; stage 2

stage_2:
	
	; show strings

	cdecl puts, .s0

	; finish processing

	jmp $

; data

.s0 db "2nd stage...", 0x0A, 0x0D, 0

; padding

	times BOOT_SIZE - ($ - $$) db 0 ; 8K bytes
