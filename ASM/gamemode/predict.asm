SprClippingWidth:                 db $0C,$0C,$10,$08,$30,$50,$0E,$28
                                  db $20,$14,$01,$03,$0D,$0F,$14,$24
                                  db $0F,$40,$08,$08,$18,$0F,$18,$0C
                                  db $0C,$0C,$0C,$0C,$0A,$1C,$30,$30
                                  db $08,$08,$10,$20,$38,$3C,$20,$18
                                  db $1C,$20,$0C,$10,$10,$08,$1C,$1C
                                  db $10,$30,$30,$40,$08,$12,$34,$0F
                                  db $20,$08,$20,$10


SprClippingHeight:                db $0A,$15,$12,$08,$0E,$0E,$18,$30
                                  db $10,$1E,$02,$03,$16,$10,$14,$12
                                  db $20,$40,$34,$74,$0C,$0E,$18,$45
                                  db $3A,$2A,$1A,$0A,$30,$1B,$20,$12
                                  db $18,$18,$10,$20,$38,$14,$08,$18
                                  db $28,$1B,$13,$4C,$10,$04,$22,$20
                                  db $1C,$12,$12,$12,$08,$20,$2E,$14
                                  db $28,$0A,$10,$0D

main:

LDA $72      ;In the air flag
BEQ .bridge  ;Era pra ser BEQ
LDA $7D	     ;Player Y speed #$00- #$7F = Falling #$80-#$FF = Rising
BMI .bridge  ;Branch if value between #$80-FF
JMP .calcx

.calcx
LDA $7B
BMI .jumpleft
REP #$20
LDA $7B    ;Player x speed
AND #$00FF
LSR A
CLC
ADC $94    ;Player x position level 2bytes
STA $0F5E  ;Xpos next frame
SEP #$20
JMP .near

.jumpleft
REP #$20 
LDA #$00FF
SEC
SBC $7B
AND #$00FF
LSR A
STA $0F5E
LDA $94
SEC
SBC $0F5E
STA $0F5E
SEP #$20
JMP .near

.bridge
JMP .return

.loop
INC $58

.near
LDX $58
CMP #$0C
BEQ .bridge
LDA $14C8,X
BEQ .loop
BNE .store

.store
LDA $E4,X
STA $0F60
LDA $14E0,X	
STA $0F61	;$0F60 Sprite X pos 2bytes

LDA $D8,X
STA $0F62
LDA $14D4,X     
STA $0F63	;$0F62 Sprite y pos 2bytes
JMP .dist

.dist
REP #$30
LDA $0F60
SEC
SBC $94         ;Player x position
TAY
LDA $0F64       ;Menor distancia
BEQ .zero
TYA
CMP $0F64
BCC .mindist

.zero
TYA
STA $0F64

SEP #$30
STX $5C
JMP +

.mindist
STA $0F64

SEP #$30
STX $5C          ;Tem que voltar pro loop e só terminar quando 58 = 0c
+
.return
STZ $58
SEP #$30
RTL




;$7E0F5E ;empty 20bytes
;LDA $7D ;Player y speed
;LDA $96 ;Player y position level 2bytes

;LDX $1662
;LDA $03B5A8,X Vai pegar a largura do sprite clipping do sprite