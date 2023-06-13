init:    

STZ $58

RTL

nmi:

LDA $0DAF
BEQ .disable

LDA $1493
BNE .ending

LDA $58
BEQ .HDMA
BNE .checkbox

.HDMA:         ; 
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

	REP #$20
	LDA #$3200
	STA $4330
	LDA #.RedGreenBlueTable
	STA $4332
	LDY.b #.RedGreenBlueTable>>16
	STY $4334
	SEP #$20
	LDA #$08
	TSB $0D9F
	INC $58     ;CUSTOM CODE AQUI MEW

.checkbox
LDA $1426
BEQ .return
BNE .disable

.ending
LDA #$80
STA $0D9F

.disable

LDA #%00001000
STA $212C

LDA #$40
STA $212E

LDA #%00010111
STA $212D

LDA #$FC
STA $212F

;LDA #$20
;STA $40

LDA $1B88

BNE .enable
BEQ .return

.enable

LDA $1B89
BNE .return

LDA $71
BNE .return

STZ $58

.return
RTL

.RedGreenBlueTable:  ; 
   db $36 : db $E0   ; 
   db $38 : db $E1   ; 
   db $3F : db $E2   ; 
   db $33 : db $E3   ; 
   db $00            ;  
 

           

