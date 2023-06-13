init:
REP #$20
LDA #$FFFF
STA $0F62
SEP #$20
RTL

main:
LDA $18
CMP #$30
BEQ .near
BNE .bridge

.next
INC $58

.near
SEP #$30
LDA $58
CMP #$0C
BEQ .bridge

LDX $58
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
LDA $14D4,X     ;$0F60 Sprite y pos 2bytes
STA $0F61
INC $58
JMP .dist

.dist
REP #$20
LDA $0F5E
SEC
SBC $94
BMI .negatix
STA $0F62       ;Distancia x entre sprite e mario
.back
LDA $0F60
SEC
SBC $96
BMI .negatiy
STA $0F64       ;Distancia y entre sprite e mario
JMP .math

.bridge
JMP .end

.negatix
LDA $94
SEC
SBC $0F5E
STA $0F62
JMP .back

.negatiy
LDA $96
SEC 
SBC $0F60
STA $0F64

.math
REP #$30

LDA $0F62 ;Distancia x
STA $0F68 ;Soma base
STA $0F70 ;Contador de somas

LDA $0F64 ;Distancia y
STA $0F3A ;Soma base
STA $0F3C ;Contador de somas

.loopx
LDA $0F66 ;dist x ao quadrado
CLC
ADC $0F68
STA $0F66
DEC $0F70
LDA $0F70
BNE .loopx
BEQ .loopy

.loopy
LDA $0F3E ;dist y ao quadrado
CLC
ADC $0F3A
STA $0F3E
DEC $0F3C
LDA $0F3C
BNE .loopy
BEQ .square

.square

.end
SEP #$30
STZ $58
RTL

;$94   ;player x position within the level 2byte
;$96   ;player y position within the level 2byte
;$D8   ;Sprite y position low byte
;$E4   ;Sprite x position low byte
;$14D4 ;Sprite Y position high byte
;$14E0 ;Sprite X position high byte

;$0F5E ; Empty 20bytes