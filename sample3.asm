.model small
.stack 100h
.data
	szinstr dw 0 
	pos_spa dw 0
	sz_wr dw 0
	input_string db 256 dup ('$')
	new_str db 0Dh, 0Ah, '$'
	output_mess db 50 dup ('$')
.code
;---------------------------------------
clear proc
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
ret
clear endp
;---------------------------------------
write_symb proc
	mov ah, 02h
	int 21h
ret
write_symb endp
;---------------------------------------
input proc 
	call clear
	cld
	lea di, input_string
inp:
	mov ah,07h
	int 21h
	cmp al, ','
	jz vyvod_symbol
	cmp al, '.'
	jz vyvod_symbol
	cmp al, '!'
	jz vyvod_symbol
	cmp al, '?'
	jz vyvod_symbol
	cmp al, 0Dh
	jz vvod
	cmp al, 08h
	jz backspace
	stosb
	inc cx
vyvod_symbol:
	mov dl, al
	call write_symb
	jmp inp
backspace:
	cmp cx, 0h
	jz inp
	dec cx
	dec di
	mov dl, al
	call write_symb
	mov dl, ' '
	call write_symb
	mov dl, 08h
	call write_symb
	jmp inp
vvod:
	lea dx, new_str
	call opstr
	cmp cx, 0h
	jz inp
	mov szinstr, cx
ret
input endp
;---------------------------------------
opstr proc
	mov ah, 09h
	int 21h
ret
opstr endp
;---------------------------------------
output proc
	lea dx, output_mess
	call opstr
ret
output endp
;---------------------------------------
task proc
	call clear
	cld
	mov cx, szinstr
	lea di, input_string
	mov pos_spa, di
	mov al, ' '
cycl:
		repne scasb
		mov bx, di
		sub bx, pos_spa
		cmp sz_wr, bx
		jc vvod_word
	last:
		mov pos_spa, di
		jcxz exit
		jmp cycl

vvod_word:
	push cx
	push ax
	push di
	mov sz_wr, bx
	mov cx, bx
	mov si, pos_spa
	lea di, output_mess
  l:
	lodsb
	stosb
	loop l
	pop di
	pop ax
	pop cx
	jmp last
exit:
ret
task endp
;---------------------------------------
start:
	mov ax, @data
	mov ds, ax
	mov es, ax
	
	call input	
	call task
	call output
	
	MOV AH, 4Ch
	INT 21h
end start 