.model small
.stack 100h
.data
ten     dw 0Ah
num1 	dw 0
num2 	dw 0
ansmain dw 0
ansres	dw 0
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
input proc	;CX - output number
	call clear
inp:
		mov ah, 07h
		int 21h
		cmp al, 08h
		jz backspace
		cmp al, 0Dh
		jz vvod
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
		mov ah, 02h
		int 21h 
		xor ax, ax
	jmp inp	
backspace:
		cmp cx, 00h
		jz inp
		mov ax, cx
		xor dx, dx
		div ten
		mov cx, ax
		push cx
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
		pop cx
	jmp inp
zero:
	cmp cx, 00h
	jnz cxne0
	jmp inp
vvod:
	cmp cx, 00h
	jz inp
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
Start:
	mov ax, @DATA
	mov ds, ax
	
	call input
	mov num1, cx
	mov dl, '/'
	mov ah, 02h
	int 21h
	call input
	mov num2, cx
	
	call divnum
	mov dl, '='
	mov ah, 02h
	int 21h
	mov cx, ansmain
	call output	
	mov dl, ':'
	mov ah, 02h
	int 21h 
	mov cx, ansres
	call output	

	MOV ax, 4C00h
	INT 21h
end Start