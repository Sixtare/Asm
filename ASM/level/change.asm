main:

LDA $15
AND #%00001000
BNE .changeBlock

RTL

.changeBlock
REP #$20
LDA #$0010
STA $7F837B
SEP #$20

LDA $7F837D
AND #$00
STA $7F837D
LDA $7F837D
ORA #%00100000	;Set to layer 1
ORA #%00001001	;Set positions
STA $7F837D

LDA $7F837E
AND #$00
STA $7F837E
LDA $7F837E
ORA #%01000010
STA $7F837E

LDA $7F8380
AND #$00
STA $7F8380
LDA $7F8380
ORA #%00000011	;Bytes
STA $7F8380

LDX #$00
LDA #$58	;Bloco

-
	STA $7F8381,X
	INX
	PHA
	LDA #$18	;Paleta
	STA $7F8381,X 
	PLA
	INX
	CPX #$04
	BEQ .secondRow	
	INC A
	JMP -

.secondRow

PHA

LDA $7F837D
STA $7F8381,X
INX
LDA $7F837E
CLC
ADC #$20
STA $7F8381,X
INX 
LDA $7F837F
STA $7F8381,X
INX 
LDA $7F8380
STA $7F8381,X
INX

PLA 
INC A
--
	STA $7F8381,X
	INX
	PHA
	LDA #$18	;Paleta
	STA $7F8381,X 
	PLA
	INX
	CPX #$0C
	BEQ .end	
	INC A
	JMP --
.end
LDA #$FF
STA $7F8381,X

RTL

