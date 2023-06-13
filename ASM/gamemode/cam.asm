main:

LDA $72 
BNE jumping
BEQ reset

jumping:
LDA $58		;
BNE check	;Sem essas linhas só funciona realmente com shelljump(segurando objeto)

LDA $148F 	;Flag mario is holding object
BEQ end

LDA #$01
STA $58
BRA check

check:
LDA $1697
CMP #$02
BCS vscroll
RTL

vscroll:
LDA #$80
STA $1406
RTL

reset:
STZ $58
RTL

end:
RTL

;$1406 When #$80 Camera moves verticaly with mario
;$1697 Consecutive enemys stomped
;$13F1 Enable vertical scroll flag #$00/#$01 disabled/enabled(Lunar magic scroll)
;$72   Player is in air flag #$0B = Jumping #$24 = Falling