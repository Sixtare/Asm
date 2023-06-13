!FREERAM = $7FA100
!TABLESIZE = #$24
!BITSET = $7FFF50

init:

LDX !TABLESIZE

LVL1_HDMAINIT:
	LDA RedTable,X
	STA !FREERAM,X
	DEX
	BPL LVL1_HDMAINIT


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
   
RTL

nmi:

JSR HDMACHANGE


	REP #$20
	LDA #$3200
	STA $4330
	LDA #$A100	;redtablelocation
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
	TSB $0D9F    ; $6D9F if you're using SA-1
	RTL

HDMACHANGE:

LDX !TABLESIZE
DEX 

-
	LDA !BITSET,X
	BNE .diminish

	LDA !FREERAM,X
	INC A
	CMP #$41
	BCC .increase
 	
	LDA #$01
	STA !BITSET,X	
	
	.diminish
	LDA !FREERAM,X
	DEC A
	STA !FREERAM,X
	CMP #$2A
	BCS +
	
	LDA #$00
	STA !BITSET,X
	
+	DEX
	DEX
	BPL -	

	.increase	
	STA !FREERAM,X
	DEX
	DEX
	BPL -

RTS

RedTable:           ; 
   db $08 : db $2A   ; 
   db $0D : db $2B   ; 
   db $0D : db $2C   ; 
   db $0D : db $2D   ; 
   db $0D : db $2E   ; 
   db $0E : db $2F   ; 
   db $0C : db $30   ; 
   db $0E : db $31   ; 
   db $0D : db $32   ; 
   db $0E : db $33   ; 
   db $0C : db $34   ; 
   db $0E : db $35   ; 
   db $0D : db $36   ; 
   db $0C : db $37   ; 
   db $0D : db $38   ; 
   db $0E : db $39   ; 
   db $0D : db $3A   ; 
   db $06 : db $3B   ; 
   db $00            ; 


BlueTable:          ; 
   db $80 : db $80   ; 
   db $60 : db $80   ;
   db $00            ; 

GreenTable:          ; 
   db $80 : db $40   ;
   db $60 : db $40   ;
   db $00 

