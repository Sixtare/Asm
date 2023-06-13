!buttons = $0F5E

SEQUENCE:
db $08,$08,$04,$04,$02,$01,$02,$01,$80,$80

init:

LDX #$09 	;Numero de inputs em sequencia (10)

-	LDA SEQUENCE,X
	STA !buttons,X
	DEX
	BPL -

RTL

main:

LDX $58
CPX #$09
BNE .normalInput

LDA $18
BNE .checkInput	;Checa o ultimo input

LDA $16
BEQ .noInput

STZ $58

.noInput
RTL

.normalInput
LDA $16 
BNE .checkInput

LDA $18
BEQ .noInput1

STZ $58

.noInput1
RTL

.checkInput
CMP SEQUENCE,X
BEQ .startCode

STZ $58		;Se input errado reseta
RTL

.startCode
INC $58
LDA $58
CMP #$0A
BEQ .loadSave

RTL

.loadSave

PHB	  
REP #$30 	

LDA #$008E	;Numero de bytes em hex
LDX #$011E	;Começo do save 1
LDY #$0000	;Começo do save 3

MVN $7070  	;Bank de X e Y nessa ordem

SEP #$30 	
PLB 	

REP #$10
	LDX #$01AC		;Maybe usar
	LDY #$008E
	LDA #$00
-	STA $700000,x
	STA $7001AD,x
	DEX
	DEY
	BPL -
SEP #$10

;Reset snes

	STZ $4200	;no interrupts from here on out
	SEI
	SEP #$30	;request upload
	LDA #$FF
	STA $2141
	LDA #$00	;DB must be zero, this is done by the h/w normally
	PHA
	PLB

	STZ $420C	;disable any HDMA, this is done by the h/w normally
	JML $008016

RTL

SAVELOW:
db $8E,$1D,$AC


SAVEHIGH:
db $00,$01,$01