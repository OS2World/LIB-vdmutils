/* Library of functions that can be called only from within an
   an OS/2 Virtual DOS Machine (VDM). These generate in-line
   assembler under Watcom C/C++. For any other C/C++ compiler
   the external library VDMUTILS.LIB is used for external
   subroutines at link time.

   Copyright (C) 1996, David W. Noon */

#ifndef VDM_UTILS_INCLUDED
#define VDM_UTILS_INCLUDED

#ifndef __DOS__
#error "The VDMUTILS library is only applicable to DOS programs."
#endif

#ifdef __WATCOMC__
   #ifdef __386__
      #define FAR __far16
   #else
      #define FAR far
   #endif
   #define VDM_LINKAGE
#else
   #define FAR far
   #define VDM_LINKAGE far _pascal
#endif

#ifdef __cplusplus
extern "C" {
#endif

#ifndef USHORT
typedef unsigned short USHORT;
typedef USHORT FAR *PUSHORT;
#endif

#ifndef ULONG
typedef unsigned long ULONG;
typedef ULONG FAR *PULONG;
#endif

#ifndef BYTE
typedef unsigned char BYTE;
typedef BYTE FAR *PBYTE;
#endif

#ifndef CHAR
typedef unsigned char CHAR;
typedef CHAR FAR *PCHAR;
#endif

#ifndef PCSZ
typedef const unsigned char FAR *PCSZ;
#endif

#ifndef PVOID
typedef void FAR *PVOID;
#endif

#ifndef HFILE
typedef unsigned short HFILE;
#endif

/* The following typedefs have been liberally plagiarised from the
   OS/2 Developer's Toolkit 1.3 documentation. */

typedef struct _FDATE {    /* fdate */
   unsigned day   : 5;     /* binary day for directory entry */
   unsigned month : 4;     /* binary month for directory entry */
   unsigned year  : 7;     /* binary year for directory entry */
 } FDATE;

typedef FDATE FAR *PFDATE;

typedef struct _FTIME {        /* ftime */
   unsigned twosecs : 5;       /* binary number of two-second increments */
   unsigned minutes : 6;       /* binary number of minutes */
   unsigned hours   : 5;       /* binary number of hours */
 } FTIME;

typedef FTIME FAR *PFTIME;

typedef struct _FILESTATUS {    /* fsts */
   FDATE  fdateCreation;        /* date of file creation */
   FTIME  ftimeCreation;        /* time of file creation */
   FDATE  fdateLastAccess;      /* date of last access */
   FTIME  ftimeLastAccess;      /* time of last access */
   FDATE  fdateLastWrite;       /* date of last write */
   FTIME  ftimeLastWrite;       /* time of last write */
   ULONG  cbFile;               /* file size (end of data) */
   ULONG  cbFileAlloc;          /* file allocated size */
   USHORT attrFile;             /* attributes of the file */
 } FILESTATUS;

typedef FILESTATUS FAR *PFILESTATUS;

typedef struct _GEA {       /* gea */
   BYTE cbName;             /* name length not including NULL */
   CHAR szName[1];          /* attribute name */
 } GEA;

typedef GEA FAR *PGEA;

typedef struct _GEALIST {   /* geal */
   ULONG  cbList;           /* total bytes of structure including full list */
   GEA list[1];             /* variable length GEA structures */
 } GEALIST;

typedef GEALIST FAR *PGEALIST;

typedef struct _FEA {       /* fea */
   BYTE fEA;                /* flags */
   BYTE cbName;             /* name length not including NULL */
   USHORT cbValue;          /* value length */
   CHAR szName[1];          /* attribute name */
/* CHAR aValue[1];          ** attribute value -- offset varies with cbName */
 } FEA;

typedef FEA FAR *PFEA;

typedef struct _FEALIST {   /* feal */
   ULONG  cbList;           /* total bytes of structure including full list */
   FEA list[1];             /* variable length FEA structures */
 } FEALIST;

typedef FEALIST FAR *PFEALIST;

typedef struct _EAOP {      /* eaop */
   PGEALIST fpGEAList;      /* general EA list */
   PFEALIST fpFEAList;      /* full EA list */
   ULONG  oError;
 } EAOP;

typedef EAOP FAR *PEAOP;

/* Levels of information queried or set by file system. */
#define FIL_STANDARD          1U
#define FIL_QUERYEASIZE       2U
#define FIL_QUERYEASFROMLIST  3U
#define FIL_QUERYFULLNAME     5U

void VDM_LINKAGE DwnExitVDM(void);
#ifdef __WATCOMC__
#pragma aux DwnExitVDM = "STI"         \
                         "XOR AX,AX"   \
                         "HLT"         \
                         "DB  02H,0FDH";
#endif

void VDM_LINKAGE DwnReleaseTimeSlice(void);
#ifdef __WATCOMC__
#pragma aux DwnReleaseTimeSlice = "MOV   AX,1680H" \
                         "INT   2FH"               \
                         modify [ax];
#endif

void VDM_LINKAGE DwnSetSessionTitle(PCSZ Session_title);
#ifdef __WATCOMC__
#pragma aux DwnSetSessionTitle = "MOV   AX,6400H" \
                         "XOR   BX,BX"            \
                         "MOV   CX,636CH"         \
                         "MOV   DX,1"             \
                         "INT   21H"              \
                         parm [es di]             \
                         modify [ax bx cx dx];
#endif

void VDM_LINKAGE DwnQuerySessionTitle(PCSZ Session_title);
#ifdef __WATCOMC__
#pragma aux DwnQuerySessionTitle = "MOV   AX,6400H" \
                         "XOR   BX,BX"              \
                         "MOV   CX,636CH"           \
                         "MOV   DX,2"               \
                         "INT   21H"                \
                         parm [es di]               \
                         modify [ax bx cx dx];
#endif

USHORT VDM_LINKAGE DwnQFileInfo(HFILE FileHandle, USHORT FileInfoLevel, PVOID FileInfoBuf, USHORT FileInfoBufSize);
#ifdef __WATCOMC__
#pragma aux DwnQFileInfo = "MOV   AX,5702H"          \
                         "INT   21H"                 \
                         "JC    SHORT 2"             \
                         "XOR   AX,AX"               \
                         parm [bx] [dx] [es di] [cx] \
                         value [ax]                  \
                         modify [ax];
#endif

USHORT VDM_LINKAGE DwnQPathInfo(PCSZ PathName, USHORT PathInfoLevel, PVOID PathInfoBuf, USHORT PathInfoBufSize);
#ifdef __WATCOMC__
#pragma aux DwnQPathInfo = "MOV   AX,5702H"             \
                         "MOV   BX,0FFFFH"              \
                         "INT   21H"                    \
                         "JC    SHORT 2"                \
                         "XOR   AX,AX"                  \
                         parm [ds si] [dx] [es di] [cx] \
                         value [ax]                     \
                         modify [ax bx];
#endif

USHORT VDM_LINKAGE DwnSetFileInfo(HFILE FileHandle, USHORT FileInfoLevel, PVOID FileInfoBuf, USHORT FileInfoBufSize);
#ifdef __WATCOMC__
#pragma aux DwnSetFileInfo = "MOV   AX,5703H"        \
                         "INT   21H"                 \
                         "JC    SHORT 2"             \
                         "XOR   AX,AX"               \
                         parm [bx] [dx] [es di] [cx] \
                         value [ax]                  \
                         modify [ax];
#endif

USHORT VDM_LINKAGE DwnSetPathInfo(PCSZ PathName, USHORT PathInfoLevel, PVOID PathInfoBuf, USHORT PathInfoBufSize);
#ifdef __WATCOMC__
#pragma aux DwnSetPathInfo = "MOV   AX,5703H"           \
                         "MOV   BX,0FFFFH"              \
                         "INT   21H"                    \
                         "JC    SHORT 2"                \
                         "XOR   AX,AX"                  \
                         parm [ds si] [dx] [es di] [cx] \
                         value [ax]                     \
                         modify [ax bx];
#endif

typedef unsigned short SHANDLE;
#define NULLSHANDLE 0U
typedef unsigned long LHANDLE;
#define NULLHANDLE 0UL

#ifdef INCL_DOSSEMAPHORES

typedef LHANDLE HEV;
typedef HEV FAR *PHEV;

typedef LHANDLE HMTX;
typedef HMTX FAR *PHMTX;

typedef LHANDLE HMUX;
typedef HMUX FAR *PHMUX;

typedef LHANDLE PID;
typedef PID FAR *PPID;

typedef LHANDLE TID;
typedef TID FAR *PTID;

#define DC_SEM_SHARED            1U
#define DCMW_WAIT_ANY          0x02
#define DCMW_WAIT_ALL          0x04
#define SEM_INDEFINITE_WAIT     -1L
#define SEM_IMMEDIATE_RETURN     0L

USHORT VDM_LINKAGE DwnCreateEventSem(PCSZ SemName, PHEV SemHandle, USHORT Attr, USHORT State);
#ifdef __WATCOMC__
#pragma aux DwnCreateEventSem = "MOV   AH,64H"          \
                         "MOV   BX,0144H"               \
                         "MOV   CX,636CH"               \
                         "INT   21H"                    \
                         "JC    SHORT 2"                \
                         "XOR   AX,AX"                  \
                         parm [es di] [ds si] [dx] [al] \
                         value [ax]                     \
                         modify [ax bx cx];
#endif

USHORT VDM_LINKAGE DwnOpenEventSem(PCSZ SemName, PHEV SemHandle);
#ifdef __WATCOMC__
#pragma aux DwnOpenEventSem = "MOV   AH,64H"            \
                         "MOV   BX,0145H"               \
                         "MOV   CX,636CH"               \
                         "INT   21H"                    \
                         "JC    SHORT 2"                \
                         "XOR   AX,AX"                  \
                         parm [es di] [ds si]           \
                         value [ax]                     \
                         modify [ax bx cx];
#endif

USHORT VDM_LINKAGE DwnCloseEventSem(HEV SemHandle);
#ifdef __WATCOMC__
#pragma aux DwnCloseEventSem = "MOV   AH,64H"           \
                         "MOV   BX,0146H"               \
                         "MOV   CX,636CH"               \
                         "INT   21H"                    \
                         "JC    SHORT 2"                \
                         "XOR   AX,AX"                  \
                         parm [dx si]                   \
                         value [ax]                     \
                         modify [ax bx cx];
#endif

USHORT VDM_LINKAGE DwnResetEventSem(HEV SemHandle, PULONG PostCount);
#ifdef __WATCOMC__
#pragma aux DwnResetEventSem = "MOV   AH,64H"           \
                         "MOV   BX,0147H"               \
                         "MOV   CX,636CH"               \
                         "INT   21H"                    \
                         "JC    SHORT 2"                \
                         "XOR   AX,AX"                  \
                         parm [dx si] [es di]           \
                         value [ax]                     \
                         modify [ax bx cx];
#endif

USHORT VDM_LINKAGE DwnPostEventSem(HEV SemHandle);
#ifdef __WATCOMC__
#pragma aux DwnPostEventSem = "MOV   AH,64H"            \
                         "MOV   BX,0148H"               \
                         "MOV   CX,636CH"               \
                         "INT   21H"                    \
                         "JC    SHORT 2"                \
                         "XOR   AX,AX"                  \
                         parm [dx si]                   \
                         value [ax]                     \
                         modify [ax bx cx];
#endif

USHORT VDM_LINKAGE DwnWaitEventSem(HEV SemHandle, long Timeout);
#ifdef __WATCOMC__
#pragma aux DwnWaitEventSem = "MOV   AH,64H"            \
                         "MOV   BX,0149H"               \
                         "MOV   CX,636CH"               \
                         "INT   21H"                    \
                         "JC    SHORT 2"                \
                         "XOR   AX,AX"                  \
                         parm [dx si] [al]              \
                         value [ax]                     \
                         modify [ax bx cx];
#endif

USHORT VDM_LINKAGE DwnQueryEventSem(HEV SemHandle, PULONG PostCount);
#ifdef __WATCOMC__
#pragma aux DwnQueryEventSem = "MOV   AH,64H"           \
                         "MOV   BX,014AH"               \
                         "MOV   CX,636CH"               \
                         "INT   21H"                    \
                         "JC    SHORT 2"                \
                         "XOR   AX,AX"                  \
                         parm [dx si] [es di]           \
                         value [ax]                     \
                         modify [ax bx cx];
#endif

USHORT VDM_LINKAGE DwnCreateMutexSem(PCSZ SemName, PHMTX SemHandle, USHORT Attr, USHORT State);
#ifdef __WATCOMC__
#pragma aux DwnCreateMutexSem = "MOV   AH,64H"          \
                         "MOV   BX,014BH"               \
                         "MOV   CX,636CH"               \
                         "INT   21H"                    \
                         "JC    SHORT 2"                \
                         "XOR   AX,AX"                  \
                         parm [es di] [ds si] [dx] [al] \
                         value [ax]                     \
                         modify [ax bx cx];
#endif

USHORT VDM_LINKAGE DwnOpenMutexSem(PCSZ SemName, PHMTX SemHandle);
#ifdef __WATCOMC__
#pragma aux DwnOpenMutexSem = "MOV   AH,64H"            \
                         "MOV   BX,014CH"               \
                         "MOV   CX,636CH"               \
                         "INT   21H"                    \
                         "JC    SHORT 2"                \
                         "XOR   AX,AX"                  \
                         parm [es di] [ds si]           \
                         value [ax]                     \
                         modify [ax bx cx];
#endif

USHORT VDM_LINKAGE DwnCloseMutexSem(HMTX SemHandle);
#ifdef __WATCOMC__
#pragma aux DwnCloseMutexSem = "MOV   AH,64H"           \
                         "MOV   BX,014DH"               \
                         "MOV   CX,636CH"               \
                         "INT   21H"                    \
                         "JC    SHORT 2"                \
                         "XOR   AX,AX"                  \
                         parm [dx si]                   \
                         value [ax]                     \
                         modify [ax bx cx];
#endif

USHORT VDM_LINKAGE DwnRequestMutexSem(HMTX SemHandle, long TimeOut);
#ifdef __WATCOMC__
#pragma aux DwnRequestMutexSem = "MOV   AH,64H"         \
                         "MOV   BX,014EH"               \
                         "MOV   CX,636CH"               \
                         "INT   21H"                    \
                         "JC    SHORT 2"                \
                         "XOR   AX,AX"                  \
                         parm [dx si] [al]              \
                         value [ax]                     \
                         modify [ax bx cx];
#endif

USHORT VDM_LINKAGE DwnReleaseMutexSem(HMTX SemHandle);
#ifdef __WATCOMC__
#pragma aux DwnReleaseMutexSem = "MOV   AH,64H"         \
                         "MOV   BX,014FH"               \
                         "MOV   CX,636CH"               \
                         "INT   21H"                    \
                         "JC    SHORT 2"                \
                         "XOR   AX,AX"                  \
                         parm [dx si]                   \
                         value [ax]                     \
                         modify [ax bx cx];
#endif

/* Dos32QueryMutex() isn't supported at the moment, courtesy of IBM.
USHORT VDM_LINKAGE DwnQueryMutexSem(HMTX SemHandle, PPID OwnerProcess, PTID OwnerThread, PULONG RequestCount);
*/
#endif  /* INCL_DOSSEMAPHORES */

#ifdef __cplusplus
     } /* extern "C" */
#endif

#endif /* VDM_UTILS_INCLUDED */
