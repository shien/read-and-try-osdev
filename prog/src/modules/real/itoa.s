itoa:
	; make stack flame
	push bp
	mov bp, sp

	; save register
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	; get args

	mov ax, [bp + 4]	; value
	mov si, [bp + 6]	; dst // buffer address
	mov cx, [bp + 8]	; size
	mov di, si			; last buffer position

	add di, cx			; dst = &dst[size - 1]
	dec di

	mov bx, word [bp + 12]	; flags

	; test sign

	;if (flags && 0x01)
	;{
	;    if (val < 0)
	;    {
	;        flags |= 2;
	;    }
	;}

	test bx, 0b0001 ; and
.10Q:	je .10E
	cmp ax, 0
.12Q:	jge .12E
	or bx, 0b0010
.12E:
.10E:


	; test sign output

	;if (flags && 0x02)
	;{
	;    if (val < 0)
	;    {
	;        val *= -1;
	;        *dst = '-';
	;    }
	;    else
	;    {
	;        *dst = '+';
	;    }
	;
	;    size--;
	;}

	test bx, 0b0010
.20Q:	je .20E
	cmp ax, 0
.22Q: jge .22F
	neg ax
	mov [si], byte '-'
	jmp .22E
.22F:
	mov [si], byte '+'
.22E:
	dec cx
.20E:


	; ASCII 

	mov bx, [bp + 10]
.30L:
	mov dx, 0
	div bx

	mov si, dx
	mov dl, byte [.ascii + si]

	mov [di], dl
	dec di

	cmp ax, 0

	loopnz .30L
.30E:

	; for blank

	;if (size)
	;{
	;	AL = '';
	;	if (flags & 0x04)
	;	{
	;		AL = '0';
	;	}
	;	DF = 1 
	;	while(--CX) *DI--= '';
	;}
	
	cmp cx, 0
.40Q: je .40E
	mov al, ' '
	cmp [bp + 12], word 0b0100
.42Q: jne .42E
	mov al, '0'
.42E:
	std			; DF = 1 (-)
	rep stosb	; while (--CX) *DI-- = '';
.40E:

	; return register

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax

	; drop stack frame

	mov sp, bp
	pop bp

	ret

.ascii db "0123456789ABCDEF" ; ascii table
