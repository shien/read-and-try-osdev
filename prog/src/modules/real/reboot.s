reboot:

	; show message

	cdecl puts, .s0

	; wait key input

.10L:
	mov ah, 0x10
	int 0x16

	cmp al, ' '
	jne .10L

	; input return
	cdecl puts, .s1

	; reboot
	int 0x19

	; string data

.s0 db 0x0A, 0x0D, "PUSH Space key to reboot...", 0
.s1 db 0x0A, 0x0D, 0x0A, 0x0D, 0



