;Extract and insert the graphics before the code can work properly
;Also should activate bypass GFX in the rom at least once (Red mushroom in lunar magic)

!leveltile = $D900	;Level 105
!gfxbg = $001B

!upflag = $58
!index = $60
!counter = $62


main:
	LDA $18
	BIT #$10
BNE .runCode
	BIT #$20
BNE .doVramMap

RTL

.runCode

	JSR LC_RLE1
	JSR CLEAR_TILES

PHB
REP #$30
	LDA #$06FF
	LDX #$0000
	LDY #$BC00
	MVN $7F7F
SEP #$30
PLB

REP #$20
	STZ $00
	LDA #$7F00	; buffer = $7EAD00
	STA $01
	LDA #!gfxbg	; decompress GFXxx.bin
	JSL $0FF900
SEP #$20

	INC  !upflag
RTL

.doVramMap

REP #$10
	LDX #$0000

- PHX
	LDY #$0000
	LDA $7FC3C0,X	;$7FC300 - Default
	XBA
	LDA $7FBCC0,X	;$7FBC00 - Default

REP #$20
	ASL A
	ASL A
	ASL A		;Mutiply x8
	TAX
--	LDA $0D9100,X
PHX

	LDX !index
	STA $7F0000,X
PLX

	INX
	INX
	LDA $0D9100,X

PHX
PHA
	LDX !index
	TXA
	CLC
	ADC #$0040
	TAX

PLA
	STA $7F0000,X
PLX

	INC !index
	INC !index

	INY
	INY

	INX
	INX

	CPY #$0004
	BNE --

SEP #$20
	INC !counter
	LDA !counter
	CMP #$10
BNE .normal
	STZ !counter
REP #$20
	LDA !index
	CLC
	ADC #$0040
	STA !index
SEP #$20

.normal
	PLX
	INX
	CPX #$00F0			;Number of blocks to generate tiles for
	BNE -

SEP #$10

	STZ !counter

;SECOND SCREEN CALC BELLOW	- $7F0780 LOCATION


REP #$10
	LDX #$0000

-	PHX
	LDY #$0000
	LDA $7FC570,X	;$7FC300 - Default
	XBA
	LDA $7FBE70,X	;$7FBC00 - Default

REP #$20
	ASL A
	ASL A
	ASL A		;Mutiply x8
	TAX
--	LDA $0D9100,X
PHX

	LDX !index
	STA $7F0000,X
PLX

	INX
	INX
	LDA $0D9100,X

PHX
PHA
	LDX !index
	TXA
	CLC
	ADC #$0040
	TAX

PLA
	STA $7F0000,X
PLX

	INC !index
	INC !index

	INY
	INY

	INX
	INX

	CPY #$0004
	BNE --

SEP #$20
	INC !counter
	LDA !counter
	CMP #$10
BNE .normal2
	STZ !counter
REP #$20
	LDA !index
	CLC
	ADC #$0040
	STA !index
SEP #$20

.normal2
	PLX
	INX
	CPX #$00F0			;Number of blocks to generate tiles for
	BNE -

SEP #$10

	LDA #$02
	STA !upflag
RTL


;UPLOAD BG GFX // NMI STUFF

nmi:

	LDA !upflag
	CMP #$01
BEQ .updateL2
	CMP #$02
BEQ .uploadVRAM

RTL

.updateL2

	LDA #$80
	STA $2115	;Upload

	LDA #$00
	STA $2116	;Low byte vram destination

	LDA #$10	;High byte vram destination
	STA $2117

	LDA #$01	;How many bytes to write every time (0=1byte 1=2bytes)
	STA $4300

	LDA #$18	;ppu to acces #$18 = $2118
	STA $4301

	LDA #$00
	STA $4302	;Low byte

	LDA #$00	;High byte
	STA $4303	;High byte

	LDA #$7F
	STA $4304	;Bank

	LDA #$00
	STA $4305	;Low byte - How many bytes to write

	LDA #$10
	STA $4306	;High byte - How many bytes to write

	STZ $4307	;Bank byte - How many bytes to write

	LDA #$01
	STA $420B	;Activating DMA chanel $430X

	STZ !upflag
RTL

.uploadVRAM

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

	LDA #$02	;High byte
	STA $4303	;High byte

	LDA #$7F
	STA $4304	;Bank

	LDA #$00
	STA $4305	;Low byte - How many bytes to write

	LDA #$06
	STA $4306	;High byte - How many bytes to write

	STZ $4307	;Bank byte - How many bytes to write

	LDA #$01
	STA $420B	;Activating DMA chanel $430X

;Top screen DMA below

	LDA #$00
	STA $2116	;Low byte vram destination

	LDA #$3B	;High byte vram destination
	STA $2117

	LDA #$00
	STA $4302	;Low byte

	LDA #$00	;High byte
	STA $4303	;High byte

	LDA #$7F
	STA $4304	;Bank

	LDA #$00
	STA $4305	;Low byte - How many bytes to write

	LDA #$02
	STA $4306	;High byte - How many bytes to write

	STZ $4307	;Bank byte - How many bytes to wr

	LDA #$01
	STA $420B	;Activating DMA chanel $430X

