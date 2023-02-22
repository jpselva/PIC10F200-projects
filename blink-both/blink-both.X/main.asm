 #include "p10f200.inc"
 
; configuration
    __CONFIG _WDT_OFF & _CP_OFF & _MCLRE_OFF
    ORG 0x000

; use GP2 pin as GPIO and not something else
    MOVLW ~(1 << T0CS)
    OPTION
    
; set GP1 and GP2 as outputs
    MOVLW ~((1 << GP2) | (1 << GP1))
    TRIS GPIO
    
; main program
LOOP
    BSF GPIO, GP1
    NOP
    BCF GPIO, GP2
    CALL DELAY
    BCF GPIO, GP1
    NOP
    BSF GPIO, GP2
    CALL DELAY
    GOTO LOOP

; subroutine: sleep for ~600 ms
DELAY
    MOVLW D'255'
    MOVWF 10
    MOVWF 11
    MOVLW D'3'
    MOVWF 12
DELAY_LOOP
    DECFSZ 10, F
    GOTO DELAY_LOOP
    DECFSZ 11, F
    GOTO DELAY_LOOP
    DECFSZ 12, F
    GOTO DELAY_LOOP
    RETLW 0
    
END





