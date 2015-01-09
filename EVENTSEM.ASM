; Subroutine to manipulate event semaphores from a VDM.
; Copyright (C) 1996, David W. Noon
           .286
           .287
;          OPTION   CASEMAP:ALL
           ASSUME   CS:_TEXT
_TEXT      SEGMENT  WORD READONLY PUBLIC USE16 'CODE'
; Create an event semaphore.
           PUBLIC   DWNCREATEEVENTSEM
DWNCREATEEVENTSEM PROC FAR PASCAL
           PUSH     BP          ; Stack housekeeping
           MOV      BP,SP       ;

           PUSH     DS          ; Save working ...
           PUSH     SI          ; ... registers.
           PUSH     ES          ; ...
           PUSH     DI          ; ...

           MOV      AH,64H              ;  Set up the parameter list:
           MOV      CX,636CH            ;     Magic number - see docs.
           MOV      BX,0144H            ;     Indicator for create event sem.
           LES      DI,DWORD PTR 14[BP] ;     Address of semaphore name
           LDS      SI,DWORD PTR 10[BP] ;     Address of semaphore handle (HEV)
           MOV      DX,WORD PTR 8[BP]   ;     Attributes (1 = DC_SEM_SHARED)
           MOV      AL,BYTE PTR 6[BP]   ;     State (1 = posted)

           INT      21H         ; Issue the multiplex interrupt
           JC       SHORT $+4   ; Skip clearing AX if carry
           XOR      AX,AX       ; Return code zero if no error

           POP      DI          ; Restore working ...
           POP      ES          ; ... registers.
           POP      SI          ; ...
           POP      DS          ; ...

           MOV      SP,BP       ; Restore stack
           POP      BP          ;

           RETF     12          ; Clean up 12 bytes of parameter pointers
DWNCREATEEVENTSEM ENDP

; Open an event semaphore.
           PUBLIC   DWNOPENEVENTSEM
DWNOPENEVENTSEM PROC FAR PASCAL
           PUSH     BP          ; Stack housekeeping
           MOV      BP,SP       ;

           PUSH     DS          ; Save working ...
           PUSH     SI          ; ... registers.
           PUSH     ES          ; ...
           PUSH     DI          ; ...

           MOV      AH,64H              ;  Set up the parameter list:
           MOV      CX,636CH            ;     Magic number - see docs.
           MOV      BX,0145H            ;     Indicator for open event sem.
           LES      DI,DWORD PTR 10[BP] ;     Address of semaphore name
           LDS      SI,DWORD PTR 6[BP]  ;     Address of semaphore handle (HEV)

           INT      21H         ; Issue the multiplex interrupt
           JC       SHORT $+4   ; Skip clearing AX if carry
           XOR      AX,AX       ; Return code zero if no error

           POP      DI          ; Restore working ...
           POP      ES          ; ... registers.
           POP      SI          ; ...
           POP      DS          ; ...

           MOV      SP,BP       ; Restore stack
           POP      BP          ;

           RETF     8           ; Clean up 8 bytes of parameter pointers
DWNOPENEVENTSEM ENDP

; Close an event semaphore.
           PUBLIC   DWNCLOSEEVENTSEM
DWNCLOSEEVENTSEM PROC FAR PASCAL
           PUSH     BP          ; Stack housekeeping
           MOV      BP,SP       ;

           PUSH     SI          ; Save working register.

           MOV      AH,64H            ;  Set up the parameter list:
           MOV      CX,636CH          ;     Magic number - see docs.
           MOV      BX,0146H          ;     Indicator for close event sem.
           MOV      SI,WORD PTR 6[BP] ;     Semaphore handle (HEV)
           MOV      DX,WORD PTR 8[BP] ;       into DX:SI

           INT      21H         ; Issue the multiplex interrupt
           JC       SHORT $+4   ; Skip clearing AX if carry
           XOR      AX,AX       ; Return code zero if no error

           POP      SI          ; Restore working register.

           MOV      SP,BP       ; Restore stack
           POP      BP          ;

           RETF     4           ; Clean up 4 bytes of parameter
DWNCLOSEEVENTSEM ENDP

; Reset an event semaphore.
           PUBLIC   DWNRESETEVENTSEM
