	LDA #$80
	STA $2115	;Upload

	LDA #$00
	STA $2116	;Low byte vram destination
	
	LDA #$38	;High byte vram destination
	STA $2117

	LDA #$01	;How many bytes to write every time (0=1byte 1=2bytes)
	STA $4300

	LDA #$18	;ppu to acces #$18 = $2118
	STA $4301

	LDA #$00
	STA $4302	;Low byte

	LDA #$99	
	STA $4303	;High byte

	LDA #$0D
	STA $4304	;Bank

	LDA #$08
	STA $4305	;Low byte - How many bytes to write
	
	LDA #$00
	STA $4306	;High byte - How many bytes to write

	STZ $4307	;Bank byte - How many bytes to write
	
	LDA #$01
	STA $420B	;Activating DMA chanel $430X
