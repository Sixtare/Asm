main:

LDA $77		;Player is blocked direction SxxMUDLR
AND #%00000100  ;Checando se esta no chão
BEQ .setflag

STZ $58
RTL

.setflag
LDA $16
AND #$80	;Checa se player apertou B novamente depois de pular
BEQ .return

LDA $58
BNE .code

INC $58
RTL

.code
LDA $15
AND #$80
BNE .flutter	;Checando se o player esta pressionando B pra fazer o flutter
RTL

.flutter
LDA #$FF
STA $7D		;Mario y speed

.return
RTL


