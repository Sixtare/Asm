main:

LDA $77		;$77 usa $96 pra checar se encostou no chao, ou seja
AND #%00000100  ;É setado um frame antes de encostar no chão
BEQ .mainCode
STZ $58
STZ $13F9
RTL

.mainCode
LDA $15
AND #%00000100
BNE .checkSpin
RTL

.checkSpin
LDA $17
AND #%10000000
BNE .doStomp 
RTL

.doStomp
LDA $58
BEQ +
BNE ++


+	INC $58
++	LDA #$7F
	STA $7D		;Player Y speed
	STZ $7B		;Player X speed
	LDA #$02
	STA $13F9	;Player layer interaction
	LDA #$03
	STA $1497	;Invunerability timer	
	
RTL