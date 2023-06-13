main:

LDA $0F5F	;Flag pra usar o dash - Reseta ao encostar no chão
BEQ .mainCode

LDA $77
AND #%00000100
BNE .resetFlag
RTL

.resetFlag
STZ $0F5F

.mainCode

LDA $0F5E	;Timer do input
BEQ .checkInput

DEC $0F5E

.checkInput
LDA $16		;Se o corno apertar pra cima inicia a contagem
AND #%00001000
BNE .setTimer
RTL

.setTimer
LDA $0F5E 
BNE .doDash

LDA #$2F
STA $0F5E
RTL

.doDash
LDA #$A4
STA $7D		;Mario Y speed

REP #$20
LDA $96
SEC
SBC #$0040
STA $96

SEP #$20

INC $0F5F	;Seta flag pra impedir dashs infinitos no ar
STZ $0F5E	;Reseta o timer
RTL

