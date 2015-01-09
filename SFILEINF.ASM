; Subroutine to set the extended attributes of an open file.
; Copyright (C) 1996, David W. Noon
           .286
           .287
;          OPTION   CASEMAP:ALL
           ASSUME   CS:_TEXT
_TEXT      SEGMENT  WORD READONLY PUBLIC 'CODE'
           PUBLIC   DWNSETFILEINFO
DWNSETFILEINFO PROC FAR PASCAL
           PUSH     BP          ; Stack housekeeping
           MOV      BP,SP       ;

           PUSH     ES          ; Save working ...
           PUSH     DI          ; ... registers.

           MOV      AX,5703H    ;  Set up the parameter list:
           MOV      BX,14[BP]   ;     File handle
           MOV      DX,12[BP]   ;     Info. level
           LES      DI,8[BP]    ;     Address of buffer area
           MOV      CX,6[BP]    ;     Buffer size

           INT      21H         ; Issue the multiplex interrupt
           JC       SHORT $+4   ; If an error occurred leave rc intact
           XOR      AX,AX       ; Set rc to zero

           POP      DI          ; Restore working ...
           POP      ES          ; ... registers.

           MOV      SP,BP       ; Restore stack
           POP      BP          ;

           RETF     10          ; Clean up 10 bytes of parameter pointers
DWNSETFILEINFO ENDP
_TEXT      ENDS
           END
