main:

LDA $58
BNE .set

LDA $16
CMP #%00100000
BNE .return
LDA #$01
STA $58

.set
LDA #$FF
STA $9D
STA $18DE
STZ $13FB 
LDA #$01
STA $187A


.return
RTL



