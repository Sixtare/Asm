load:

LDA $141A
BNE .subLevel

LDA $0DA1	;Storage primeiro valor do submap
BNE .dontStore

LDA $1F11	;RESETAR ESSA PORRA NA ROM DE ALGUM JEITO
STA $0DA1	;Guarda o submap aqui

.dontStore
LDA $0DA1	;$1f11 sempre recebe o primeiro valor de submap
STA $1F11	;Pra nao bugar a saída com start+select

LDX $13BF   ;É usado como index pra achar o level no endereço 1EA2
LDA $1EA2,X
ORA #$80    ;Seta level como terminado (Pode sair com start+select)
STA $1EA2,X

LDA $010C   ;HighByteLevel
STA $0D9C   ;Flag OW load (Substitui $1F11 quando $0109 diferente de 0)

STZ $109    

STZ $18E2   ;\
STZ $0DC1   ; |Tirar o yoshi
STZ $187A   ; |
STZ $0DBA   ;/

STZ $19     ;Tira power ups

STZ $0DC2   ;Tira items da item box

INC $58     ;Setando flag de level kaizo que vai ser lida no patch do asar

RTL

.subLevel

LDA #$80    ;Reseta bit do pswitch quando entrar/sair de um sublevel
TRB $0DDA   ;Isso troca a música que esta tocando
RTL

init:

LDA #$80    ;Reseta bit do pswitch
TRB $0DDA   ;Isso desbuga a musica do pswitch

RTL

main:

LDA $71
CMP #$09
BEQ .reset
RTL

.reset
LDA $14AD   	;Timer blue switch
ORA $14AE   	;Timer silve switch
BEQ .noSwitch	;Se estiverem ativos reseta a musica

LDA #$80    ;Reseta bit do pswitch
TRB $0DDA   ;Isso troca musica pra nao bugar musica do pswitch

.noSwitch 
LDA $141A 
BEQ .noSublevel

LDA #$80    ;Reseta musica ao morrer em sublevel
TRB $0DDA  

.noSublevel
STZ $141A   ;Reseta sublevel count pra nao spawnar no bonus game
STZ $141D   ;Desativa intro do level 
STZ $58     ;Reseta flag loop da música pra essa merda nao chegar em FF>00

LDA $13CE
BEQ .noMidway

LDX $13BF   ;É usado como index pra achar o level no endereço 1EA2
LDA $1EA2,X
ORA #$40    ;Seta o midway caso flag de midway no level esteja ativa
STA $1EA2,X

.noMidway
LDA #$01
STA $141D	;Desativa mario start intro

LDA $13BF	;Index do level
STA $0109	;Sobrepor valor load level routine

LDA #$0B	
STA $0100

RTL

