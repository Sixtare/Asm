run:

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

RTL