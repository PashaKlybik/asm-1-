.model tiny
.code
org 100h
Start:
jmp Init

Int_21h_proc proc
	cmp ah, 09h
	jz Ok_09
	jmp dword ptr cs:[Int_21h_vect]
	
	Ok_09:
	push ds si es di dx cx bx ax
	pushf
	push cs
	push cs
	cld
	pop es
	mov si, dx
	lea di, In_string
	xor cx, cx
 copy:
		lodsb
		cmp al, '$'
		jz End_loop
		inc cx
		stosb
	jmp copy
 End_loop: 
	pop ds
	mov Size_String, cx
	lea si, In_String
	lea di, out_String
 Chang_Symbol:
		lodsb
		cmp al, 041h
		jc No_letr
		mov dl, 07Ah
		cmp dl, al
		jc No_letr
		mov dl, 05Bh
		cmp dl, al
		jc dec_letr
		cmp al, 060h
		jc inc_letr		
		No_letr:
		stosb
	loop Chang_Symbol
	
	mov ah, 09h
	mov dx, offset Out_String
	popf
	pushf
	call dword ptr cs:[Int_21h_vect]
	pop ds si es di dx cx bx ax
iret

	inc_letr:
		add al, raz 
	jmp No_letr
	dec_letr:
		sub al, raz
	jmp No_letr

Int_21h_proc endp

	raz db 020h
	Int_21h_vect dd ?
	In_String db 255 dup ('$')
	Size_String dw 0
	Out_String db 255 dup ('$')
	
Init:
	mov ah, 35h
	mov al, 21h
	int 21h
	
	mov word ptr Int_21h_vect, bx
	mov word ptr Int_21h_vect+2, es
	
	mov ax, 2521h	
	
	mov dx, offset Int_21h_proc
	int 21h
	
	mov dx, offset Init
	int 27h
	
end Start