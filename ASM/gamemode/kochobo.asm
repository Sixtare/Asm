load:

STZ $18E2   ;\
STZ $0DC1   ; |Tirar o yoshi
STZ $187A   ; |
STZ $0DBA   ;/

STZ $1496   ;Reseta animation timer

STZ $19     ;Tira power ups

STZ $0DC2   ;Tira items da item box

INC $58     ;Setando flag de level kaizo
RTL

main:

LDA $71
CMP #$09
BEQ .reset
RTL

.reset
STZ $141A   ;Reseta sublevel count pra nao spawnar no bonus game
STZ $141D   ;Desativa intro do level 
STZ $58     ;Reseta flag loop da m�sica pra essa merda nao chegar em FF>00

LDA $13CE
BEQ .noMidway

LDX $13BF   ;� usado como index pra achar o level no endere�o 1EA2
LDA $1EA2,X
ORA #$40    ;Seta o midway caso flag de midway no level esteja ativa
STA $1EA2,X

.noMidway
LDA #$01
STA $141D

LDA #$0F   
STA $0100

PHB 	   ;Reseta o item memory (Seta tudo pra 0)	
REP #$30 	

LDA #$0180 ;Numero de X at� A v�o ser copiados
LDX #$FC00 
LDY #$19F8 ;Valores de X at� ser�o colados

MVN $7F7E  ;Bank de X e Y nessa ordem

SEP #$30 	
PLB 		

RTL