; Subroutine to query the title bar text of a VDM session.
; Copyright (C) 1996, David W. Noon
           .286
           .287
;          OPTION   CASEMAP:ALL
           ASSUME   CS:_TEXT
_TEXT      SEGMENT  WORD READONLY PUBLIC 'CODE'
           PUBLIC   DWNQUERYSESSIONTITLE
DWNQUERYSESSIONTITLE PROC FAR PASCAL
           PUSH     BP          ; Stack housekeeping
           MOV      BP,SP       ;

           PUSH     ES          ; Save working ...
           PUSH     DI          ; ... registers.

           MOV      AX,6400H    ;  Set up ...
           XOR      BX,BX       ;  ... the parameter list ...
           MOV      CX,636CH    ;  ... for querying the ...
           MOV      DX,2H       ;  ... title bar's text.

           LES      DI,6[BP]    ; Address of buffer area

           INT      21H         ; Issue the multiplex interrupt

           POP      DI          ; Restore working ...
           POP      ES          ; ... registers.

           MOV      SP,BP       ; Restore stack
           POP      BP          ;

           RETF     4           ; Clean up 4 bytes of parameter pointer
DWNQUERYSESSIONTITLE ENDP
_TEXT      ENDS
           END
