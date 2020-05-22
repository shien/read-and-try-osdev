; entry point
entry:
	jmp ipl
	times 90 - ($ - $$) db 0x90


; program loader
ipl:
	cli ; 割り込み禁止

	jmp $

	times 510 - ($ - $$) db 0x00
	db 0x55, 0xAA
