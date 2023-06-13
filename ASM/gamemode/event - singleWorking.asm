!event = #$01
!level = #$29		;Translevel Number

!eventIndex = $0F5E	;Dont't touch this
!eventBit = $0F68	;You dummy

init:

JSR Values

RTL

main:

LDX !eventIndex 
LDA $1F02,X	;LDA $1F02,X
AND !eventBit	;TSB !eventBit	
BEQ .checkPos	

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
CMP !level
BEQ .exec

RTL

.exec

TAX		;Makes you able to walk in pathways
LDA $1EA2,X	;	
ORA #%00001111	;
STA $1EA2,X	;

LDA #$01
STA $1DE9
STA $13D9

LDA !event	;Event to run
STA $1DEA	


RTL

Values:

LDA !event
LSR
LSR
LSR
STA !eventIndex 

LDA !eventIndex
ASL
ASL
ASL
STA !eventBit	
LDA !event
SEC
SBC !eventBit
STA !eventBit


LDA #$80
LDX !eventBit
DEX
-
	LSR A
	DEX
	BPL -	

STA !eventBit

RTS

