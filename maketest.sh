#!/bin/sh

# Run script with your assembly file as only argument and it will create a
# memory.hex

riscv64-unknown-elf-as --march=rv32i --mabi=ilp32 $1
riscv64-unknown-elf-objcopy -O binary a.out a.bin
srec_cat a.bin -binary -byte-swap 4 -o memory.hex -vmem 32

