get_font_adr:
	; make stack frame

	; +4 font address
	; +2 return address

	push bp
	mov bp, sp

	; save register

	push ax
	push bx
	push si
	push es
	push bp

	; get args

	mov si, [bp + 4]

	; get font address
	mov ax, 0x1130
	mov bh, 0x06		; 8x16 font (vga/mcga) 
	int 10h				; ES:BP=font address

	; save font address
	mov [si + 0], es	; segment
	mov [si + 2], bp	; offset

	; return register	
	pop bp
	pop es
	pop si
	pop bx
	pop ax

	; drop stack frame
	mov sp, bp
	pop bp

	ret

