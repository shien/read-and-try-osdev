putc:

	; make stack frame
	push bp
	push sp, bp

	; save register
	push ax
	push bx

	; start function

	mov ai, [bp + 4]
	mov ah, 0x0E
	mov bx, 0x0000
	int 0x10

	; return register
	pop bx
	pop ax

	; drop stack frame

	mov sp, bp
	pop bp

	ret
