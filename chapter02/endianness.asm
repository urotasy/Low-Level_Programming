; big endian と little endian

global _start

section .data

newline_char: db 10
codes: db '0123456789abcdef'

section .text

; 改行コードを出力する関数
print_newline:
    mov rax, 1      ; 'write' syscall
    mov rdi, 1
    mov rsi, newline_char
    mov rdx, 1
    syscall
    ret

; rdi の値を16進数で標準出力する
print_hex:
    mov rax, rdi
    mov rdi, 1
    mov rdx, 1
    mov rcx, 64
iterate:
    push rax                    ; rax 退避
    sub rcx, 4                  ; 60, 56, ... 4, 0
    sar rax, cl
    and rax, 0xf                ; 下位 4 ビットを残す
    lea rsi, [codes + rax]
    mov rax, 1
    push rcx                    ; rcx 退避
    syscall
    pop rcx                     ; rcx 復旧
    pop rax                     ; rax 復旧
    test rcx, rcx
    jnz iterate
    ret

section .data

demo1: dq 0x1122334455667788
demo2: db 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88

section .text

_start:
    ; big endian でメモリに格納されているものを出力
    mov rdi, [demo1]
    call print_hex
    call print_newline

    ; little endian でメモリに格納されているものを出力
    mov rdi, [demo2]
    call print_hex
    call print_newline

    mov rax, 60     ; 'exit' syscall
    xor rdi, rdi
    syscall
