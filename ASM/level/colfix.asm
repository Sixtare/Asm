main:
	
LDA $15
CMP #$30
BEQ .start
JMP return


return:
RTL

;$C2 Sprite hitado por cima seta em 01
;$1470 Carrying something flag


