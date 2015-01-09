; Subroutine to manipulate mutex semaphores from a VDM.
; Copyright (C) 1996, David W. Noon
           .286
           .287
;          OPTION   CASEMAP:ALL
           ASSUME   CS:_TEXT
_TEXT      SEGMENT  WORD READONLY PUBLIC USE16 'CODE'
; Create a mutex semaphore.
           PUBLIC   DWNCREATEMUTEXSEM
DWNCREATEMUTEXSEM PROC FAR PASCAL
           PUSH     BP          ; Stack housekeeping
           MOV      BP,SP       ;

           PUSH     DS          ; Save working ...
           PUSH     SI          ; ... registers.
           PUSH     ES          ; ...
           PUSH     DI          ; ...

           MOV      AH,64H              ;  Set up the parameter list:
           MOV      CX,636CH            ;     Magic number - see docs.
           MOV      BX,014BH            ;     Indicator for create mutex sem.
           LES      DI,DWORD PTR 14[BP] ;     Address of semaphore name
           LDS      SI,DWORD PTR 10[BP] ;     Address of semaphore handle (HMTX)
           MOV      DX,WORD PTR 8[BP]   ;     Attributes (1 = DC_SEM_SHARED)
           MOV      AL,BYTE PTR 6[BP]   ;     State (1 = owned)

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
DWNCREATEMUTEXSEM ENDP

; Open a mutex semaphore.
           PUBLIC   DWNOPENMUTEXSEM
DWNOPENMUTEXSEM PROC FAR PASCAL
           PUSH     BP          ; Stack housekeeping
           MOV      BP,SP       ;

           PUSH     DS          ; Save working ...
           PUSH     SI          ; ... registers.
           PUSH     ES          ; ...
           PUSH     DI          ; ...

           MOV      AH,64H              ;  Set up the parameter list:
           MOV      CX,636CH            ;     Magic number - see docs.
           MOV      BX,014CH            ;     Indicator for open mutex sem.
           LES      DI,DWORD PTR 10[BP] ;     Address of semaphore name
           LDS      SI,DWORD PTR 6[BP]  ;     Address of semaphore handle (HMTX)

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
DWNOPENMUTEXSEM ENDP

; Close a mutex semaphore.
           PUBLIC   DWNCLOSEMUTEXSEM
DWNCLOSEMUTEXSEM PROC FAR PASCAL
           PUSH     BP          ; Stack housekeeping
           MOV      BP,SP       ;

           PUSH     SI          ; Save working register.

           MOV      AH,64H            ;  Set up the parameter list:
           MOV      CX,636CH          ;     Magic number - see docs.
           MOV      BX,014DH          ;     Indicator for close mutex sem.
           MOV      SI,WORD PTR 6[BP] ;     Semaphore handle (HMTX)
           MOV      DX,WORD PTR 8[BP] ;       into DX:SI

           INT      21H         ; Issue the multiplex interrupt
           JC       SHORT $+4   ; Skip clearing AX if carry
           XOR      AX,AX       ; Return code zero if no error

           POP      SI          ; Restore working register.

           MOV      SP,BP       ; Restore stack
           POP      BP          ;

           RETF     4           ; Clean up 4 bytes of parameter
DWNCLOSEMUTEXSEM ENDP

; Request a mutex semaphore.
           PUBLIC   DWNREQUESTMUTEXSEM
DWNREQUESTMUTEXSEM PROC FAR PASCAL
           PUSH     BP          ; Stack housekeeping
           MOV      BP,SP       ;

           PUSH     SI          ; Save working register.

           MOV      AH,64H             ;  Set up the parameter list:
           MOV      CX,636CH           ;     Magic number - see docs.
           MOV      BX,014EH           ;     Indicator for request mutex sem.
           MOV      SI,WORD PTR 10[BP] ;     Semaphore handle (HMTX)
           MOV      DX,WORD PTR 12[BP] ;       into DX:SI
           MOV      AL,BYTE PTR 6[BP]  ;     Timeout value (was a long!)

           INT      21H         ; Issue the multiplex interrupt
           JC       SHORT $+4   ; Skip clearing AX if carry
           XOR      AX,AX       ; Return code zero if no error

           POP      SI          ; Restore working register.

           MOV      SP,BP       ; Restore stack
           POP      BP          ;

           RETF     8           ; Clean up 8 bytes of parameter
DWNREQUESTMUTEXSEM ENDP

; Release a mutex semaphore.
           PUBLIC   DWNRELEASEMUTEXSEM
DWNRELEASEMUTEXSEM PROC FAR PASCAL
           PUSH     BP          ; Stack housekeeping
           MOV      BP,SP       ;

           PUSH     SI          ; Save working register.

           MOV      AH,64H            ;  Set up the parameter list:
           MOV      CX,636CH          ;     Magic number - see docs.
           MOV      BX,014FH          ;     Indicator for release mutex sem.
           MOV      SI,WORD PTR 6[BP] ;     Semaphore handle (HMTX)
           MOV      DX,WORD PTR 8[BP] ;       into DX:SI

           INT      21H         ; Issue the multiplex interrupt
           JC       SHORT $+4   ; Skip clearing AX if carry
           XOR      AX,AX       ; Return code zero if no error

           POP      SI          ; Restore working register.

           MOV      SP,BP       ; Restore stack
           POP      BP          ;

           RETF     4           ; Clean up 4 bytes of parameter
DWNRELEASEMUTEXSEM ENDP
_TEXT      ENDS
           END
