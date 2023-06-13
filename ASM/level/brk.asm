main:


RTL

nmi:

LDA $0DC2
BNE .wait

RTL

.wait

SEI
LDA #$0F
STA $0100

RTL

