memcpy:
	; make stack frame
	push	bp
	mov		bp, sp

	; save register
	push cx
	push si
	push di

	cld					; DF = 0 
	mov di, [bp + 4]	; src
	mov si, [bp + 6]	; dst
	mov cx, [bp + 8]	; number of byte

	rep movsb			; while(*DI++ = *SI++);


	; return register

	pop di
	pop si
	pop cx

	; drop stack frame

	mov sp, bp
	pop bp

	ret
