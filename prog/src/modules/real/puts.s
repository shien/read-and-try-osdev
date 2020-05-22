puts:
	; make stack frame

	push bp
	mov bp, sp

	; save register

	push ax
	push bx
	push si

	; get arguments

	mov si, [bp + 4]
	mov ah, 0x0E
	mov bx, 0x0000

	cld			; DF = 0

.10L:
	lodsb

	cmp al, 0

	je .10E


	int 0x10
	jmp .10L

.10E:

	; return register

	pop si
	pop bx
	pop ax

	; drop stack frame

	mov sp, bp
	pop bp

	ret
