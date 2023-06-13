init:
PHB
PHK
PLB

JSR rom

PLB
RTL

main:



RTL

rom:
ORG $019F6B
db $FF,$FF,$FF,$FF
NOP
RTS