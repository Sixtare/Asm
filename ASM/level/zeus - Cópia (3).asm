init:
REP #$30
LDA #$FFFF
STA $1415
SEP #$30
RTL

main:
LDA #$0C                ;index sprites
STA $58

LDA $18
CMP #$30                ;checando se L+R esta pressionado
BEQ bridge

LDA $192C ;gonna be the flag
BNE draw
RTL

draw:
STZ $212C		;nothing on main screen
LDA.b #%00011111	;everything on sub screen
STA $212D
LDA.b #%00100000	;backdrop color math enable
STA $40
STA $2131
;LDA.b #%00100000	;enable color window 1
STA $43
STA $2125
STZ $2121
LDA #$5A : STA $2122	;window color low byte (SNES)
LDA #$03 : STA $2122	;window color high byte (SNES)
LDA.b #%01000010	;add in subscreen
STA $44			;also clip to black outside window
STA $2130		;(that just disables the color outside the window)

LDA $192C
CMP #$01
BEQ grow
CMP #$02
BEQ shrink

grow:

LDA $7C
CMP $87
BEQ kill

LDA $79
SEC
SBC #$05
STA $79
LDA $7C
CLC
ADC #$05
STA $7C
LDA $79
STA $2126
LDA $7C
STA $2127
STZ $14
RTL

shrink:

LDA $7C
CMP $87
BEQ vanish

LDA $7C
SEC
SBC #$05
STA $7C
LDA $79
CLC
ADC #$05
STA $79
LDA $79
STA $2126
LDA $7C
STA $2127
STZ $14
RTL

bridge:
JMP near

kill:

LDA $14
CMP #$01
BCC done

LDA #$18      ;Tocar som do trovao
STA $1DFC
LDA #$08
STA $1DF9     ;Tocar som morte por spinJump
LDX $5C	      ;kill sprite
LDA #$04
STA $14C8,X
LDA #$0A      ;Time padrao	
STA $1540,X   ;Time for cloud animation

LDA #$02
STA $192C

LDA $87
SEC
SBC #$32
STA $87

done:

RTL

vanish:
STZ $192C
STZ $43
RTL

math:
REP #$30
LDA $13E6
CMP $D1
BCC sprmenor

SEC 
SBC $D1
STA $140B
SEP #$30
BRA smallest

sprmenor:
LDA $D1
SEC
SBC $13E6 
STA $140B
SEP #$30
BRA smallest

empty:
INC $14C1   ;Aumenta em 1 pra cada sprite slot vazio

near:
LDA $192C
BNE sbridge
LDA $58
DEC $58     ;se contador for igual a 00 termina codigo
CMP $FF
BEQ end
LDX $58
LDA $14C8,X ;checando se sprite no slot de index X esta vazio
BEQ empty

LDA $E4,X   ;sprite x pos lowbyte
STA $13E6   ;empty 2 bytes gonna b sprite x pos low byte
LDA $14E0,X ;sprite x position high byte
STA $13E7   ;empty 2 bytes gonna b sprite x pos high byte
BRA math

smallest:
REP #$30
LDA $140B   ;dist entre mario sprite no slot de menor numero
CMP $1415   ;checa se a distancia atual é menor que a ultima
BCC +

SEP #$30
BRA near

+
STA $1415
LDA $13E6 
STA $1869
SEP #$30

STX $5C
BRA near

sbridge:
JMP ongoing

end:
LDA #$0C
CMP $14C1 ; se tiverem 12 sprite slots vazios a animação nao inicia
BEQ ongoing

REP #$30
;LDA $1415 ;Checando se a menor distancia é maior que ff
;CMP #$00FF  ;Meio que funciona mas tenho que checar de acordo com a posição na tela
;BCS ongoing

LDA $1869  ;$1869 Posição do sprite com menor distancia entre mario
CMP $D1    ;$D1 mario pos in level 2byte
BCS ++	   		
	
SEP #$30
LDA $7E
SEC
SBC $1415
CMP $7E
BCS ongoing

CLC
ADC #$06
STA $79
STA $7C 
BRA skip

++
SEP #$30
LDA $1415
CLC
ADC $7E     ;Mario pos from left edge of the screen
CMP $7E
BCC ongoing ;Se soma pos mario in screen + sprite in screen < pos mario in screen fim

SEP #$30
CLC
ADC #$06
STA $79     ;Pos. sprite from the left edge of the screen
STA $7C  
skip:

LDA #$01
STA $192C   ;Ativa a flag pra gerar o windowing

LDA $7C
CLC
ADC #$04
STA $7C
CLC 
ADC #$32
STA $87

ongoing:
REP #$30
LDA #$FFFF
STA $1415
SEP #$30
STZ $14C1

RTL

