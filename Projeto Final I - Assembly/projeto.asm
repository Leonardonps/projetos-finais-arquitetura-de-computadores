;UFPB - CENTRO DE INFORMÁTICA
;CIÊNCIA DA COMPUTAÇÃO - ARQUITETURA DE COMPUTADORES I
;ALUNO: LEONARDO DO NASCIMENTO PEIXOTO DA SILVA MATRÍCULA: 20200005766
;PROJETO 1: PROGRAMA EM ASSEMBLY PARA CALCULAR E EXIBIR MÉDIAS DE ALUNOS (40)

.686
.model flat, stdcall
option casemap:none
.xmm
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\masm32.lib

.data
; Preparações genéricas
outputHandle dd 0 ;Variavel para armazenar o handle de saida
inputHandle dd 0 
outputLinhaTraco db "---------------------------------------------", 0ah, 0h
pula_linha db "  ", 0ah, 0h

; Preparação para exibir Menu
outputInicioMenu db "--------- Programa - Exibindo notas ---------", 0ah, 0h
linha1 db "1. Incluir notas de aluno (max. 40 alunos)", 0ah, 0h
linha2 db "2. Exibir medias da turma", 0ah, 0h
linha3 db "3. Sair do programa", 0ah, 0h

; Preparação para pegar a opção do usuário via string
write_count dd 0 ;Variavel para armazenar caracteres escritos na console
inputString db 50 dup(0)
console_count dd 0
tamanho_string dd 0

; Preparação para o que deve ser exibido na opção 1
opcao1_nome db "Digite o nome do aluno: ", 0ah, 0h
opcao1_nota1 db "Digite a nota 1 do aluno: ", 0ah, 0h
opcao1_nota2 db "Agora a nota 2 do aluno: ", 0ah, 0h
opcao1_nota3 db "Por ultimo, a nota 3 do aluno: ", 0ah, 0h

; Preparação para o que deve ser exibido na opção 2
opcao2_linha1 db "Nome do aluno: ", 0ah, 0h
opcao2_linha2 db "Nota 1: ", 0ah, 0h
opcao2_linha3 db "Nota 2: ", 0ah, 0h
opcao2_linha4 db "Nota 3: ", 0ah, 0h
opcao2_linha5 db "A media do aluno foi: ", 0ah, 0h

; Preparação para dados dos alunos
nomes_alunos db 15 dup(0) 
notas_1 real4 40 dup(0.0)
notas_2 real4 40 dup(0.0)
notas_3 real4 40 dup(0.0)
medias real4 40 dup(0.0)
constante_3 real4 4 dup(3.0)
nota_temp real8 0.0
num_em_string db 20 dup(0)
tamanho dd 0

.code
start:

push STD_OUTPUT_HANDLE

call GetStdHandle ;Call convention do tipo calle clean-up, nao precisa mover esp depois
mov outputHandle, eax

; Exibindo Menu
invoke WriteConsole, outputHandle, addr outputInicioMenu, sizeof outputInicioMenu-1, addr write_count, NULL
invoke WriteConsole, outputHandle, addr linha1, sizeof linha1-1, addr write_count, NULL
invoke WriteConsole, outputHandle, addr linha2, sizeof linha2-1, addr write_count, NULL
invoke WriteConsole, outputHandle, addr linha3, sizeof linha3-1, addr write_count, NULL
invoke WriteConsole, outputHandle, addr outputLinhaTraco, sizeof outputLinhaTraco-1, addr write_count, NULL

; Preparando para pegar a escolha do usuario
invoke GetStdHandle, STD_INPUT_HANDLE
mov inputHandle, eax

; Pegando a escolha do usuário
invoke ReadConsole, inputHandle, addr inputString, sizeof inputString, addr console_count, NULL
;invoke StrLen, addr inputString
;mov tamanho_string, eax
;invoke WriteConsole, outputHandle, addr inputString, tamanho_string, addr console_count, NULL

; Linhas de código para ajeitar o atodw
mov esi, offset inputString; Armazenar apontador da string em esi
proximo:
mov al, [esi] ; Mover caracter atual para al
inc esi ; Apontar para o proximo caracter
cmp al, 48 ; Verificar se menor que ASCII 48 - FINALIZAR
jl terminar
cmp al, 58 ; Verificar se menor que ASCII 58 - CONTINUAR
jl proximo
terminar:
dec esi ; Apontar para caracter anterior
xor al, al ; 0 ou NULL
mov [esi], al ; Inserir NULL logo apos o termino do numero

; Atodw para transformar meu inputString em número
invoke atodw, addr inputString

; Opções escolhidas pelo usuário
cmp eax, 1
je opcao1
cmp eax, 2
je opcao2
cmp eax, 3
je opcao3

; Jump para o usuario digitar qualquer coisa além de 1, 2 ou 3
jmp start

; Opção 1 - Coletar as notas do aluno (máximo de alunos: 40)
opcao1:

invoke WriteConsole, outputHandle, addr outputLinhaTraco, sizeof outputLinhaTraco-1, addr write_count, NULL

; NOME DO ALUNO
invoke WriteConsole, outputHandle, addr opcao1_nome, sizeof opcao1_nome-1, addr write_count, NULL
invoke ReadConsole, inputHandle, addr nomes_alunos, sizeof nomes_alunos, addr console_count, NULL

;invoke WriteConsole, outputHandle, addr nomes_alunos, sizeof nomes_alunos, addr write_count, NULL

; PRIMEIRA NOTA
invoke WriteConsole, outputHandle, addr opcao1_nota1, sizeof opcao1_nota1-1, addr write_count, NULL
invoke ReadConsole, inputHandle, addr num_em_string, sizeof num_em_string, addr console_count, NULL

