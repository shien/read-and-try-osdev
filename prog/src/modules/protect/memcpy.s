memcpy:
	push ebp			; EBP + 0
	mov ebp, esp		; EBP + 4

	; save register

	push ecx
	push esi
	push edi

	; copy

	cld					; DF = 0
	mov edi, [ebp + 8]	; dest
	mov esi, [ebp + 12]	; src
	mov ecx, [ebp + 16]	; number of bytes

	rep movsb			; while(EDI++ = *ESI++);

	; return register

	pop edi
	pop esi
	pop ecx

	; drop stack flame

	mov esp, ebp
	pop ebp

	ret
