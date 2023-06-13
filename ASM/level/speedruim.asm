main:

LDA $1493
BNE .checktimer
LDA $1434
BNE .checktimer
RTL

.checktimer
LDA $0F31
CMP #$02
BCS .kill
RTL

.kill
STZ $1493
STZ $1434
JSL $00F606

RTL

