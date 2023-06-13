main:

LDA $72
BNE .check
STZ $58
RTL

.check
LDA $16
AND #%10000000
BNE .jump
RTL

.jump
LDA $58
BNE .return

LDA #$B3
STA $7D
INC $58
.return
RTL
