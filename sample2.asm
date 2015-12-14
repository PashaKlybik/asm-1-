.model small
.stack 100h
.data
ten     dw 0Ah
num1 	dw 0
num2 	dw 0
ansmain dw 0
ansres	dw 0
symbone dw 0
symbtwo dw 0
.code
;---------------------------------------
delet_last proc
		mov ah, 03h
		int 10h
		dec dl
		push dx
		mov ah, 02h
		int 10h
		mov dl, ' '	
		int 21h
		pop dx
		int 10h
ret
delet_last endp
;---------------------------------------
clear proc
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
ret
clear endp
;---------------------------------------
input proc	;CX - output number
	call clear
inp:
		mov ah, 07h
		int 21h
		cmp al, 08h
		jz backspace
		cmp al, 0Dh
		jz vvod
		cmp al, '-'
		jz minus
		cmp al, '0'
		jc  inp	 ;>'0'
		jz  zero
	cxne0:
		mov dh, '9'
		cmp dh, al
		jc  inp	 ;<'9'
		sub al, 30h
		mov ah, 00h
		mov bx, ax
		mov ax, cx
		mul ten
		jc  vvod	
		add ax, bx
		jc  vvod
		mov cx, ax
		mov dl, bl
		add dl, 30h
		call write_symb 
		xor ax, ax
	jmp inp	
inp2:				;этот костыль я вставил потому что 4 часа ночи и лень разбираться и процедура вверху не очень нужна и без нее все норм работало, но как я уже сказал уже 4:15 :(( 
	jmp inp
backspace:
		xor ax, ax
		cmp cx, 00h
		jnz next  
		mov ax, 01h 
	next:
		or ax, symbtwo
		cmp ax, 00h
		jz inp
		mov ax, cx
		xor dx, dx
		div ten
		mov cx, ax
		push cx
		call delet_last
		pop cx
	jmp inp	
minus:
	cmp cx, 00h
	jnz inp
	mov ax, 1
	cmp ax, symbtwo
	jz inp
	mov symbtwo, ax
	mov dl, '-'
	call write_symb 
	jmp inp
zero:
	cmp cx, 00h
	jnz cxne0
	jmp inp
vvod:
	cmp cx, 00h
	jz inp2
ret
input endp
;---------------------------------------
output proc		;CX - input number
	push cx
	call clear
	pop ax
razd:
		xor dx, dx
		div ten
		add dl, 30h
		push dx
		inc cx
		cmp ax, 0h
	jnz razd
	mov ah, 02h
vyvod:
		pop dx
		int 21h
	loop vyvod		
ret	
output endp
;---------------------------------------
divnum proc
	call clear
	mov ax, num1
	mov bx, num2
	div bx
	mov ansmain, ax
	mov ansres,  dx
ret
divnum endp
;---------------------------------------
write_symb proc
	mov ah, 02h
	int 21h
ret
write_symb endp
;---------------------------------------
Start:
	mov ax, @DATA
	mov ds, ax
	
	call input
	mov num1, cx
	mov ax, symbtwo
	mov symbone, ax
	xor ax, ax
	mov symbtwo, ax
	mov dl, '/'
	call write_symb 
	call input
	mov num2, cx
	
	call divnum
	mov dl, '='
	call write_symb 
	mov ax, symbone
	xor ax, symbtwo
	cmp ax, 00h
	jz bezmin
	mov dl, '-'
	call write_symb
bezmin:	
	mov cx, ansmain
	call output	
	mov dl, ':'
	call write_symb 
	mov cx, ansres
	call output	

	MOV ax, 4C00h
	INT 21h
end Start