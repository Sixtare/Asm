main:

LDA $18
AND #%00110000
BNE .answer

RTL


.answer

LDA $1426
EOR #$01
STA $1426

RTL
