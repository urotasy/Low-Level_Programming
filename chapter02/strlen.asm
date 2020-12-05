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

test_string: db "abcdef", 0

section .text

; rdi から引数を受取り、rax に文字列の長さを入れる関数
strlen:
    xor rax, rax    ; rax を 0 初期化
.loop:
    cmp byte [rdi + rax], 0 ; 現在の文字がヌル文字か確認する
    je .end                 ; ヌル文字であれば終わり
    inc rax                 ; ヌル文字でなければ文字数カウント
    jmp .loop               ; 次の文字で同じ動作
.end:
    ret     ; rax にカウントされた文字数が入っている

_start:
    mov rdi, test_string
    call strlen
    mov rdi, rax
    call print_hex
    call print_newline

    ; 'exit' syscall
    mov rax, 60
    xor rdi, rdi
    syscall
