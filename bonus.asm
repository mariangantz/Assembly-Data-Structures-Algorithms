; Interpret as 64 bits code
[bits 64]

; nu uitati sa scrieti in feedback ca voiati
; assembly pe 64 de biti

section .text
global map
global reduce
map:
    ; look at these fancy registers
    push rbp
    mov rbp, rsp
    xor r9, r9
    mov rbx, rdi
itereaza:
    cmp r9, rdx
    je end
    ;elemntul sursa
    mov rdi, qword [rsi + 8 * r9]
    call rcx
    ;elemntul destinatie
    mov qword [rbx + 8 * r9], rax
    inc r9
    jmp itereaza
    ; sa-nceapa turneu'
end:
    leave
    ret


; int reduce(int *dst, int *src, int n, int acc_init, int(*f)(int, int));
; int f(int acc, int curr_elem);
reduce:
    ; look at these fancy registers
    push rbp
    mov rbp, rsp
    mov rbx, rdi
    mov r9, rsi
    mov rax, rcx
    ; sa-nceapa festivalu'
    xor r10, r10
iterate:
    cmp r10, rdx
    je gata
    push r10
    push rdx
    mov rdi, rax
    ;elemntul sursa
    mov rsi, qword [r9 + 8 * r10]
    call r8
    pop rdx
    pop r10
    inc r10
    jmp iterate
gata:
    leave
    ret

