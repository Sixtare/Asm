init:

STZ $E4
STZ $BE
STZ $19
STZ $0DC2

LDA #$01
STA $1F11

LDA #$50
STA $0DBE

RTL

main:

LDA $15
AND #%00100100
CMP #%00100100
BEQ .reset

LDA $1493
BNE .reset
LDA $71
CMP #$09
BEQ .reset
BNE .return

.reset

STZ $13CE

STZ $0DC1
STZ $187A
STZ $0DBA
STZ $18E2

STZ $1493
LDA #$03
STA $141D
LDA #%10000000
TRB $0DDA

LDA #$0F
STA $0100

PHB 		
REP #$30 	

LDA #$0180 ;Numero de X até A vão ser copiados
LDX #$FC00 
LDY #$19F8 ;Valores de X até serão colados

MVN $7F7E  ;Bank de X e Y nessa ordem

SEP #$30 	
PLB 		

LDA #$01
STA $1496
.return
RTL

nmi:		;AQUI O NMI SEU CEGO

STZ $1426

REP #$20
LDA #$00FF
SEC
SBC $7E
CLC
ADC $D1
STA $0F5E   ;Só usando pra checar no bizhawk
CMP #$0806
BCS .calc
JMP .return

.calc
LDA #$806
SEC
SBC $D1
CLC
ADC $7E
CLC
STA $0F60   ;Pos dentro da camera de #$07F9

REP #$20
LDA $0F5E
CMP #$0906
BCC .draw

SEP #$20
STZ $0F60

.draw

SEP #$20
LDA $0F60
BEQ .return

LDA $0F60
CMP #$06
BCC .disable
JMP .makeline

.disable

LDA #%00011111
STA $212C

LDA #%00000000	;everything on sub screen = Afetado pela window
STA $212D

LDA #$20
STA $40

STZ $41
STZ $42
STZ $43

LDA #$02
STA $44

JMP .return

.makeline
LDA.b #%00001000        ;---o4321 = Nao afetado pela window o = object
STA $212C		;nothing on main screen
LDA.b #%00010111	;everything on sub screen = Afetado pela window
STA $212D		;---o4321 
LDA.b #%00100011	;backdrop color math enable
STA $2131

STA $43
STA $2125

STZ $2121
LDA #$1F
STA $2122	;window color low byte (SNES)
LDA #$00
STA $2122	;window color high byte (SNES)

LDA.b #%01000010	;add in subscreen
STA $44			;also clip to black outside window
STA $2130		;(that just disables the color outside the window)

LDA $0F60
STA $2126
LDA $0F60
STA $2127

.return
RTL