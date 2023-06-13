main:

LDA $18
CMP #$30
BEQ pressed
BNE unpressed

unpressed:
RTL

pressed:
REP #$30
LDX $0F5E
LDA $7EC800,X
SEP #$30
STA $58
CMP #$21
BEQ hidden

REP #$20
INC $0F5E
LDA $0F5E
CMP #$1B0
BCS clear

BRA pressed

clear:
STZ $0F5E
SEP #$30
LDA #$2A
STA $1DFC ;Som de errado

RTL

hidden:
STZ $0F5E
SEP #$30
LDA #$29
STA $1DFC ;Som de certo

RTL

;$7EC800   Começo tiles low bite 1AF de distancia entre top left e bottom right
;$1A	Layer1 X position 2byte

RTL