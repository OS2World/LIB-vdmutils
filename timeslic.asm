; Subroutine to release a timeslice from VDM or VMB session.
; Copyright (C) 1996, David W. Noon
           .286
           .287
;          OPTION   CASEMAP:ALL
           ASSUME   CS:_TEXT
_TEXT      SEGMENT  WORD READONLY PUBLIC 'CODE'
           PUBLIC   DWNRELEASETIMESLICE
DWNRELEASETIMESLICE PROC FAR PASCAL
           MOV      AX,1680H
           INT      2FH
           RETF     0
DWNRELEASETIMESLICE ENDP
_TEXT      ENDS
           END
