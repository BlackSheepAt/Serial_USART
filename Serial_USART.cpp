/* **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// **************************************************************;
                                                 Serial_USART.cpp
  "BEER-WARE LICENSE"  

  As long as you retain this notice you can do whatever you want 
  with this stuff. If we meet some day, and you think  this stuff 
  is  worth it, you can buy me a beer in return.

                                    Author:   jpagel
                                    Modified: BlackSheepAt@github

// **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// ************************************************************ */ 
#include "Serial_USART.h"
// **************************************************************;
  void Serial::sendChar(char c){ 
     while( !txUSART(c) ){
       // Blocking until puffer !full
     }
  }
// **************************************************************;
  void Serial::sendString(char* text){ 
	   while(*text) sendChar(*text++); 
  }
// **************************************************************;
  void Serial::sendString(const char* &text){
   char* iIT = (char*)text;
   sendString(iIT);
  }
// **************************************************************;
  char Serial::receiveChar(){ //Blocking
    int retval;
    while(EOF==(retval=rxUSART())){
      // Blocking until char received
    }
    return (char)retval; 
  }
// **************************************************************; 
 void Serial::SerialEnd(){
   disableUSART();
 }
// **************************************************************;
 void Serial::SerialBegin(uint32_t baud, uint32_t mhz){    
    uint16_t iTemp = ((mhz-(16*baud))/(16*baud));  
    if(iTemp>0x0FFF){
      enableU2X();
      iTemp = iTemp>>1;
    }else{
      disableU2X();
    }
    setUBRR(iTemp);
    enableUSART();
  } 
// **************************************************************;
  void Serial::SerialBegin(){
      #if !defined(BAUD)  
      #warning default value #define BAUD 57600
      #define BAUD 57600
      #endif
      #if !defined(F_CPU)
      #warning default value #define F_CPU 16000000
      #define F_CPU 16000000
      #endif
     SerialBegin(BAUD, F_CPU);		
  }
// **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// **************************************************************; 
