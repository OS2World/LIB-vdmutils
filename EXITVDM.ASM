; Subroutine to close a VDM or VMB session.
; Copyright (C) 1996, David W. Noon
           .286
           .287
;          OPTION   CASEMAP:ALL
           ASSUME   CS:_TEXT
_TEXT      SEGMENT  WORD READONLY PUBLIC 'CODE'
           PUBLIC   DWNEXITVDM
DWNEXITVDM PROC     FAR PASCAL
           STI
           XOR      AX,AX
           HLT
           DB       02H,0FDH
DWNEXITVDM ENDP
_TEXT      ENDS
           END
