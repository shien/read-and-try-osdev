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

	; prepare stage 2

	;  read next 512 bytes

	mov ah, 0x02			; read order
	mov al, 1				; reading number of sector
	mov cx, 0x0002			; cylinder / sector
	mov dh, 0x00			; head position
	mov dl, [BOOT.DRIVE]	; drive number
	mov bx, 0x7c00 + 512	; bx = offset
	int 0x13

.10Q: jne .10E
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
.DRIVE: dw 0 ; drive number

; modules

%include "../modules/real/puts.s"
%include "../modules/real/reboot.s"

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

	times(1024 * 8) - ($ - $$) db 0 ; 8K bytes
