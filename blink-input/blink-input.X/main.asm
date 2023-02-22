#include "p10f200.inc"
    
    dreg1 EQU 10
    dreg2 EQU 11
    
; configuration
    __CONFIG _WDT_OFF & _CP_OFF & _MCLRE_OFF
    ORG 0x000

; use GP2 pin as GPIO
    MOVLW ~((1 << T0CS) | (1 << NOT_GPPU))
    OPTION

; set GP2 as output
    MOVLW ~(1 << GP2)
    TRIS GPIO

; GP3 is always an input port
    
; main program
LOOP
    BTFSS GPIO, GP3
    CALL TOG_ON_RELEASE
    GOTO LOOP

; wait a little and toggle GP2 when GP3 is
; released
TOG_ON_RELEASE
    CALL DELAY ; debouce press
RELASE_LOOP
    BTFSS GPIO, GP3
    GOTO RELASE_LOOP
    MOVLW 1 << GP2
    XORWF GPIO, F
    CALL DELAY ; debounce relase
    RETLW 0
    
; sleep for a while
DELAY
    MOVLW D'100'
    MOVWF dreg2
DELAY_LOOP
    DECFSZ dreg1, F
    GOTO DELAY_LOOP
    DECFSZ dreg2, F
    GOTO DELAY_LOOP
    RETLW 0
    
END 