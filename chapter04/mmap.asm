; ファイルをメモリに読み込んで出力する

global _start

%define O_RDONLY 0
%define PROT_READ 0x1
%define MAP_PRIVATE 0x2

section .data

fname: db 'test.txt', 0 ; 読み込みファイル名

section .text

; rdi のアドレスに格納されたヌル文字終端された文字列を標準出力する
print_string:
    push rdi
    call string_length
    pop rsi
    mov rdx, rax
    mov rax, 1          ; 'write' syscall
    mov rdi, 1          ; 出力先は標準出力
    syscall
    ret
string_length:
    xor rax, rax
.loop:
    cmp byte [rdi + rax], 0
    je .end
    inc rax
    jmp .loop
.end:
    ret

; エントリポイント
_start:
    mov rax, 2          ; 'open' syscall
    mov rdi, fname
    mov rsi, O_RDONLY
    mov rdx, 0
    syscall

    mov r8, rax             ; open したファイルのディスクリプタを r8 に
    mov rax, 9              ; 'mmap' syscall
    mov rdi, 0              ; map 先は OS が選ぶ
    mov rsi, 4096           ; ページサイズ
    mov rdx, PROT_READ      ; 新しいメモリ領域は read only
    mov r10, MAP_PRIVATE    ; ページ共有なし
    mov r9, 0               ; 読み込むファイル内のオフセット
    syscall                 ; rax にマップ先のアドレスが入る

    mov rdi, rax
    call print_string

    mov rax, 60     ; 'exit' syscall
    xor rdi, rdi
    syscall

