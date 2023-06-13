;n0ice translucent color window
;wiiqwertyuiop made one but lost the code so i had to make my own code, rrrrr
;some of the code is still his, specifically the hdma
;the window affects everything, including sprites (all palettes) :D
;sprite priorities may be messed up though, lol
;use in levelasm or whatever
;by ladida
;a

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
LDA #$BD : STA $2122	;window color low byte (SNES)
LDA #$08 : STA $2122	;window color high byte (SNES)

LDA.b #%01000010	;add in subscreen
STA $44			;also clip to black outside window
STA $2130		;(that just disables the color outside the window)

REP #$10
LDX #$2601		;two regs write once, regs [21]26 and [21]27
STX $4350
LDX.w #.DATA
STX $4352
LDA.b #.DATA>>16
STA $4354
SEP #$10

LDA #$20		;channel 5
TSB $0D9F
RTS

.DATA
db $80 : db $01 : db $00	;scanline : left window : right window
db $50 : db $50 : db $A0	
db $01 : db $01 : db $00	;if left window > right window, terminate window
db $00