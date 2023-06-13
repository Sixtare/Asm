!blockLow = #$21
!blockHigh = #$00
!freespace = $7FA100

main:

LDA $18
BNE .scanBlock

RTL

.scanBlock

REP #$20

LDX $95
LDA #$FFFF
-
	CLC
	ADC #$01B0
	DEX
	BPL -

REP #$10
TAX
SEP #$20
LDY #$01AF

--
	LDA $7EC800,X
	CMP !blockLow
	BEQ .calcPos
	DEX
	DEY
	CPY #$FFFF
	BNE --

SEP #$10

RTL
	
.calcPos

REP #$20

TYX
LDA #$0000
-
	CLC
	ADC #$0010
	DEX #16
	CPX #$0010
	BCS -

;SEC
;SBC #$0010
STA $0F5E	;Y pos bloco
SEP #$30
LDA #$00
--
	CLC
	ADC #$10
	DEX 
	BNE --		

STA $0F60
LDA $95
STA $0F61

JSR UPDATE

RTL


UPDATE:

LDX #$00

REP #$20
LDA #$0010
STA !freespace,x
SEP #$20

INX
INX

LDA $0F5E
AND #%11000000		;Getting 2 first y low bits
CLC
ROL A
ROL A
ROL A			
ORA #%00100000		;Set to layer 1
STA !freespace,X	;Store
LDA $0F5F
ASL A
ASL A
ASL A
ORA !freespace,X	;Getting y high byte
STA !freespace,X	;Store

INX

LDA $0F5E
AND #%00111000
ASL A
ASL A
STA !freespace,X 
LDA $0F60
AND #%00011111
ORA !freespace,X
STA !freespace,X
;LDA $7F837E
;AND #$00
;STA $7F837E
;LDA $7F837E
;ORA #%01000010
;STA $7F837E

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

RTS
	