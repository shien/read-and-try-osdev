read_chs:
	; args: drive(+4), sect(+6), dest(+8)

	; make stack frame

	push bp
	mov bp, sp

	push 3		; number of retly
	push 0		; reading number of sector

	; save register
	push bx
	push cx
	push dx
	push es		; extra segment
	push si 	; source index register

	; start processing
	mov si, [bp + 4]

	; set cx register
	mov ch, [si + drive.cyln + 0]	; CH cylinder number lower bytes
	mov cl, [si + drive.cyln + 1]	; CL cylinder number higher bytes

	shl cl, 6 	; CL <<= 6

	or cl, [si + drive.sect]		; CL |= sector number

	; read sector
	mov dh, [si + drive.head]		; DH = head number
	mov dl, [si + 0]				; DL = drive number
	mov ax, 0x0000					; AX = 0x0000
	mov es, ax						; ES = segment
	mov bx, [bp + 8]				; dest

.10L:
	mov ah, 0x02 					; read sector
	mov al, [bp + 6]				; AL = number of sector

	int 0x13
	jnc .11E						; if(CF) (read successfully)

	mov al, 0
	jmp .10E
.11E:

	cmp al, 0
	jne .10E
	mov ax, 0						; ret = 0
	dec word [bp - 2]				; --retry
	jnz .10L
.10E:
	mov ah, 0						; drop status infomation


	; return register
	pop si
	pop es
	pop dx
	pop cx
	pop bx

	; drop stack frame
	mov sp, bp
	pop bp

	ret
