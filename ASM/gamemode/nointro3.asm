init:

LDA $58
CMP #$01
BEQ .title

STZ $0109

LDA #$0B
STA $0100


RTL


.title
LDA #$02
STA $1DFB

LDA #$00
STA $1DFB

LDA #$02
STA $0100

RTL


main:

RTL




