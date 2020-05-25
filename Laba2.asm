

org     100h

jmp     start

i dw 0h
ind1 dw 0h
ind2 dw 0h
String: db 'Enter a line: $'	
Stg: db 100h dup(0h)    ; massiv dlya stroki

;.code;	
start:

    mov ah, 09h
    mov dx, String
    int 21h	
    mov ah, 1h          ;	 funkciya vvoda simvola
    mov si, 0h
    mov bx, 0h
Input:	                ;    vvod massiva
    int 21h
    mov cx, si
    mov Stg[bx], cl     ;	 dlina slova
    cmp al, 32          ;	 proverka na slovo
    jne Skip1
    mov si, 0h
    add bx, 10h         ;	 nachalo sled. slova
    jmp Input
Skip1:
    inc si
    mov Stg[bx+si], al  ;	 pomeshenie simvola v massiv
    cmp al, 13
    jne Input
    mov Stg[bx+si], 0h  ;	 udalenie enter'a
    mov i, bx           ;	 kol-vo slov
    mov bx, 0h 
    
Sort1:	                ;   viborochnaya sortirovka
    mov di, bx          ;	indeks min dlini
    mov ax, bx
    add ax, 10h
Sort2:
    mov si, ax
    mov ind1,si         ;   zapomnit' nachal'nie sostoyaniya
    mov ind2,di
Sort2_1: 
    inc si
    inc di
    mov cl, Stg[si]     ;   proverka simvolov slov
    test cl, 20h             ;\
    jnz mini_1
    or cl, 20h
mini_1:
    mov ch, Stg[di]
    test ch, 20h
    jnz mini_2
    or ch, 20h
mini_2:
    cmp cl, ch              ;/
    je Sort2_1
    ja Skip2            ;   esli bol'she
    
    mov si,ind1
    mov di,ind2 
    mov di, si          ;	esli men'she
    jmp Skip2_1
    
Skip2: 
    mov si,ind1
    mov di,ind2 
Skip2_1: 
    add ax, 10h
    cmp ax, i
    jbe Sort2
    mov si, 0h
Sort3:
    moV cl, Stg[bx+si]  ;	smena slov
    mov al, Stg[di]
    mov Stg[bx+si], al
    mov Stg[di], cl
    inc si
    inc di
    cmp si, 10h
    jb Sort3
    add bx, 10h
    cmp bx, i
    jb Sort1
    
    mov ah, 02h         ;   funkciya ustanovki pozicii kursora
    mov bh, 0h          ;	Numb stranici
    mov dh, 2h          ;   Numb stroki
    mov dl, 0h          ;   Numb stolbca
    int 10h
    mov bx, 0h
    mov si, 0h
    mov ah, 2h;	 funkciya vivoda simvola
Output:	 ;vivod massiva
    inc si
    mov dx, word ptr Stg[bx+si]
    cmp dx, 0h
    jne Skip3
    cmp bx, i
    je Exit
    mov si, 0h
    add bx, 10h
    mov dx, ' '	
Skip3:
    int 21h
    cmp bx, i
    jbe Output
Exit:
    mov ah, 4ch;
    int 21h	
End