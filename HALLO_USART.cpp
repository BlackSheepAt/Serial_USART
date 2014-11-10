/* **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// **************************************************************;
                                                    HALLO_USART.h
  "BEER-WARE LICENSE"  

  As long as you retain this notice you can do whatever you want 
  with this stuff. If we meet some day, and you think  this stuff 
  is  worth it, you can buy me a beer in return.

                                    Author:   BlackSheepAt@github

// **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// ************************************************************ */ 
#include <avr/io.h>

#include "USART.h"
#include "Serial_USART.h"

int main(void){
  Serial oUSART;
  int iTemp0; 

  oUSART.SerialBegin(28800, 7372800);// baud, mhz
  oUSART.sendString((char* const) "RESET\r\n" );

  while(true){ 
    
    oUSART.sendChar(oUSART.receiveChar());//USART loop back 1 Byte.. Blocking 

    //USART loop back non Blocking 
    if(  (iTemp0=rxUSART()) != EOF ){      
      while( !txUSART(iTemp0) ){
        // wait for UDRE...
        // try tx until success....
      }
    }else{
      // EOF == (-1)
      // no data received
    }

  }

  oUSART.SerialEnd();
}
// **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// **************************************************************; 
