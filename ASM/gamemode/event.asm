!events = #$02
!levels = #$01		;Translevel Number

event:
db $01,$03

level:
db $29

!eventIndex = $0F5E	;Dont't touch this
!eventBit = $0F68	;You dummy

init:

JSR Values

RTL

main:

LDX !events
DEX
BMI .end

LDA !eventIndex,X
TAX
LDA $1F02,X	
AND !eventBit,X		

BEQ .checkPos	

.end
RTL

RTL

.checkPos

LDA $13D9
CMP #$03
BEQ .eventTrigger

RTL

.eventTrigger

REP #$30
JSL owtile_tile
LDA $7ED000,X
SEP #$30

CMP level
BEQ .exec

RTL

.exec

LDX !events
DEX
	TXY	
	TAX		;Makes you able to walk in pathways
	LDA $1EA2,X	;	
	ORA #%00001111	;
	STA $1EA2,X	;

	LDA #$01
	STA $1DE9
	STA $13D9

	TYX
	LDA event,X	;Event to run
	STA $1DEA	

	DEC !events
	
RTL

Values:

LDX !events
--
DEX

LDA event,X
LSR
LSR
LSR
STA !eventIndex,X

LDA !eventIndex,X
ASL
ASL
ASL
STA !eventBit,X	
LDA event,X
SEC
SBC !eventBit,X
STA !eventBit,X

PHX

TXY
LDA #$80
LDX !eventBit,Y
DEX
-
	LSR A
	DEX
	BPL -	

STA !eventBit,Y
PLX
CPX #$00
BNE --

RTS

