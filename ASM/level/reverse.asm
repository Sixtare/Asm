main:

LDA $15  
AND #$03 
CMP #$01
BEQ right
CMP #$02
BEQ left
RTL

right:
TRB $15
ASL
TSB $15
RTL

left:
TRB $15
LSR
TSB $15
RTL