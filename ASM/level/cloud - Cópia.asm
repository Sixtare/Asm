main:

LDA $0DC2
CMP #$14
BEQ .end

LDA $A7 	;Sprite number slot 9
CMP #$91	;Vendo se é um chuck
BEQ .checkTongue
RTL

.checkTongue
LDA $15D9
BNE .checkValues
RTL

.reset
LDA #$01
STA $141D
LDA #%10000000
TRB $0DDA
LDA #$0F
STA $0100

JSL $07F7D2

PHB 		
REP #$30 	

LDA #$0180 ;Numero de X até A vão ser copiados
LDX #$FC00 
LDY #$19F8 ;Valores de X até serão colados

MVN $7F7E  ;Bank de X e Y nessa ordem

SEP #$30 	
PLB 		

RTL

.checkValues
LDA $E4
CMP #$B5
BEQ +
BNE .reset

+

LDA $BE
CMP #$10
BEQ ++
BNE .reset

++

LDA $17
AND #%01110000
CMP #%01110000
BNE .reset

LDA $0DC2
CMP #$14
BEQ .end

.end

LDA #$02
STA $1DFB
RTL

nmi:

REP #$20
LDA #$00FF
SEC
SBC $7E
CLC
ADC $D1
STA $0F5E   ;Só usando pra checar no bizhawk
CMP #$0806
BCS .calc

SEP #$20
JMP .checkreset

.calc
LDA #$806
SEC
SBC $D1
CLC
ADC $7E
CLC
STA $0F60   ;Pos dentro da camera de #$07F9

.checkreset
SEP #$20

LDA $16
CMP #%00100100 ;Baixo e select reseta
BNE .bridge
LDA #$01
STA $141D
LDA #$0F
STA $0100

.bridge           ;FINAL DO MAIN

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
LDA #$FF
STA $0D9F
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