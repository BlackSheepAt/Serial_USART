/* **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// **************************************************************;
                                                   Serial_USART.h
  "BEER-WARE LICENSE"  

  As long as you retain this notice you can do whatever you want 
  with this stuff. If we meet some day, and you think  this stuff 
  is  worth it, you can buy me a beer in return.

                                    Author:   jpagel
                                    Modified: BlackSheepAt@github

// **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// ************************************************************ */ 

#ifndef SERIAL_USART_H_
#define SERIAL_USART_H_

  #include <avr/io.h>
  #include "USART.h" 
  
  //#define BAUD 57600
  //#define F_CPU 16000000

  #ifndef EOF
    #define EOF (-1)
  #endif

  class Serial{
    public:
      Serial(){};
      ~Serial(){};
    public:

      // Blocking until puffer !full
      void sendChar(char c);       
      void sendString(char* text);
      void sendString(const char* &text);

      // Blocking until char received
      char receiveChar();   

      // enable 
      void SerialBegin();// using BAUD, F_CPU
      void SerialBegin(uint32_t baud, uint32_t mhz);
      
      // disable
      void SerialEnd();
  };


#endif /* SERIAL_USART_H_ */

// **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// **************************************************************;

