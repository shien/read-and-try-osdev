memcmp:
	; make stack frame
	push bp
	mov bp, sp

	; save register

	push bx
	push cx
	push dx
	push si
	push di

	; get argument

	cld ; clear DF // plus
	mov si, [bp + 4]
	mov di, [bp + 6]
	mov cx, [bp + 8]

	;compare byte

	repe cmpsb
	jnz .10F
	
	mov ax, 0		; ret = 0 True
	jmp .10E
	
.10F:
	mov ax, -1 ; ret = -1 False

.10E:

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	
	; drop stack frame

	mov sp, bp
	pop bp

	ret
