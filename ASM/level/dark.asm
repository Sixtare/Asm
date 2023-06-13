init:
	LDA $1B
	STA $61
	STZ $60
	RTL
	
main:
	LDA $60
	BNE .forceFade
	LDA $71
	CMP #$09
	BEQ .setFlag
	LDA $1493
	ORA $1434
	BNE .setFlag
	LDA $1B
	CMP $61
	BEQ +
	BCS .dark
	BCC .light
.dark
	DEC $0DAE
	LDA $1B
	STA $61
	RTL
.light
	INC $0DAE

	LDA $0DAE
	BNE +
	LDA #$01
	STA $0DAE
+	LDA $1B
	STA $61
	RTL
	
.setFlag
	LDA $1B
	CMP #$0F
	BCS +
	RTL	

+	LDA #$0F
	STA $0DAE
	INC $60
	RTL
.forceFade
	STZ $40
	LDA #$40
	STA $44
	STZ $0D9F
	RTL
	
nmi:
	LDA $60
	BEQ +
	STZ $40
	LDA #$40
	STA $44
	STZ $0D9F
+	RTL;