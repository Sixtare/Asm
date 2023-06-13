main:
 LDA $14AD
 CMP #00
 BNE giveflower
 RTL

 giveflower: 
 LDA #03
 STA $19
 RTL