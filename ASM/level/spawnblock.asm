main:

LDA $18
AND #%00010000	;Se apertou R
BNE .findSlot

RTL

.findSlot

JSL $02A9E4	;Empty sprite slot on A
BPL .spawnShell

RTL

.spawnShell

TAX		;Empty sprite slot goes to X

LDA #$09	;Sprite state
STA $14C8,X

LDA #$53	;Sprite number
STA $9E,X

JSL $07F7D2	;Loads sprite settings

REP #$20

LDA $94		;Player pos
LDY $76
BEQ .facingLeft

CLC
ADC #$0008
JMP .storeLow

.facingLeft
SEC
SBC #$0008

.storeLow
PHA
SEP #$20
STA $E4,X	;Sprite Xpos low byte

REP #$20
PLA
XBA
SEP #$20

STA $14E0,X	;Sprite Xpos high byte

REP #$20
LDA $96		;Player Ypos low byte
CLC
ADC #$0010
PHA
SEP #$20

STA $D8,X	;Sprite Ypos low byte

REP #$20
PLA 
XBA
SEP #$20

STA $14D4,X	;Sprite Ypos high byte

RTL

