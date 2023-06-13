!levelnumber = $60
!timer = $62

load:
	STZ $19			;No power up

	STZ $18E2  	        ;\
	STZ $0DC1  	        ; |No Yoshi
	STZ $187A  	        ; |
	STZ $0DBA   	        ;/
	
	STZ $0DC2		;Erase items in item box

	LDX $13BF
	LDA $1EA2,X
	ORA #$80
	STA $1EA2,X		;Allow player to leave with start+select

REP #$20

	LDA $13BF
	AND #$00FF
	CMP #$0024
BCC .skipCalc
	
	CLC
	ADC #$00DC
	
.skipCalc

	STA !levelnumber	
	CMP $010B		;Checking for sublevel
BEQ .resetCount
SEP #$20	

RTL
	
.resetCount
SEP #$20
	STZ $141A		;Sub level count reset
RTL

init:
	LDA #$80
	TRB $0DDA		;Play new music entering subLevel

RTL

main:

	LDA $71
	CMP #$09
	BEQ .reset

	LDA $13CE
BEQ .noMidway

	LDX $13BF
	LDA $1EA2,X
	ORA #$40
	STA $1EA2,X
	
	STZ $13CE

	LDA $19
BEQ .noMidway

	STZ $19			;No powerup crossing midway

.noMidway

RTL

.reset
	LDA #$FF
	STA $78
	
	LDA #$00
	STA $7D

	LDA !timer
BEQ .runAnimation

	DEC A
	STA !timer
BEQ .doReset	
	
RTL

.runAnimation
	LDA #$18
	STA !timer	

	LDA #$08
	STA $1DF9		;Plays "kaboom" sound
	
	JSL stars_run
	JSL smoke_run
RTL

.doReset	
REP #$10
	LDX #$017F

-	LDA #$00
	STA $19F8,X
	DEX
	BPL -
SEP #$10			;Reseting item memory

	LDX $13BF		
	LDA $1EA2,X
	AND #$40		;Checking if midway bit is set
BEQ .normalEntrance

	LDX $95
	LDA !levelnumber+1
	ORA #$0C		;Setting up bits to use midway entrance
	STA $19D8,X		;Will only work with custom midway positions
JMP .midwayStored

.normalEntrance

	LDX $95
	LDA !levelnumber+1
	ORA #$04
	STA $19D8,X		;Level high byte + midway configs 

.midwayStored
	
	LDA !levelnumber
	STA $19B8,X		;Level low byte	
	
	STZ $88			
	STZ $89
	LDA #$06
	STA $71			;Setting up warp values

	STZ $1496		;Resets player animation
	
	
RTL


nmi:
	LDA $71
	CMP #$09		;Doesn't Play death music
BNE .normalMusic
	
	STZ $1DFB

REP #$20
	LDA !levelnumber
	CMP $010B
BNE .resetMusic
SEP #$20

RTL

.resetMusic
SEP #$20
	STZ $0DDA		;Plays new music when dying in sublevel

.normalMusic
RTL