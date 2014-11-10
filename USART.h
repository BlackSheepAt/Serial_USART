/* **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// **************************************************************;
                                                          USART.h
  "BEER-WARE LICENSE"  

  As long as you retain this notice you can do whatever you want 
  with this stuff. If we meet some day, and you think  this stuff 
  is  worth it, you can buy me a beer in return.
                                                     BlackSheepAt 

// **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// ************************************************************ */

#ifndef __USART_H__
#define __USART_H__

  #include <avr/io.h>

  // TODO:
  //#ifdef _AVR_INTERRUPT_H_ 
  //  # error not inplemented
  //  ISR(USART_RX_vect,  ISR_NAKED){  asm("RJMP USART_RXC_asm"); }
  //  ISR(USART_UDRE_vect, ISR_NAKED){ asm("RJMP USART_UDRE_asm"); }
  //#endif



  #ifdef __cplusplus
  extern "C" {

     extern void disableUSART();
     extern void enableUSART();

     extern int volatile setUBRR(uint32_t cTX);
     extern void enableU2X();
     extern void disableU2X();  

     
     extern int volatile txUSART(char cTX);
     extern int volatile _rxUSART(const int &iOUT);
      
     inline int rxUSART(){
        int retval;
        return _rxUSART(retval);
     };
 
  }
  #endif
#endif //__USART_H__

// **************************************************************;
//> > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > >;
// **************************************************************;