invoke StrToFloat, offset num_em_string, offset nota_temp
fld REAL8 PTR[nota_temp]
fstp REAL4 PTR[notas_1+0]

;fld REAL4 PTR[notas_1+0]
;fstp REAL8 PTR[nota_temp]
;invoke FloatToStr, REAL8 PTR [nota_temp], offset num_em_string
;invoke StrLen, offset num_em_string
;mov tamanho, eax
;invoke WriteConsole, outputHandle, addr num_em_string, tamanho, addr write_count, NULL
; FIM - PRIMEIRA NOTA

; SEGUNDA NOTA
invoke WriteConsole, outputHandle, addr opcao1_nota2, sizeof opcao1_nota2-1, addr write_count, NULL
invoke ReadConsole, inputHandle, addr num_em_string, sizeof num_em_string, addr console_count, NULL

invoke StrToFloat, offset num_em_string, offset nota_temp
fld REAL8 PTR[nota_temp]
fstp REAL4 PTR[notas_2+0]
; FIM SEGUNDA NOTA

; TERCEIRA NOTA
invoke WriteConsole, outputHandle, addr opcao1_nota3, sizeof opcao1_nota3-1, addr write_count, NULL
invoke ReadConsole, inputHandle, addr num_em_string, sizeof num_em_string, addr console_count, NULL

invoke StrToFloat, offset num_em_string, offset nota_temp
fld REAL8 PTR[nota_temp]
fstp REAL4 PTR[notas_3+0]
; FIM TERCEIRA NOTA

invoke WriteConsole, outputHandle, addr outputLinhaTraco, sizeof outputLinhaTraco-1, addr write_count, NULL
jmp start ; Acabou o que fazer na opção 1, agora volta para o inicio
; FIM OPÇÃO 1


; Opção 2 - Exibir o nome, as notas e média do aluno (máximo de alunos: 40)
opcao2:
invoke WriteConsole, outputHandle, addr outputLinhaTraco, sizeof outputLinhaTraco-1, addr write_count, NULL

; Informando nome do aluno 
invoke WriteConsole, outputHandle, addr opcao2_linha1, sizeof opcao2_linha1-1, addr write_count, NULL
invoke WriteConsole, outputHandle, addr nomes_alunos, sizeof nomes_alunos, addr write_count, NULL
invoke WriteConsole, outputHandle, addr pula_linha, sizeof pula_linha-1, addr write_count, NULL 

; Exibindo Nota 1
invoke WriteConsole, outputHandle, addr opcao2_linha2, sizeof opcao2_linha2-1, addr write_count, NULL
fld REAL4 PTR[notas_1+0]
fstp REAL8 PTR[nota_temp]
invoke FloatToStr, REAL8 PTR [nota_temp], offset num_em_string
invoke StrLen, offset num_em_string
mov tamanho, eax
invoke WriteConsole, outputHandle, addr num_em_string, tamanho, addr write_count, NULL
invoke WriteConsole, outputHandle, addr pula_linha, sizeof pula_linha-1, addr write_count, NULL 

; Exibindo Nota 2
invoke WriteConsole, outputHandle, addr opcao2_linha3, sizeof opcao2_linha3-1, addr write_count, NULL
fld REAL4 PTR[notas_2+0]
fstp REAL8 PTR[nota_temp]
invoke FloatToStr, REAL8 PTR [nota_temp], offset num_em_string
invoke StrLen, offset num_em_string
mov tamanho, eax
invoke WriteConsole, outputHandle, addr num_em_string, tamanho, addr write_count, NULL
invoke WriteConsole, outputHandle, addr pula_linha, sizeof pula_linha-1, addr write_count, NULL 

; Exibindo Nota 3
invoke WriteConsole, outputHandle, addr opcao2_linha4, sizeof opcao2_linha4-1, addr write_count, NULL
fld REAL4 PTR[notas_3+0]
fstp REAL8 PTR[nota_temp]
invoke FloatToStr, REAL8 PTR [nota_temp], offset num_em_string
invoke StrLen, offset num_em_string
mov tamanho, eax
invoke WriteConsole, outputHandle, addr num_em_string, tamanho, addr write_count, NULL
invoke WriteConsole, outputHandle, addr pula_linha, sizeof pula_linha-1, addr write_count, NULL 
invoke WriteConsole, outputHandle, addr pula_linha, sizeof pula_linha-1, addr write_count, NULL 

; Informando média
invoke WriteConsole, outputHandle, addr opcao2_linha5, sizeof opcao2_linha5-1, addr write_count, NULL

; Calculo da média
movups xmm0, OWORD PTR[notas_1]
movups xmm1, OWORD PTR[notas_2]
addps xmm0,xmm1
movups xmm1, OWORD PTR[notas_3]
addps xmm0, xmm1
movups xmm1, OWORD PTR[constante_3]
divps xmm0, xmm1
movups OWORD PTR[medias], xmm0

; Conversao para exibição da média I
fld REAL4 PTR[medias+0]
fstp REAL8 PTR[nota_temp]

; Conversao para exibição da média II
invoke FloatToStr, REAL8 PTR [nota_temp], offset num_em_string
invoke StrLen, offset num_em_string
mov tamanho, eax

; Exibindo a média
invoke WriteConsole, outputHandle, addr num_em_string, tamanho, addr write_count, NULL

invoke WriteConsole, outputHandle, addr pula_linha, sizeof pula_linha-1, addr write_count, NULL 
invoke WriteConsole, outputHandle, addr outputLinhaTraco, sizeof outputLinhaTraco-1, addr write_count, NULL

jmp start

opcao3:
invoke ExitProcess, 0

end start
