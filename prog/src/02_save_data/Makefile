SRC=boot.s

OUTPUT_IMG=boot.img
OUTPUT_LST=boot.lst

qemu:
	qemu-system-i386 -rtc base=localtime -drive file=${OUTPUT_IMG},format=raw -boot order=c

asm:
	nasm ${SRC} -o ${OUTPUT_IMG} -l ${OUTPUT_LST}

clean:
	rm ${OUTPUT_IMG} ${OUTPUT_LST}
