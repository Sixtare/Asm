main:

LDA $18
CMP #$30
BEQ .scan
RTL

.next
REP #$20
INC $0F5E  ;INDEX DO BLOCO
LDA $0F5E
CMP #$1B0
BEQ .return

SEP #$20
INC $0F61  ;Contador de Xpos, se for = 0F reseta o valor de x e aumenta Y em 10
LDA $0F61
CMP #$10
BEQ .incy

REP #$20
LDA $0F62  ;Xpos do bloco 2byte
CLC
ADC #$0010
STA $0F62
JMP .scan

.incy
REP #$20
STZ $0F61
STZ $0F62
LDA $0F64  ;Ypos do bloco 2byte
CLC
ADC #$0010
STA $0F64

.scan
REP #$30
LDX $0F5E
LDA $7EC800,X
SEP #$30
STA $0F60
LDA $0F60  ;Low byte do bloco
CMP #$03
BEQ .check
JMP .next

.bridge
JMP .return

.check
REP #$30
LDA $7FC800,X
CMP #$02
BEQ .morph	
BNE .next

.morph

SEP #$30

LDA #%00100000
TSB $0F66 ; #%00100000 = ativando pra layer 1 em $7F837D



.return
SEP #$30
RTL

