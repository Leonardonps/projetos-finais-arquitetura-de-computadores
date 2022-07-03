.686
.model flat, stdcall
option casemap: none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib
include \masm32\macros\macros.asm

.code
start:

; int acumulador = 0;
; for(int i = 1; i <= 100; i++) acumulador = acumulador + 1;
; printf("O valor do somatorio eh %d\n", acumulador);

xor eax, eax; exa = 0
mov ecx, 1

corpo_for:
add eax, ecx
inc ecx
cmp ecx, 100
jbe corpo_for

printf("O valor do somatorio eh %d\n", eax)

invoke ExitProcess, 0
end start