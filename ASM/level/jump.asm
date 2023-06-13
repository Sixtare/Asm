main:

LDA $77
AND #%00000100	;In the air flag
BEQ .code
RTL

.code
LDA $140D	;SpingJump Flag	
BEQ .checkspin
BNE .checknormal

.checkspin
LDA $18
AND #%10000000  ;Checando se A foi apertado
BEQ .return

LDA #$01
STA $140D
RTL

.checknormal
LDA $16
AND #%10000000  ;Checando se B foi apertado
BEQ .return

STZ $140D
RTL

.return
RTL

