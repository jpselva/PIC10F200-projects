#include "p10f200.inc"
 
; registers
    count EQU 0x10
    limit EQU 0x11
    delay EQU 0x12
    dir   EQU 0x13 ; 0 = dec, 255 = inc

; configuration
    __CONFIG _WDT_OFF & _CP_OFF & _MCLRE_OFF
    ORG 0x000

; use GP1 as input
    MOVLW ~(1 << GP1)
    TRIS GPIO
    
; main program
    CLRF dir
LOOP
    MOVLW 0xFF
    MOVWF limit
    COMF dir, F
DIM_LOOP
    MOVLW 0xFF
    MOVWF count
    BTFSS dir, 1   ; skip if dir is increasing
    GOTO $ + 3
    BSF GPIO, GP1  ; increasing -> start with 1
    GOTO PULSE_LOOP
    BCF GPIO, GP1  ; decreasing -> start with 0
PULSE_LOOP 
    MOVF limit, W
    SUBWF count, W
    BTFSS STATUS, Z  ; if count = limit,
    GOTO $ + 3
    MOVLW (1 << GP1) 
    XORWF GPIO, F    ; flip GP1
    CALL DELAY
    DECFSZ count, F
    GOTO PULSE_LOOP ; end PULSE_LOOP
    DECFSZ limit, F
    GOTO DIM_LOOP   ; end DIM_LOOP
    GOTO LOOP       ; end LOOP
    
; delay of ~5 us
DELAY
    MOVLW d'10'
    MOVWF delay
DELAY_LOOP
    DECFSZ delay
    GOTO DELAY_LOOP
    RETLW 0

END