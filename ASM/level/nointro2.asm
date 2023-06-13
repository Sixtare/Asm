load:

LDA #$04
STA $0DBE

RTL

init:

LDA #$F0
STA $0DB0

STZ $0DAF

LDA #$B0
STA $1DF5
RTL

main:

RTL