DWNRESETEVENTSEM PROC FAR PASCAL
           PUSH     BP          ; Stack housekeeping
           MOV      BP,SP       ;

           PUSH     SI          ; Save working register.

           MOV      AH,64H             ;  Set up the parameter list:
           MOV      CX,636CH           ;     Magic number - see docs.
           MOV      BX,0147H           ;     Indicator for reset event sem.
           MOV      SI,WORD PTR 10[BP] ;     Semaphore handle (HEV)
           MOV      DX,WORD PTR 12[BP] ;       into DX:SI
           LES      DI,DWORD PTR 6[BP] ;     Address of post count

           INT      21H         ; Issue the multiplex interrupt
           JC       SHORT $+4   ; Skip clearing AX if carry
           XOR      AX,AX       ; Return code zero if no error

           POP      SI          ; Restore working register.

           MOV      SP,BP       ; Restore stack
           POP      BP          ;

           RETF     8           ; Clean up 8 bytes of parameter
DWNRESETEVENTSEM ENDP

; Post an event semaphore.
           PUBLIC   DWNPOSTEVENTSEM
DWNPOSTEVENTSEM PROC FAR PASCAL
           PUSH     BP          ; Stack housekeeping
           MOV      BP,SP       ;

           PUSH     SI          ; Save working register.

           MOV      AH,64H            ;  Set up the parameter list:
           MOV      CX,636CH          ;     Magic number - see docs.
           MOV      BX,0148H          ;     Indicator for post event sem.
           MOV      SI,WORD PTR 6[BP] ;     Semaphore handle (HEV)
           MOV      DX,WORD PTR 8[BP] ;       into DX:SI

           INT      21H         ; Issue the multiplex interrupt
           JC       SHORT $+4   ; Skip clearing AX if carry
           XOR      AX,AX       ; Return code zero if no error

           POP      SI          ; Restore working register.

           MOV      SP,BP       ; Restore stack
           POP      BP          ;

           RETF     4           ; Clean up 4 bytes of parameter
DWNPOSTEVENTSEM ENDP

; Wait an event semaphore.
           PUBLIC   DWNWAITEVENTSEM
DWNWAITEVENTSEM PROC FAR PASCAL
           PUSH     BP          ; Stack housekeeping
           MOV      BP,SP       ;

           PUSH     SI          ; Save working register.

           MOV      AH,64H             ;  Set up the parameter list:
           MOV      CX,636CH           ;     Magic number - see docs.
           MOV      BX,0149H           ;     Indicator for wait event sem.
           MOV      SI,WORD PTR 10[BP] ;     Semaphore handle (HEV)
           MOV      DX,WORD PTR 12[BP] ;       into DX:SI
           MOV      AL,BYTE PTR 6[BP]  ;     Timeout value (was a long!)

           INT      21H         ; Issue the multiplex interrupt
           JC       SHORT $+4   ; Skip clearing AX if carry
           XOR      AX,AX       ; Return code zero if no error

           POP      SI          ; Restore working register.

           MOV      SP,BP       ; Restore stack
           POP      BP          ;

           RETF     8           ; Clean up 8 bytes of parameters
DWNWAITEVENTSEM ENDP

; Query an event semaphore.
           PUBLIC   DWNQUERYEVENTSEM
DWNQUERYEVENTSEM PROC FAR PASCAL
           PUSH     BP          ; Stack housekeeping
           MOV      BP,SP       ;

           PUSH     ES          ; Save working ...
           PUSH     DI          ; ... registers.
           PUSH     SI          ;

           MOV      AH,64H             ;  Set up the parameter list:
           MOV      CX,636CH           ;     Magic number - see docs.
           MOV      BX,014AH           ;     Indicator for query event sem.
           MOV      SI,WORD PTR 10[BP] ;     Semaphore handle (HEV)
           MOV      DX,WORD PTR 12[BP] ;       into DX:SI
           LES      DI,DWORD PTR 6[BP] ;     Address of post count ULONG

           INT      21H         ; Issue the multiplex interrupt
           JC       SHORT $+4   ; Skip clearing AX if carry
           XOR      AX,AX       ; Return code zero if no error

           POP      SI          ; Restore working ...
           POP      DI          ; ... registers.
           POP      ES          ;

           MOV      SP,BP       ; Restore stack
           POP      BP          ;

           RETF     8           ; Clean up 8 bytes of parameters
DWNQUERYEVENTSEM ENDP
_TEXT      ENDS
           END
