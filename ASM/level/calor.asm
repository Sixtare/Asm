main:

LDA $75 ; in water flag if != 0
BNE resetheat
LDA $13D4 ; pause flag
BEQ increase
RTL

increase:
INC $58 ;empty 1byte	
LDA $58
CMP #$FF
BEQ death
RTL 

resetheat:

LDA #$00
STA $58
RTL

death:
JSL $00F606
RTL