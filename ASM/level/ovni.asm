init:
REP #$20
LDA #$FFFF
STA $0F62
SEP #$20
RTL

main:

LDA $18C2 ;Player in lakitu cloud flag
BNE .input
RTL

.input 
LDA $18
CMP #$30
BEQ .near
RTL

.next
INC $58

.near
SEP #$30
LDA $58
CMP #$0C
BEQ .math

LDX $58
LDA $9E,X ;Sprite number
CMP #$87 ;Sprite 87 é a  cloud
BEQ .next

LDA $14C8,X
BEQ .next
BNE .store

.store
LDA $E4,X
STA $0F5E
LDA $14E0,X	;$0F5E Sprite X pos 2bytes
STA $0F5F
LDA $D8,X
STA $0F60     
LDA $14D4,X
STA $0F61       ;$0F60 Sprite Y pos 2bytes
INC $58
JMP .dist

.dist
REP #$20
LDA $0F5E   
SEC
SBC $94
BMI .negatix

CMP $0F62
BCS .near

STA $0F62
LDA $0F60
STA $0F64
SEP #$20
STX $5C
JMP .near

.negatix
LDA $94
SEC
SBC $0F5E
CMP $0F62
BCS .near

STA $0F62
LDA $0F60
STA $0F64
SEP #$20
STX $5C
JMP .near

.math
REP #$20
LDA $0F64
CMP $96
BCS .check
JMP .return

.check
LDA $0F62
CMP #$000F
BCS .return
BCC .abduct

.abduct

SEP #$20    ;ARRUMAR DAQUI PRA BAIXO PQ TA CRASHANDO
LDX $5C
LDA #$09
STA $14C8,X

INC $D8,X
LDA $D8,X
STA $0F64
LDA $14D4,X
STA $0F65

.loop
REP #$20
LDA $0F64
SEC 
SBC $96
CMP $0F
BCS .loop
BCC .destroy

.destroy
INC $19


.return
STZ $58

REP #$20
STZ $0F64
LDA #$FFFF
STA $0F62
SEP #$30

RTL

;$94   ;player x position within the level 2byte
;$96   ;player y position within the level 2byte
;$D8   ;Sprite y position low byte
;$E4   ;Sprite x position low byte
;$14D4 ;Sprite Y position high byte
;$14E0 ;Sprite X position high byte

;$0F5E ; Empty 20bytes