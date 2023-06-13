!FREERAM = $7FA100
!TABLESIZE = #$08

init:

LDX !TABLESIZE

storeTable:
	LDA bright,X
	STA !FREERAM,X
	DEX
	BPL storeTable
RTL

nmi:

JSR HDMACHANGE

	REP #$20	; 16 bit A
	LDA #$0000	; $43X0 = 00 
	STA $4330	; $43x1 = 00
	LDA #$A100  	;#LVL1BRIGHT	; get pointer to brightness table
	STA $4332	; store it to low and high byte pointer
	LDY #$7F
	STY $4334	; store to bank pointer byte
	SEP #$20	; 8 bit A
	LDA #%00001000	; Enable HDMA on channel 3
	TSB $0D9F	;
	RTL		; return

HDMACHANGE:

LDA $58
BEQ .startingPhase

LDA $5C
BEQ .endingPhase

LDA #$70
STA !FREERAM
STZ $5C

.endingPhase
LDX !TABLESIZE
DEX
DEX
DEX
DEX

--
	CPX #$00
	BEQ .lastIndex2
		
	LDA !FREERAM,X
	INC A
	
	STA !FREERAM,X
	DEX
	DEX
	BPL --

	.lastIndex2
	LDA !FREERAM,X
	DEC A
	CMP #$00
	BNE ++
	
	STZ $58
++
	STA !FREERAM,X
	RTS


.startingPhase

LDX !TABLESIZE
DEX
DEX
DEX
DEX
-
	CPX #$00
	BEQ .lastIndex
		
	LDA !FREERAM,X
	DEC A
	
	STA !FREERAM,X
	DEX
	DEX
	BPL -

	.lastIndex
	LDA !FREERAM,X
	INC A
	CMP #$70
	BNE +
	
	LDA #$01
	STA $58
	STA $5C
		
+
	STA !FREERAM,X
	RTS

bright:
db $00,$00
db $70,$0F
db $70,$0F
db $70,$00
db $00


