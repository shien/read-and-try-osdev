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
%include "../modules/real/read_chs.s"
%include "../modules/real/reboot.s"

; bootflag 1st stage

	times 510 - ($ - $$) db 0x00
	db 0x55, 0xAA

; get information in real mode

FONT:
.seg dw 0
.off dw 0

; modules

%include "../modules/real/itoa.s"
%include "../modules/real/get_drive_param.s"
%include "../modules/real/get_font_adr.s"

; stage 2

stage_2:
	
	; show strings

	cdecl puts, .s0

	; get drive info

	cdecl get_drive_param, BOOT

	cmp ax, 0

.10Q:	jne .10E
.10T:	cdecl puts, .e0
	call reboot
.10E:

	; print dirve info

	mov ax, [BOOT + drive.no]
	cdecl itoa, ax, .p1, 2, 16, 0b0100

	mov ax, [BOOT + drive.cyln]
	cdecl itoa, ax, .p2, 4, 16, 0b0100

	mov ax, [BOOT + drive.head]
	cdecl itoa, ax, .p3, 2, 16, 0b0100

	mov ax, [BOOT + drive.sect]
	cdecl itoa, ax, .p4, 2, 16, 0b0100
	cdecl puts, .s1

	; go to next stage

	jmp stage_3rd

; data

.s0 db "2nd stage...", 0x0A, 0x0D, 0
.s1 db "Drive:0x"

.p1 db "  ,C:0x"
.p2 db "  ,H:0x"
.p3 db "  ,S:0x"
.p4 db "  ", 0x0A, 0x0D, 0

.e0 db "Can't get drive parameter.", 0


; stage_3rd

stage_3rd:

	; show strings
	cdecl puts, .s0

	; get font for protected mode
	cdecl get_font_adr, FONT

	; show font address
	cdecl itoa, word [FONT.seg], .p1, 4, 16, 0b0100 
	cdecl itoa, word [FONT.off], .p2, 4, 16, 0b0100 
	cdecl puts, .s1

	; finish processig
	jmp $

	; data
.s0 db "3rd stage...", 0x0A, 0x0D, 0 
.s1 db "Font Address = "
.p1 db "ZZZZ:"
.p2 db "ZZZZ", 0x0A, 0x0D, 0 
	db 0x0A, 0x0D, 0

; padding

	times BOOT_SIZE - ($ - $$) db 0 ; 8K bytes
