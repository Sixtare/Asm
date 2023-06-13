run:
                  
LDX #$03                
JMP .findSlot       

-	DEX                       
	BPL .findSlot
                    
RTL                  

.findSlot
LDY #$07         ;Find a free extended sprite slot 

--
	LDA $170B,Y
	BEQ .runStars            
	DEY                        
BPL --   
        
RTL             	   

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
RTL                    ; Return

DATA_07FC33:                      
db $E0,$20,$E0,$20

DATA_07FC37:                      
db $F0,$F0,$10,$10