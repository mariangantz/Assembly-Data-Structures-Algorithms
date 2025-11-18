; Interpret as 32 bits code
[bits 32]

%include "../include/io.mac"

section .data
    ;tipurile de parantezew
    paranteze db "([{}])", 0
    stiva: times 100 db 0
    ;lungimea sirului
    lungime dd 0

section .text
; int check_parantheses(char *str)
global check_parantheses
check_parantheses:
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ebx
    xor eax, eax
    ; sa-nceapa concursul
    mov ebx, [ebp + 8]
    ;setam contorul
    mov ecx, -1
det_lungime:
    inc ecx
    ;comparam cu caracterul de final
    cmp byte [ebx + ecx], 0
    jnz det_lungime
    mov dword [lungime], ecx
    ;incepem din nou parcugerea sirului
    mov ecx, 0
    ;lungimea stivei
    mov edi, 0
verificare:
    cmp ecx, dword [lungime]
    je end
    xor edx, edx
    mov dl, byte [ebx + ecx]
    cmp dl, byte [paranteze]
    je shooo
    ;al doilea tip de paranteza
    cmp dl, byte [paranteze + 1]
    je shooo
    ;al treilea tip de paranteza
    cmp dl, byte [paranteze + 2]
    je shooo
    ;al patrulea tip de paranteza
    cmp dl, byte [paranteze + 3]
    je nooo1
    ;al cincelea tip de paranteza
    cmp dl, byte [paranteze + 4]
    je nooo2
    ;al saselea tip de paranteza
    cmp dl, byte [paranteze + 5]
    je nooo3
revino:
    inc ecx
    jmp verificare

shooo:
    inc edi
    mov byte [stiva + edi], dl
    jmp revino

nooo1:
    xor eax, eax
    ;comparam cu tipul de paranteza
    mov al, byte [paranteze + 2] 
    cmp byte[stiva + edi], al
    jnz endw
    dec edi
    jmp revino
nooo2:
    xor eax, eax
    ;comparam cu tipul de paranteza
    mov al, byte [paranteze + 1] 
    cmp byte[stiva + edi], al
    jnz endw
    dec edi
    jmp revino 
nooo3:
    xor eax, eax
    mov al, byte [paranteze] 
    cmp byte[stiva + edi], al
    jnz endw
    dec edi
    jmp revino 

end:
    pop ebx
    pop edi
    pop esi
    xor eax, eax
    leave
    ret

endw:
    pop ebx
    pop edi
    pop esi
    ;marcam rezultatul
    mov eax, 1
    leave
    ret
