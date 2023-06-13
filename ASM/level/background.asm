main:

LDA $18
AND #%00010000
BNE .changeBG

RTL


.changeBG

JSL $0C9567

RTL

PHB	   ;Mudando pro BG do castelo
REP #$30 	

LDA #$03FF ;Numero de X até A vão ser copiados
LDX #$F45A 
LDY #$B900 ;Valores de X até A serão colados em Y até A

MVN $0C7E  ;Bank de X e Y nessa ordem

SEP #$30 	
PLB 	