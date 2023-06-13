main:

LDA $17
AND #%00110000
CMP #%00110000
BEQ .deleteSave

RTL

.deleteSave

PHB	  
REP #$30 	

LDA #$008E	;Numero de bytes em hex
LDX #$0000	;Começo do save 1
LDY #$011E	;Começo do save 3

MVN $7070  	;Bank de X e Y nessa ordem

SEP #$30 	
PLB 	

REP #$20
LDA #$0000
SEP #$20
	LDX $010A
	LDA SAVEHIGH,X
	XBA
	ORA SAVELOW,X
REP #$30
	TAX
	LDX #$008E		;Maybe usar
SEP #$20
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