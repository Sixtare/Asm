
main:

LDA $71
CMP #$09
BEQ .timer
RTL

.timer	    ;Arrumar o reset sempre que entrar em um submap
LDA $1496
CMP #$01
BEQ .reset
RTL

.reset

LDA $13CE
BEQ .noMidway

LDX $13BF   ;É usado como index pra achar o level no endereço 1EA2
LDA $1EA2,X
ORA #$40
STA $1EA2,X

.noMidway
LDA #$01
STA $141D
LDA #%10000000
TRB $0DDA
LDA #$0F
STA $0100

PHB 		
REP #$30 	

LDA #$0180 ;Numero de X até A vão ser copiados
LDX #$FC00 
LDY #$19F8 ;Valores de X até serão colados

MVN $7F7E  ;Bank de X e Y nessa ordem

SEP #$30 	
PLB 		



RTL