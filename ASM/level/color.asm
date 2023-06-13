main:

LDA $0F5E
CMP #$FF
BEQ .high
INC $0F5E

RTL

.high
STZ $0F5E
LDA $0F5F
CLC
ADC #$1F
STA $0F5F
JMP nmi
RTL

nmi:

LDA.b #%00011101        ;---o4321
STA $212C		;nothing on main screen
LDA.b #%00000010	;everything on sub screen
STA $212D		;---o4321 
LDA.b #%00100000	;backdrop color math enable
STA $40
STA $2131

;LDA.b #%00100000	;enable color window 1
STA $43
STA $2125

STZ $2121
LDA $0F5E  ;LDA #$BD
STA $2122	;window color low byte (SNES)
LDA $0F5F  ;LDA #$08
STA $2122	;window color high byte (SNES)

LDA.b #%01000010	;add in subscreen
STA $44			;also clip to black outside window
STA $2130		;(that just disables the color outside the window)

RTL