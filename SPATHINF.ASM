; Subroutine to set the extended attributes of a path.
; Copyright (C) 1996, David W. Noon
           .286
           .287
;          OPTION   CASEMAP:ALL
           ASSUME   CS:_TEXT
_TEXT      SEGMENT  WORD READONLY PUBLIC 'CODE'
           PUBLIC   DWNSETPATHINFO
DWNSETPATHINFO PROC FAR PASCAL
           PUSH     BP          ; Stack housekeeping
           MOV      BP,SP       ;

           PUSH     DS          ; Save working ...
           PUSH     SI          ; ... registers.
           PUSH     ES          ; ...
           PUSH     DI          ; ...

           MOV      AX,5703H    ;  Set up the parameter list:
           MOV      BX,0FFFFH   ;     Indicator for path/filename
           LDS      SI,14[BP]   ;     Address of path/filename
           MOV      DX,12[BP]   ;     Info. level
           LES      DI,8[BP]    ;     Address of buffer area
           MOV      CX,6[BP]    ;     Buffer size

           INT      21H         ; Issue the multiplex interrupt
           JC       SHORT $+4   ; If an error occurred leave rc intact
           XOR      AX,AX       ; Set rc to zero

           POP      DI          ; Restore working ...
           POP      ES          ; ... registers.
           POP      SI          ; ...
           POP      DS          ; ...

           MOV      SP,BP       ; Restore stack
           POP      BP          ;

           RETF     12          ; Clean up 12 bytes of parameter pointers
DWNSETPATHINFO ENDP
_TEXT      ENDS
           END
