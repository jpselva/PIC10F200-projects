#include "p10f200.inc"
    
; configuration
    __CONFIG _WDT_OFF & _CP_OFF & _MCLRE_ON
    ORG 0x00
    
; arg registers
d1counter EQU 0x10
d2counter EQU 0x11
d1arg     EQU 0x12 
d2arg     EQU 0x13
periods   EQU 0x14

; main program
    MOVLW ~(1<<T0CS)
    OPTION
    MOVLW ~(1<<GP2)
    TRIS GPIO
LOOP
    CALL PLAY_E2
    CALL PLAY_E2
    CALL PLAY_E2
    CALL PLAY_D#2
    CALL PLAY_D#2
    CALL PLAY_D#2
    CALL PLAY_H1
    CALL PLAY_H1
    CALL PLAY_H1
    SLEEP
    GOTO LOOP
    
PLAY_NOTE
    MOVLW (1<<GP2)     ; toggle GP2
    XORWF GPIO, F
    MOVF d1arg, W      ; load 1st delay
    MOVWF d1counter
    MOVF d2arg, W      ; load 2nd delay
    MOVWF d2counter
DELAY                  ; half period delay
    DECFSZ d1counter, F
    GOTO DELAY
    DECFSZ d2counter, F
    GOTO DELAY
    DECFSZ periods, F
    GOTO PLAY_NOTE
    RETLW 0

; note subroutines
PLAY_E2
    MOVLW d'255'
    MOVWF periods
    MOVLW d'251'
    MOVWF d1arg
    MOVLW d'1'
    MOVWF d2arg
    CALL PLAY_NOTE
    RETLW 0
 
PLAY_D#2
    MOVLW d'240'
    MOVWF periods
    MOVLW d'10'
    MOVWF d1arg
    MOVLW d'2'
    MOVWF d2arg
    CALL PLAY_NOTE
    RETLW 0
    
PLAY_H1
    MOVLW d'191'
    MOVWF periods
    MOVLW d'80'
    MOVWF d1arg
    MOVLW d'2'
    MOVWF d2arg
    CALL PLAY_NOTE
    RETLW 0
    
    END



