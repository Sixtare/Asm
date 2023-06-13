main:

LDA $58
BNE .return

LDA $1DF5
BEQ .doit
RTL

.doit 
LDA #$E9
STA $0109

STZ $010A

STZ $1DF5

INC $58

LDA #$0F
STA $0100 

.return
RTL


