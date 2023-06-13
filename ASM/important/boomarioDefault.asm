!timer = $20
!counter = $58

main:

LDA $71
CMP #$09
BNE .visible

LDA #$FF
STA $78

LDA !counter
CMP #$01
BEQ .endLevel

DEC !counter

RTL

.endLevel

LDA #$30
STA $9D

RTL

.visible
LDA $16
ORA $15
AND #%01000000
BNE .blowUp

RTL

.blowUp

LDA #$08
STA $1DF9

JSL $00F606

STZ $1DFB	;Mute death music

JSR STARS
JSR SMOKE

STZ $9D
LDA #!timer
STA !counter

RTL

SMOKE:

LDA #$01	;Spawn smoke in mario position
STA $170B
	
LDA $96		;Mario Y Pos Low byte      
CLC
ADC #$0C                    
STA $1715  	;Extended sprite Y low pos

LDA $97     
STA $1729	;Y pos High Byte
  
LDA $94                         
STA $171F	;X pos low
  
LDA $95    
STA $1733   	;X pos High Byte  

LDA #$10               
STA $176F

RTS

STARS:

                   
LDX #$03                
JMP .findSlot       

-	DEX                       
	BPL .findSlot
                    
RTS                   

.findSlot
LDY #$07         ;Find a free extended sprite slot 

--
	LDA $170B,Y
	BEQ .runStars            
	DEY                        
BPL --   
        
RTS              	   

.runStars

LDA #$10        ;Extended sprite = Spin jump stars 
STA $170B,Y   	;ExSprite Num 

LDA $96		;Mario Y Pos Low byte      
CLC
ADC #$10                    
STA $1715,Y   	;Extended sprite Y low pos

LDA $97     
STA $1729,Y	;Y pos High Byte
  
LDA $94 
CLC
ADC #$04                        
STA $171F,Y	;X pos low
  
LDA $95    
STA $1733,Y   	;X pos High Byte  
               
LDA DATA_07FC33,X       
STA $1747,Y   

LDA DATA_07FC37,X       
STA $173D,Y   

LDA #$17                
STA $176F,Y             

JMP -			  ;Go back to do the last stars
RTS                       ; Return

DATA_07FC33:                      
db $E0,$20,$E0,$20

DATA_07FC37:                      
db $F0,$F0,$10,$10
	
	