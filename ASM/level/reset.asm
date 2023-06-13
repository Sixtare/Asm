init:

	STZ $4200	;no interrupts from here on out
	SEI
	SEP #$30	;request upload
	LDA #$FF
	STA $2141
	LDA #$00	;DB must be zero, this is done by the h/w normally
	PHA
	PLB

	STZ $420C	;disable any HDMA, this is done by the h/w normally
	JML $008016
	

RTL	