!setbit = $58
!spriteindex = $5C

main:

LDA $9D
BEQ .runCode
RTL

.runCode
LDA $18
AND #%00100000
BNE .setBit

LDA !setbit
BNE .mindControl

RTL

.leaveSprite

EOR #$01
STA !setbit

LDA $71
EOR #$0B
STA $71		;Freeze player

LDX !spriteindex
LDA #$04
STA $14C8,X

LDA #$A4
STA $7D

JSL smoke_run
JSL stars_run


RTL


.setBit

LDA !setbit
BNE .leaveSprite
EOR #$01
STA !setbit

LDA $71
EOR #$0B
STA $71		;Freeze player

.searchSprite

LDX #$09

-
	LDA $14C8,X
	BNE .storeIndex
	DEX
	BPL -

RTL

.storeIndex

STX !spriteindex

.mindControl
LDX !spriteindex

LDA #$FF
STA $78

LDA $E4,X
STA $94

LDA $D8,X
SEC
SBC #$10
STA $96

LDA $14E0,X
STA $95

LDA $14D4,X
STA $97

LDA $16
AND #%00000011
BEQ .skipDir

DEC A
STA $157C,X	;Set direction through controller

.skipDir


RTL





