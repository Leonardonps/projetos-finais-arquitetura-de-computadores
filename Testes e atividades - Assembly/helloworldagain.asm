.686
.model flat, stdcall
option casemap: none
.xmm
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

.data
output db "Hello World!", 0ah, 0h
outputHandle dd 0; Variavel para armazenar o handle de saída
write_count dd 0; Variavel para armazenar caracteres escritos no console

.code
start:
push STD_OUTPUT_HANDLE
call GetStdHandle ;Call convention do tipo calle clean_up, nao precisa mover esp depois
mov outputHandle, eax
invoke WriteConsole, outputHandle, addr output, sizeof output, addr write_count, NULL
invoke ExitProcess, 0
end start