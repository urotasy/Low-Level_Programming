global _start

section .data
codes:
    db '0123456789ABCDEF'

section .text
_start:
    ; 16進数表記での値
    mov rax, 0x1122334455667788

    mov rdi, 1
    mov rdx, 1
    mov rcx, 64
    ; 4ビットを16進数の1桁として出力していくために、
    ; シフトと論理和によって1桁のデータを得る。
    ; その結果は 'codes' 配列へのオフセット。
.loop:
    push rax
    sub rcx, 4
    sar rax, cl     ; cl は rcx の最下位バイト
    and rax, 0xf

    ; lea : load effective address
    ; [] は indirect addressing
    lea rsi, [codes + rax]
    mov rax, 1

    ; syscall で rcx と r11 が変更される
    push rcx
    syscall
    pop rcx

    pop rax
    ; test は最速のゼロかどうか判定に使える
    test rcx, rcx
    jnz .loop

    mov rax, 60     ; exit
    xor rdi, rdi
    syscall
