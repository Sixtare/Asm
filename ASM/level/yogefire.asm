main:
 LDA $187A	 ;Riding Yoshi Flag 00 = no yoshi
 CMP #00
 BCS yoshitrue
 RTL

 yoshitrue: 
 LDA #04
 STA $1DFB
 RTL