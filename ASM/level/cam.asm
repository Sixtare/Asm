main:

JSR MOVESCREEN
JSR BRIGHT

.checkInput
LDA $18
AND #%00010000
BNE .brightFlag

RTL

.brightFlag

LDA #$01
STA $5C

RTL

;-----------------------------------;
MOVESCREEN:
LDA $58
BNE .runCode

RTS

.runCode
LDA $142A
CMP #$02
BEQ .incBright

SEC
SBC #$0F
STA $142A
RTS

.incBright
INC $0DAE
LDA $0DAE
CMP #$0F
BEQ .reset

RTS

.reset

STZ $58
STZ $13FB

RTS
;-----------------------------------;
BRIGHT:

LDA $5C
BNE .decBright

RTS

.decBright

DEC $0DAE
LDA $0DAE
BEQ .setMove

RTS

.setMove

LDA #$01
STA $13FB

LDA #$F0

INC $95

LDA #$F2
STA $142A

LDA #$01
STA $58

STZ $5C
RTS
