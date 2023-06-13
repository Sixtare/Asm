init:
	REP #$20
	STZ $0F3A
	STZ $0F3C
	STZ $0F3E
	STZ $0F42
	STZ $0F44
	STZ $0F46
	SEP #$20
	RTL
	
main:
	;LDA $17
	;AND #$30
	;CMP #$30
	;BNE +
	;JSR .GetSpritePos
	;AND #$0F
	;STA $0F42
;+
	;RTL
	
	
	
	LDA $0F45
	BEQ +
	LDA $14
	AND #$01
	BNE +
	DEC $0F45
+
	LDA $0F44
	JSL $0086DF
	dw .nothing
	dw .growing
	dw .thunder
	dw .shrinks
	
.nothing
	LDA $17
	AND #$30
	CMP #$30
	BEQ +
	JMP .noSpr
+	
	LDA #$1E
	STA $0F45
	
	JSR .GetSpritePos
	BMI .noSpr
	TAX
	STX $0F46
	LDA $E4,x
	SEC : SBC #$04
	BPL +
	LDA #$00
+
	STA $0F42
	LDA $E4,x
	CLC : ADC #$04
	BCC +
	LDA #$FF
+
	STA $0F43
	INC $0F44
	
	REP #$20
	LDA $40
	STA $0F3A
	LDA $42
	STA $0F3C
	LDA $44
	STA $0F3F
	SEP #$20





	RTL
	
.noSpr
	STZ $0F45
	RTL

.growing
	LDA $0F45
	BEQ .goThunder
	LDA #$1E
	SEC : SBC $0F45
	CLC : ADC #$04
	STA $03
	STZ $04
	LDX $0F46
	LDA $14E0,x
	STA $05
	LDA $E4,x
	STA $06
	
	REP #$20
	LDA $05
	SEC : SBC $03
	BPL +
	LDA.w #$00
+
	AND.w #$00FF
	SEP #$20
	STA $0F42
	
	REP #$20
	LDA $05
	CLC : ADC $03
	CMP #$0100
	BCC +
	LDA.w #$00FF
+	
	AND.w #$00FF
	SEP #$20
	STA $0F43
	RTL
	
.goThunder
	INC $0F44
	LDA #$01
	STA $0F45
	LDA #$18
	STA $1DFC
	RTL
	
.thunder
	LDA $0F45
	BEQ +
	RTL
+
	LDX $0F46
	LDA $E4,x
	STA $0F47
	LDA #$02
	STA $14C8,x
	INC $0F44
	LDA #$1E
	STA $0F45
	RTL
	
.shrinks
	LDA $0F45
	BEQ .goReset
	LDA $0F47
	SEC : SBC $0F45
	BPL +
	LDA #$00
+
	STA $0F42
	LDA $0F47
	CLC : ADC $0F45
	BCC +
	LDA #$FF
+	
	STA $0F43
	RTL
.goReset
	REP #$20
	LDA $0F3A
	STA $40
	LDA $0F3C
	STA $42
	LDA $0F3F
	STA $44
	STZ $0F44
	SEP #$20
	RTL

.GetSpritePos
	STZ $00
	LDA #$01 : STA $01
	LDA #$FF : STA $02
	
	;LDA $00
	;STA $0F42
	;LDA $01
	;STA $0F43
	LDX #$0B
.loop
	LDA $14C8,x
	BEQ .nextSlot
	LDA $14E0,x
	XBA
	LDA $E4,x
	REP #$20
	SEC
	SBC $94 ; $D1?
	BPL +
	EOR.w #$FFFF
	INC
+
	CMP.w $00
	BCS ++
	STX $02
++
	SEP #$20
.nextSlot
	DEX
	BPL .loop
	LDA $02
	RTS
	

nmi:
	LDA $2130
	PHA
	LDA $0F44
	BEQ .donotWrite
	PLA
	LDA $0F42
	STA $2126
	LDA $0F43
	STA $2127
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
	LDA #$FF : STA $2122	;window color low byte (SNES)
	LDA #$7F : STA $2122	;window color high byte (SNES)
	LDA.b #%01000010	;add in subscreen
	STA $44			;also clip to black outside window
	STA $2130		;(that just disables the color outside the window)	
	RTL
.donotWrite
	PLA 
	STA $44
	STZ $43
	LDA #$00	
	STA $2126
INC A	
STA $2127
	
	RTL
	
	
	