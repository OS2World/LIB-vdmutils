The VDMUTILS.LIB is a library of functions that can be called from a number
of programming languages, to access some of the base API's of OS/2. As a
result, these can only be used in a VDM session (although some might work in
a VMB session) under OS/2.

All of the functions supplied herein invoke Dos...() API calls via INT
instructions. To avoid name conflicts with any IBM code, I have replaced the
Dos...() prefix with my initials, so these functions are named Dwn...(). For
complete documentation of each look in the appropriate part of the OS/2
Devloper's Toolkit doc (Control Program Reference).

Most of these API's are actually 32-bit, and so the 2.x (or later) releases
of the Toolkit should be used. However, the Extended Attribute routines appear
to be the 16-bit entry points, so PRCP.INF from the OS/2 Developer's Toolkit 1.3
is where to look for the doc on those functions.

The assembler I used most for developing these subroutines was WASM, the Watcom
assembler. I also used TASM (for DOS) 3.1 and MASM 6.11. The only syntax that
caused any problem was OPTION CASEMAP:ALL, which was supported only by MASM. As
a result, I commented out that line and mapped the public symbols to upper case
by hand, to conform with the Pascal calling convention.

You can obtain technical support and offer suggestions on these functions from
me at the following locations:
      Compuserve: 72172,431
      Fidonet:    David Noon 2:440/4
      Internent:  david_noon@donor2.demon.co.uk
                  dwnoon@ibm.net
Of the above, the Fidonet address and the first Internet address (they are
actually the same place) receive the most frequent attention.

No warranty is given with this free software. Any damage you cause by using it
is your responsibility. If it breaks, you own all the pieces.

David W. Noon
4 March 1997
