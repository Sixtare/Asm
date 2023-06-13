init:

REP #$20
LDA #$FCFC
STA $0EF9
STA $0EFB
sta $0EFD
SEP #$20

RTL

main:

LDA $E4     ;Posição do koopa despawnado
LSR A
LSR A
LSR A
LSR A
STA $0EF9
LDA $E4
AND #$0F
STA $0EFA

LDA $BE    ;Casco ativo enquanto spawna o yoshi/Pega 10 shell verde
LSR A
LSR A
LSR A
LSR A
STA $0EFC
LDA $BE
AND #$0F
STA $0EFD

RTL

nmi:

STZ $212C		;nothing on main screen
LDA.b #%00011111	;everything on sub screen
STA $212D
LDA.b #%00100000	;backdrop color math enable
STA $40
STA $2131
;LDA.b #%00100000	;enable color window 1
STA $43
STA $2125
STZ $2121
LDA #$5A : STA $2121	;window color low byte (SNES)
LDA #$03 : STA $2122	;window color high byte (SNES)
LDA.b #%01000010	;add in subscreen
STA $44			;also clip to black outside window
STA $2130		;(that just disables the color outside the window)
LDA #$00
STA $2126
LDA #$FF
STA $2127

RTL