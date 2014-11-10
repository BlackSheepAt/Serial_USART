/*
 * Serial_USART.h
 * 
 *  Author:   jpagel
 *  Modified: BlackSheepAt
 *
 */ 

#ifndef SERIAL_USART_H_
#define SERIAL_USART_H_

  #include <avr/io.h>
  #include "USART.h" // code folgt diese woche
  #include "ProgMemData.h" 

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

      void SerialBegin();
      void SerialBegin(baud_t baud);
      void SerialEnd();

      char usart_receiveByte();
      void SerialBeginXMEGA(baud_t baud);
  };


#endif /* SERIAL_USART_H_ */
