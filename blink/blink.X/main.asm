 #include "p10f200.inc"
 
; configuration
    __CONFIG _WDT_OFF & _CP_OFF & _MCLRE_OFF
    ORG 0x000

; use GP2 as input
    MOVLW ~(1 << T0CS)
    OPTION
    MOVLW ~(1 << GP2)
    TRIS GPIO
    
; main program
LOOP
    BSF GPIO, GP2
    CALL DELAY
    BCF GPIO, GP2
    CALL DELAY
    GOTO LOOP

; subroutine: sleep for ~200 ms
DELAY
    MOVLW D'255'
    MOVWF 10
    MOVWF 11
DELAY_LOOP
    DECFSZ 10, F
    GOTO DELAY_LOOP
    DECFSZ 11, F
    GOTO DELAY_LOOP
    RETLW 0
    
END


