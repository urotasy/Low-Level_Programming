#!/bin/sh

src=$1
base=$(basename $src)
name=${base%.*}
nasm -f elf64 -o ${name}.o ${src} && ld -o ${name} ${name}.o
nasm -g -f elf64 -o ${name}.do ${src} && ld -o ${name}_d ${name}.do
