main:

LDA $16
CMP #$30
BNE .return

JSL $7f8000

.return
RTL