;Bottom 2 screen DMA bellow

	LDA #$00
	STA $2116	;Low byte vram destination

	LDA #$3C	;High byte vram destination
	STA $2117

	LDA #$80
	STA $4302	;Low byte

	LDA #$09	;High byte
	STA $4303	;High byte

	LDA #$7F
	STA $4304	;Bank

	LDA #$00
	STA $4305	;Low byte - How many bytes to write

	LDA #$06
	STA $4306	;High byte - How many bytes to write

	STZ $4307	;Bank byte - How many bytes to wr

	LDA #$01
	STA $420B	;Activating DMA chanel $430X


;Top 2 screen DMA bellow

	LDA #$00
	STA $2116	;Low byte vram destination

	LDA #$3F	;High byte vram destination
	STA $2117

	LDA #$80
	STA $4302	;Low byte

	LDA #$07	;High byte
	STA $4303	;High byte

	LDA #$7F
	STA $4304	;Bank

	LDA #$00
	STA $4305	;Low byte - How many bytes to write

	LDA #$02
	STA $4306	;High byte - How many bytes to write

	STZ $4307	;Bank byte - How many bytes to wr

	LDA #$01
	STA $420B	;Activating DMA chanel $430X

	STZ !upflag

	JSR PALLETE
RTL

;LC_RLE1 Decompression

LC_RLE1:
CODE_04DD40: REP #$10                  ; Index (16 bit)
CODE_04DD42: SEP #$20                  ; Accum (8 bit)
CODE_04DD44: LDY.W #!leveltile	       ; Level tilemap setings
CODE_04DD47: STY $02
CODE_04DD49: LDA.B #$0C                ; Bank tilemap setings
CODE_04DD4B: STA $04
CODE_04DD4D: LDX.W #$0000
CODE_04DD50: TXY
CODE_04DD51: JSR.W CODE_04DD57
CODE_04DD54: SEP #$30                  ; Index (8 bit) Accum (8 bit)
Return04DD56: RTS                       ; Return

CODE_04DD57: SEP #$20                  ; Accum (8 bit)
CODE_04DD59: LDA [$02],Y
CODE_04DD5B: INY
CODE_04DD5C: STA $05
CODE_04DD5E: AND.B #$80
CODE_04DD60: BNE CODE_04DD71
CODE_04DD62: LDA [$02],Y
CODE_04DD64: STA.L $7F0000,X   		;RAM LOCATION OUTPUT
CODE_04DD68: INY
CODE_04DD69: INX
CODE_04DD6A: DEC $05
CODE_04DD6C: BPL CODE_04DD62
CODE_04DD6E: JMP.W CODE_04DD83

CODE_04DD71: LDA $05
CODE_04DD73: AND.B #$7F
CODE_04DD75: STA $05
CODE_04DD77: LDA [$02],Y
CODE_04DD79: STA.L $7F0000,X
CODE_04DD7D: INX
CODE_04DD7E: DEC $05
CODE_04DD80: BPL CODE_04DD79
CODE_04DD82: INY
CODE_04DD83: REP #$20                  ; Accum (16 bit)
CODE_04DD85: LDA [$02],Y
CODE_04DD87: CMP.W #$FFFF
CODE_04DD8A: BNE CODE_04DD57
Return04DD8C: RTS

;Seting layer 2 to empty and tilemap page

CLEAR_TILES:
CODE_05801F: SEP #$20                  ; 8 bit A ; Accum (8 bit)
CODE_058021: REP #$10                  ; 16 bit X,Y ; Index (16 bit)
CODE_058023: LDX.W #$0000              ; \
CODE_058026: LDA.B #$25                ;  |
CODE_058028: STA.L $7FBC00,X           ;  |Set all background tiles (lower bytes) to x25
CODE_05802C: STA.L $7FBE00,X           ;  |
CODE_058030: INX                       ;  |
CODE_058031: CPX.W #$0200              ;  |
CODE_058034: BNE CODE_058026           ; /
CODE_058036: STZ.W $1928
CODE_05803F: REP #$10                  ; 16 bit X,Y ; Index (16 bit)
CODE_058041: LDY.W #$0000              ; \
CODE_058044: LDX #!leveltile           ;  |!leveltile / was $68
CODE_058046: CPX.W #$E8FE              ;  |If Layer 2 pointer >= $E8FF,
CODE_058049: BCC CODE_05804E           ;  |the background should use Map16 page x11 instead of x10
CODE_05804B: LDY.W #$0001              ;  |
CODE_05804E: LDX.W #$0000              ; \
CODE_058051: TYA                       ;  |
CODE_058052: STA.L $7FC300,X           ;  |Set the background's Map16 page
CODE_058056: STA.L $7FC500,X           ;  |(i.e. setting all high tile bytes to Y)
CODE_05805A: INX                       ;  |
CODE_05805B: CPX.W #$0200              ;  |
CODE_05805E: BNE CODE_058052           ; /
	     SEP #$10
	     RTS



PALLETE:
	LDA #$02
	STA $2121

	LDX #$00
	LDY #$00

-	LDA.L $00B0C8,X
	STA $2122
	INX
	INY
	LDA.L $00B0C8,X
	STA $2122
	INX
	INY
	CPY #$0C

BEQ .secondRow
	CPY #$18

BEQ .endCode
	BNE -

.secondRow
	LDA #$12
	STA $2121
BRA -

.endCode
RTS
