load:

LDA $187A ;riding yoshi flag
BNE yoshitrue
LDA #$01 ;sem bloco marrom
STA $7FC060
RTL

yoshitrue:
LDA #$02 ;sem bloco rosa 
STA $7FC060
RTL