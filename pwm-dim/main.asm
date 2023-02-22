#include "p10f200.inc"
 
; registers
    count EQU 0x10
    limit EQU 0x11
    delay EQU 0x12

; configuration
    __CONFIG _WDT_OFF & _CP_OFF & _MCLRE_OFF
    ORG 0x000

; use GP1 as input
    MOVLW ~(1 << GP1)
    TRIS GPIO
    
; main program
LOOP
    MOVLW 0xFF
    MOVWF limit
DIM_LOOP
    MOVLW 0xFF
    MOVWF count
    BSF GPIO, GP1
PULSE_LOOP 
    MOVF limit, W
    SUBWF count, W
    BTFSC STATUS, Z ; if count = limit,
    BCF GPIO, GP1   ; clear GP1
    CALL DELAY
    DECFSZ count, F
    GOTO PULSE_LOOP ; end PULSE_LOOP
    DECFSZ limit, F
    GOTO DIM_LOOP   ; end DIM_LOOP
    GOTO LOOP       ; end LOOP
    
; delay of ~5 us
DELAY
    MOVLW d'16'
    MOVWF delay
DELAY_LOOP
    DECFSZ delay
    GOTO DELAY_LOOP
    RETLW 0

END


