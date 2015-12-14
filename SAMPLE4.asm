.model small
.stack 100h
.data
N dw 0
M dw 0
File1 dw 0
File2 dw 0
File_name1 db '1.asm',0,'!$'
File_name2 db '2.txt',0,'!$'
Err_mess db 'Error, no open file$'
Ok_mess db 0Ah, 0Dh, 'File open:)$'
Buffer db 752 dup (0)
ten dw 0Ah
matrix1 dw 100 dup (?)
matrix2 dw 100 dup (?)
new_str db 0Dh, 0Ah, '$'
outfile db 752 dup(' ')
.code
;---------------------------------------
input_matr proc
		mov cx, N
loo1:
		push cx
		mov cx, M
	loo2:
			push cx
			call input_num
			mov ax, cx
			stosw
			pop cx
		loop loo2
		pop cx
	loop loo1
ret
input_matr endp
;---------------------------------------
clear proc
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
ret
clear endp
;---------------------------------------
input_num proc 
	call clear	
inp:
		lodsb
		cmp al, ' '
		jz vvod
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
		xor ax, ax
	jmp inp	
zero:
	cmp cx, 00h
	jnz cxne0
	jmp inp
vvod:
	cmp cx, 00h
	jz inp
ret
input_num endp
;---------------------------------------
input proc
	lea si, Buffer
	call input_num
	mov N, cx
	call input_num
	mov M, cx
	cld
	lea di, matrix1
	call input_matr
	lea di, matrix2
	call input_matr 	
ret
input endp
;---------------------------------------
task proc
	lea di, matrix2
	lea si, matrix1
	mov cx, N
loo11:
		push cx
		mov cx, M
	loo12:
			lodsw
			push ax
			push di
			push si
			pop di
			pop si
			lodsw
			pop bx
			cmp bx, ax
			jc endloop12
			mov ax, bx
		endloop12:
			sub di, 2h
			stosw
			push di
			push si
			pop di
			pop si
			loop loo12
		pop cx
	loop loo11
ret
task endp
;---------------------------------------
output_num proc		;CX - input number
	push ax
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
		stosb
	loop vyvod		
	mov dl, ' '
	int 21h
	stosb
ret	
output_num endp
;---------------------------------------
output proc
	lea di, outfile
	lea si, matrix1
	mov cx, N
loo21:
		push cx
		mov cx, M
	loo22:
			push cx
			lodsw
			call output_num
			pop cx
		loop loo22
		pop cx
		lea dx, new_str
		mov ah, 09h
		int 21h
		mov al, 0Dh
		stosb
		mov al, 0Ah
		stosb		
	loop loo21
	;; save in file)))
	mov ax,3D01h
	mov dx, offset File_name2
	int 21h
	mov File2, ax
	mov bx, ax
	mov ah, 40h
	mov cx, 02f0h
	mov dx, offset outfile
	int 21h	
	mov ah, 3Eh
	mov bx, File2
	int 21h
ret
output endp
;---------------------------------------
start:
	mov ax,@data
	mov ds, ax
	mov es, ax
	
	call clear
	mov ax, 3D00h
	mov dx, offset File_name1
	int 21h
	jc Error_file
	mov File1, ax
	mov bx, ax
	mov ah, 3Fh
	mov cx, 02f0h
	mov dx, offset Buffer
	int 21h	
	mov ah, 3Eh
	mov bx, File1
	int 21h

	call input
	call task	
	call output
	
	mov dx, offset Ok_mess
	jmp Out_prg
Error_file:
	mov dx, offset Err_mess
Out_prg:	
	mov ah, 09h
	int 21h		
	
	mov ah, 4Ch
	int 21h	
end start