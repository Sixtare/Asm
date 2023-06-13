!blockLow = #$21	;Blocos que serão substituidos
!blockHigh = #$00
!changeBlockLow = #$32	;Blocos pelos quais vai ser substituido
!changeBlockHigh = #$01
!freespace = $7FA100

main:

LDA $17
AND #%00110000		;Se tiver pressionando L+R
CMP #%00110000
BEQ .scanBlock

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
	BEQ .checkHigh
	DEX
	DEY
	CPY #$FFFF
	BNE --

SEP #$10

RTL
	
.checkHigh

LDA $7FC800,X
CMP !blockHigh
BEQ .calcPos

RTL

.calcPos

LDA !changeBlockLow	;Transforma em bloco
STA $7EC800,X		;Low Byte
LDA !changeBlockHigh
STA $7FC800,X		;High Byte

REP #$20

TYX
LDA #$0000
-
	CLC
	ADC #$0010
	DEX #16
	CPX #$0010
	BCS -

STA $0F5E	;Y pos bloco 2Bytes $0F5E-0F5F
SEP #$30
LDA #$00
--
	CLC
	ADC #$10
	DEX 
	BNE --		

STA $0F60	;X pos bloco low byte
LDA $95
STA $0F61	;X pos bloco high byte

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
LDA $0F61		;Get X bit from EHHHY-X-yy
AND #$01		;If X block position...
ASL A			;high byte is a odd number set bit
ASL A
ORA !freespace,X
STA !freespace,X	;EHHHYXyy

INX

LDA $0F5E
AND #%00111000
ASL A
ASL A
STA !freespace,X 
LDA $0F60
AND #%11111000
LSR A
LSR A
LSR A
ORA !freespace,X
STA !freespace,X	;yyyxxxxx

INX

LDA #$00
STA !freespace,X	;DRLLLLLL

INX

LDA #%00000011		;Bytes llllllll
STA !freespace,X

LDA #$58		;Aparencia Bloco

INX
-
	STA !freespace,X
	INX
	PHA
	LDA #$18		;Paleta
	STA !freespace,X 
	PLA
	INX
	CPX #$0A
	BEQ .secondRow	
	INC A
	JMP -

.secondRow

PHA
PHX
LDX #$02

LDA !freespace,X
PLX
STA !freespace,X
INX

PHX
LDX #$03

LDA !freespace,X
CLC
ADC #$20
PLX
STA !freespace,X
INX 

LDA #$00
STA !freespace,X
INX 

PHX
LDX #$05

LDA !freespace,X 
PLX
STA !freespace,X
INX

PLA 
INC A
--
	STA !freespace,X
	INX
	PHA
	LDA #$18		;Paleta
	STA !freespace,X 
	PLA
	INX
	CPX #$12
	BEQ .end	
	INC A
	JMP --
.end

LDA #$FF
STA !freespace,X


PHB	  
REP #$30 	

LDA #$0012 	;Numero de bytes em hex
LDX #!freespace	;Inicio de source dos bytes
LDY #$837B	;Valores de X serão colados aqui

MVN $7F7F  	;Bank de X e Y nessa ordem

SEP #$30 	
PLB 	

RTS
	