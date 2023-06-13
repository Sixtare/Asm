!FREERAM = $7FA100
!TABLESIZE = #$24

!firstsize = $60
!secondsize = $61

!secondcolor = $62

!highervalue = $63

init:

LDX !TABLESIZE

storeTable:
	LDA RedTable,X
	STA !FREERAM,X
	DEX
	BPL storeTable

        LDA #$17    ;\  BG1, BG2, BG3, OBJ on main screen (TM)
        STA $212C   ; |
        LDA #$00    ; | 0 on main screen should use windowing. (TMW)
        STA $212E   ;/
        LDA #$00    ;\  0 on sub screen (TS)
        STA $212D   ; |
        LDA #$00    ; | 0 on sub screen should use windowing. (TSW)
        STA $212F   ;/
        LDA #$37    ; BG1, BG2, BG3, OBJ, Backdrop for color math
        STA $40     ;/  mirror of $2131

	LDA !FREERAM
	STA !firstsize

	LDA !FREERAM+2
	STA !secondsize

	LDA !FREERAM+3
	STA !secondcolor

REP #$20
	LDA #$3200
	STA $4330
	LDA #$A100	;Red Table Location
	STA $4332
	LDY #$7F
	STY $4334
	LDA #$3200
	STA $4340
	LDA #GreenTable
	STA $4342
	LDY.b #GreenTable>>16
	STY $4344
	LDA #$3200
	STA $4350
	LDA #BlueTable
	STA $4352
	LDY.b #BlueTable>>16
	STY $4354
SEP #$20
	LDA #$38;
	TSB $0D9F	;$6D9F if you're using SA-1

RTL

main:

	JSR UPDATEPOS

RTL

UPDATEPOS:

	LDA #$C0
	SEC
	SBC $1C	;Layer 1 Y pos
	CLC
	ADC !firstsize
	CMP #$60

BCS .storeComplex
	STA !FREERAM

	LDA !secondsize
	STA !FREERAM+2

	LDA !secondcolor
	STA !FREERAM+3

RTS


.storeComplex

	PHA
	LDA #$60
	STA !FREERAM
	PLA
	SEC
	SBC #$60
	STA !FREERAM+2

	LDA #$20
	STA !FREERAM+3

RTS


RedTable:            ;
   db $08 : db $20   ;
   db $0D : db $22   ;
   db $0D : db $24   ;
   db $0D : db $26   ;
   db $0D : db $28   ;
   db $0E : db $2A   ;
   db $0C : db $2C   ;
   db $0E : db $2E   ;
   db $0D : db $31   ;
   db $0E : db $33   ;
   db $0C : db $35   ;
   db $0E : db $37   ;
   db $0D : db $39   ;
   db $0C : db $3B   ;
   db $0D : db $3D   ;
   db $0E : db $3E   ;
   db $0D : db $3D   ;
   db $06 : db $3F   ;
   db $00            ;

BlueTable:           ;
   db $80 : db $80   ;
   db $60 : db $80   ;
   db $00            ;

GreenTable:          ;
   db $80 : db $40   ;
   db $60 : db $40   ;
   db $00
