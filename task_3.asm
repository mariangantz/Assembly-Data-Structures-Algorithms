%include "../include/io.mac"

; The `expand` function returns an address to the following type of data
; structure.
struc neighbours_t
    .num_neighs resd 1  ; The number of neighbours returned.
    .neighs resd 1      ; Address of the vector containing the `num_neighs` neighbours.
                        ; A neighbour is represented by an unsigned int (dword).
endstruc

section .bss
; Vector for keeping track of visited nodes.
visited resd 10000
global visited

section .data
; Format string for printf.
fmt_str db "%u", 10, 0

section .text
global dfs
extern printf

; C function signiture:
;   void dfs(uint32_t node, neighbours_t *(*expand)(uint32_t node))
; where:
; - node -> the id of the source node for dfs.
; - expand -> pointer to a function that takes a node id and returns a structure
; populated with the neighbours of the node (see struc neighbours_t above).
; 
; note: uint32_t is an unsigned int, stored on 4 bytes (dword).
dfs:
    push ebp
    mov ebp, esp
    pusha
    ;argumentele de pe stiva
    mov edi, [ebp + 8]
    ;argumentele de pe stiva
    mov ebx, [ebp + 12]
    ;argumentele de pe stiva
    mov dword [visited + 4 * edi], 1
    ; TODO: Implement the depth first search algorith, using the `expand`
    ; function to get the neighbours. When a node is visited, print it by
    ; calling `printf` with the format string in section .data.
    pusha
    push edi
    push fmt_str
    call printf
    ;restabilim stiva
    add esp, 8
    popa
    push edi
    call ebx
    ;restabilim stiva
    add esp, 4
    ;stabilim contorul
    mov ecx, 0
    mov edi, dword[eax]
    ;luam al doilea camp
    mov eax, dword[eax + 4]
CautaInGraf:
    cmp ecx, edi
    jz end
    ;luam nodurile
    mov edx, dword [eax + 4 * ecx]
    ;vedem daca nodul este vizitat
    cmp dword [visited + 4 * edx], 1
    je diff
    push ebx
    push edx
    call dfs
    ;restabilim stiva
    add esp, 8
diff:
    inc ecx
    jmp CautaInGraf

end:
    popa
    leave
    ret
