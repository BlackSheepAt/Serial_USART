/* **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// **************************************************************;
                                                          USART.S
  "BEER-WARE LICENSE"  

  As long as you retain this notice you can do whatever you want 
  with this stuff. If we meet some day, and you think  this stuff 
  is  worth it, you can buy me a beer in return.

                                    Author:   jpagel
                                    Modified: BlackSheepAt@github

// **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// ************************************************************ */ 
#include "USART.h"

#if defined(RXEN)
  //use IN, OUT, SBRS (faster.. if supportet)
  #define USART_INOUT  (1==1) 

#else 
  //use LDS STS (compatible)
  #define USART_INOUT  (0==1) 

  //USART IO
  #define UCSRA UCSR0A
  #define UCSRB UCSR0B 
  #define UBRRL UBRR0L
  #define UBRRH UBRR0H
  //Flage
  #define UDRIE UDRIE0
  #define RXCIE RXCIE0
  #define URSEL URSEL0
  #define UCSZ1 UCSZ01
  #define UCSZ0 UCSZ00
  #define RXEN  RXEN0
  #define TXEN  TXEN0
  #define UDRE  UDRE0
  #define RXC   RXC0
  #define UDR   UDR0
  #define U2X   U2X0

#endif

// **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// **************************************************************;
// extern int volatile txUSART(char cTX);
//
// return (0xFF00+cTX) // on sucess
// return 0x0000       // on fail
//
.global txUSART 
 txUSART: 
   #if USART_INOUT
   IN   R25, _SFR_IO_ADDR(UCSRA)
   #else
   LDS  R25, _SFR_IO_ADDR(UCSRA)
   #endif
   ANDi R25, (1<<UDRE)
   BRNE BRtxUSART_00 
   CLR R24
 RET
   BRtxUSART_00:
   #if USART_INOUT
   OUT  _SFR_IO_ADDR(UDR), R24
   #else
   STS  _SFR_IO_ADDR(UDR), R24
   #endif 
   LDI R25, 0xFF
 RET
// **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// **************************************************************;
// extern int volatile _rxUSART(const int &iOUT);
//
// return UDR        // on sucess
// return 0xFFFF     // ==EOF on fail
//
.global rxUSART
 rxUSART: 
   #if USART_INOUT
   IN   R25, _SFR_IO_ADDR(UCSRA)
   #else
   LDS  R25, _SFR_IO_ADDR(UCSR0A)
   #endif
   ANDi R25, (1<<RXC)
   BRNE BRrxUSART_00
   //read fail, RXC not set.... return 0xFFFF;// == EOF
   SUBi R25, 1
   LDI  R24, 0xFF
 RET
   BRrxUSART_00:
   #if USART_INOUT
   IN  R24,  _SFR_IO_ADDR(UDR)
   #else
   LDS R24, _SFR_IO_ADDR(UDR)
   #endif
   SUB  R25, R25 //read ok  return 0x00xx !=EOF
  
 RET
// **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// **************************************************************; 
.global setUBRR
 setUBRR:
   #if USART_INOUT
   OUT _SFR_IO_ADDR(UBRRH),    R25
   OUT _SFR_IO_ADDR(UBRRL),    R24  
   #else
   STS _SFR_IO_ADDR(UBRRH),    R25
   STS _SFR_IO_ADDR(UBRRL),    R24  
   #endif
 RET
// **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// **************************************************************;
.global enableU2X
 enableU2X:
   PUSH R16
   IN   R16, _SFR_IO_ADDR(SREG)
   PUSH R16
   CLI 
     #if   USART_INOUT
     IN    R16,  _SFR_IO_ADDR(UCSRA) 
     ORi   R16,  (1<<U2X) 
     OUT   _SFR_IO_ADDR(UCSRA),   R16
     #else
     LDS   R16,  _SFR_IO_ADDR(UCSRA) 
     ORi   R16,  (1<<U2X) 
     STS   _SFR_IO_ADDR(UCSRA),    R16
     #endif         
   POP R16
   OUT  _SFR_IO_ADDR(SREG), R16
   POP R16
 RET
// **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// **************************************************************;
.global disableU2X
 disableU2X:
   PUSH R16
   IN   R16, _SFR_IO_ADDR(SREG)
   PUSH R16
   CLI 
     #if   USART_INOUT
     IN    R16,  _SFR_IO_ADDR(UCSRA) 
     ANDi  R16,  0xFF-(1<<U2X) 
     OUT   _SFR_IO_ADDR(UCSRA),   R16
     #else
     LDS   R16,  _SFR_IO_ADDR(UCSRA) 
     ANDi  R16,  0xFF-(1<<U2X) 
     STS   _SFR_IO_ADDR(UCSRA),    R16
     #endif         
   POP R16
   OUT  _SFR_IO_ADDR(SREG), R16
   POP R16
 RET
// **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// **************************************************************;
;Wait for empty transmit buffer  
.global waitURDE
 waitURDE:
   #if USART_INOUT
   BRwaitURDE_00:
   SBIS _SFR_IO_ADDR(UCSRA), UDRE
   RJMP BRwaitURDE_00
   #else
   PUSH R17
     BRwaitURDE_00:
     LDS  R17, _SFR_IO_ADDR(UCSRA)
     SBRS R17, UDRE
     RJMP BRwaitURDE_00
   POP  R17
  #endif
 RET
// **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// **************************************************************; 
.global enableUSART
 enableUSART:
   PUSH R16
   IN   R16, _SFR_IO_ADDR(SREG)
   PUSH R16
   CLI 
     #if   USART_INOUT
     IN    R16,  _SFR_IO_ADDR(UCSRB) 
     ORi   R16,  (1<<RXEN)|(1<<TXEN)
     OUT   _SFR_IO_ADDR(UCSRB),   R16
     #else
     LDS   R16,  _SFR_IO_ADDR(UCSRB) 
     ORi   R16,  (1<<RXEN)|(1<<TXEN)
     STS   _SFR_IO_ADDR(UCSRB),    R16
     #endif         
   POP R16
   OUT  _SFR_IO_ADDR(SREG), R16
   POP R16
 RET
// **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// **************************************************************; 
.global disableUSART
 disableUSART:
   PUSH R16
   IN   R16, _SFR_IO_ADDR(SREG)
   PUSH R16
   CLI 
     #if   USART_INOUT
     IN    R16,  _SFR_IO_ADDR(UCSRB) 
     ANDi  R16,  0xFF-((1<<RXEN)|(1<<TXEN))
     OUT   _SFR_IO_ADDR(UCSRB),   R16
     #else
     LDS   R16,  _SFR_IO_ADDR(UCSRB) 
     ORi   R16,   0xFF-((1<<RXEN)|(1<<TXEN))
     STS   _SFR_IO_ADDR(UCSRB),    R16
     #endif         
   POP R16
   OUT  _SFR_IO_ADDR(SREG), R16
   POP R16
 RET
// **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// **************************************************************;
