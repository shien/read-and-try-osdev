get_drive_param:

	; make stack frame
	push bp
	mov bp, sp

	; save register
	push bx
	push cx
	push es
	push si
	push di

	; start processing
	mov si, [bp + 4]		; SI buffer
	mov ax, 0				; init disk base table pointer 
	mov es, ax				; ES = 0
	mov di, ax				; DI = 0

	mov ah, 8				; get drive parameters
	mov dl, [si + drive.no]	; DL = drive number
	int 0x13
.10Q:	jc .10F				; if (CF == 0)
.10T:
	mov al, cl				; AX number of sectors
	and ax, 0x3F			; use lower 6bit

	shr cl, 6				; CX number of cylinder 

	ror	cx, 8
	; for getting max number of head, first cylinder number is 0
	inc cx

	movzx bx, dh			; move with zero-extend

 	; for getting max number of head,  first head number is 0 
	inc bx

	mov [si + drive.cyln], cx	; drive.cyln = CX
	mov [si + drive.head], bx	; drive.head = BX
	mov [si + drive.sect], ax	; drive.sect = AX

	jmp .10E
.10F:

	mov ax, 0
.10E:

	; return register
	pop di
	pop si
	pop es
	pop cx
	pop bx

	; drop stack frame
	mov sp, bp
	pop bp

	ret
