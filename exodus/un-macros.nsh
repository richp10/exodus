/*
    macros
*/
; These macros are needed until the NSIS Dev people fix the StrFunc.nsh so it can
; be included by the uninstaller (this damn stupid hack just doubles the code).
!define un.StrStrAdv "!insertmacro FUNCTION_STRING_un.StrStrAdv"
!define un.StrRep "!insertmacro FUNCTION_STRING_un.StrRep"

!macro FUNCTION_STRING_un.StrStrAdv
  !ifndef FUNCTION_STRING_un.StrStrAdv
    !echo "$\r$\n----------------------------------------------------------------------$\r$\nAdvanced Search in String Function - © 2003-2004 Diego Pedroso$\r$\n----------------------------------------------------------------------$\r$\n$\r$\n"
    !define FUNCTION_STRING_un.StrStrAdv
    !undef un.StrStrAdv
    !define un.StrStrAdv "!insertmacro FUNCTION_STRING_un.StrStrAdv_Call"
    Function un.AdvancedStrStr
     # Preparing Variables
     Exch $R9
     Exch
     Exch $R8
     Exch
     Exch 2
     Exch $R7
     Exch 2
     Exch 3
     Exch $R6
     Exch 3
     Exch 4
     Exch $R5
     Exch 4
     Exch 5
     Exch $R4
     Exch 5
     Push $R3
     Push $R2
     Push $R1
     Push $R0
     Push $9
     Push $8
     Push $7
     Push $6
     StrCpy $R2 $R4
     StrCpy $R1 $R5
     StrCpy $R4 ""
     StrCpy $R5 ""
     StrCpy $7 $R2

     # Detect Empty Input
     StrCmp $R1 "" 0 +3
       SetErrors
       Goto granddone

     StrCmp $R2 "" 0 +3
       SetErrors
       Goto granddone

     StrCmp $R6 "" 0 +2
       StrCpy $R6 >

     StrCmp $R7 "" 0 +2
       StrCpy $R7 >

     # Preparing StrStr
     StrCpy $R0 0
     IntCmp $R9 1 +2 0 +2
       StrCpy $R9 0

     IntOp $R9 $R9 + 1
     # Loops and more loops if you want...
       grandloop:
       # Detect if the loops number given by user = code runs...
       StrCpy $R4 0
       StrLen $R3 $R1
       StrCpy $6 $R3
       StrCmp $9 1 0 +4
         StrCmp $R6 "<" 0 +2
           IntOp $R3 $R3 + 1
           IntOp $R4 $R4 + 1

       StrCmp $R6 "<" 0 +5
         IntOp $R3 $R3 * -1
         StrCpy $6 $R3
         IntCmp $R0 0 +2 0 0
           IntOp $6 $6 + 1

       # Searching the string

         loop:

         # RTL...

         StrCmp $R6 "<" 0 EndBack

           IntOp $9 $R4 * -1

           StrCmp $9 0 0 +3
             StrCpy $R5 $R2 "" $R3
             Goto +2
           StrCpy $R5 $R2 $9 $R3
           Goto +2

         EndBack:

         # LTR...

         StrCpy $R5 $R2 $R3 $R4

         # Detect if the value returned is the searched...

         StrCmp $R5 $R1 done

         StrCmp $R5 "" granddone

             # If not, make a loop...

             IntOp $R4 $R4 + 1
             StrCmp $R6 "<" 0 +2
               IntOp $R3 $R3 - 1

         Goto loop

       done:

       StrCmp $R6 "<" 0 +3
         IntOp $8 $9 + $8
           Goto +2
       IntOp $8 $R4 + $8
       # Looping Calculation...
        IntOp $R0 $R0 + 1
       IntCmp $R0 $R9 0 continueloop 0
       # Customizing the string to fit user conditions (supported by loops)...
       # RTL...
         StrCmp $R6 "<" 0 EndBackward
           StrCmp $R7 ">" 0 +7
             StrCmp $8 0 0 +3
               StrCpy $R2 ""
               Goto +2
             StrCpy $R2 $7 "" $8
             StrCpy $R2 $R1$R2
             Goto +3

           StrCmp $9 0 +2
             StrCpy $R2 $R2 $9

           StrCmp $R8 1 EndForward 0
             StrCmp $R7 ">" 0 End>
               Push $6
               IntOp $6 $6 * -1
               StrCpy $R2 $R2 "" $6
               Pop $6
                 Goto +2
             End>:
             StrCpy $R2 $R2 $6
               Goto EndForward
         EndBackward:

         # LTR...

         StrCmp $R7 "<" 0 +4
           StrCpy $R2 $7 $8
           StrCpy $R2 $R2$R1
           Goto +2
         StrCpy $R2 $R2 "" $R4
         StrCmp $R8 1 EndForward 0
           StrCmp $R7 "<" 0 End<
             Push $6
             IntOp $6 $6 * 2
             StrCpy $R2 $R2 $6
             Pop $6
               Goto +2
           End<:
           StrCpy $R2 $R2 "" $R3
         EndForward:
         Goto stoploop
       continueloop:

       # Customizing the string to fits user conditions (not supported by loops)...
       # RTL...
       StrCmp $R6 "<" 0 +4
         StrCmp $9 0 +4
         StrCpy $R2 $R2 $9
           Goto +2

       # LTR...
       StrCpy $R2 $R2 "" $R4
       stoploop:
       # Return to grandloop init...
       StrCpy $9 1
       IntCmp $R0 $R9 0 grandloop 0
     StrCpy $R4 $R2
     Goto +2
     granddone:
     # Return the result to user
     StrCpy $R4 ""
     Pop $6
     Pop $7
     Pop $8
     Pop $9
     Pop $R0
     Pop $R1
     Pop $R2
     Pop $R3
     Pop $R9
     Pop $R8
     Pop $R7
     Pop $R6
     Pop $R5
     Exch $R4

    FunctionEnd

  !endif

!macroend

!macro FUNCTION_STRING_un.StrStrAdv_Call ResultVar String StrToSearchFor SearchDirection ResultStrDirection DisplayStrToSearch Loops

  !echo `$ {un.StrStrAdv} "${ResultVar}" "${String}" "${StrToSearchFor}" "${SearchDirection}" "${ResultStrDirection}" "${DisplayStrToSearch}" "${Loops}"$\r$\n`

  Push `${String}`
  Push `${StrToSearchFor}`
  Push `${SearchDirection}`
  Push `${ResultStrDirection}`
  Push `${DisplayStrToSearch}`
  Push `${Loops}`

  Call un.AdvancedStrStr

  Pop `${ResultVar}`

!macroend

!macro FUNCTION_STRING_un.StrRep

  !ifndef FUNCTION_STRING_un.StrRep

    !echo "$\r$\n----------------------------------------------------------------------$\r$\nReplace String Function - 2002-2004 Hendri Adriaens$\r$\n----------------------------------------------------------------------$\r$\n$\r$\n"

    !define FUNCTION_STRING_un.StrRep
    !undef un.StrRep
    !define un.StrRep "!insertmacro FUNCTION_STRING_un.StrRep_Call"

    Function un.StrReplace
      Exch $0 ;this will replace wrong characters
      Exch
      Exch $1 ;needs to be replaced
      Exch
      Exch 2
      Exch $2 ;the orginal string
      Push $3 ;counter
      Push $4 ;temp character
      Push $5 ;temp string
      Push $6 ;length of string that need to be replaced
      Push $7 ;length of string that will replace
      Push $R0 ;tempstring
      Push $R1 ;tempstring
      Push $R2 ;tempstring
      StrCpy $3 "-1"
      StrCpy $5 ""
      StrLen $6 $1
      StrLen $7 $0
      Loop:
      IntOp $3 $3 + 1
      StrCpy $4 $2 $6 $3
      StrCmp $4 "" ExitLoop
      StrCmp $4 $1 Replace
      Goto Loop
      Replace:
      StrCpy $R0 $2 $3
      IntOp $R2 $3 + $6
      StrCpy $R1 $2 "" $R2
      StrCpy $2 $R0$0$R1
      IntOp $3 $3 + $7
      Goto Loop
      ExitLoop:
      StrCpy $0 $2
      Pop $R2
      Pop $R1
      Pop $R0
      Pop $7
      Pop $6
      Pop $5
      Pop $4
      Pop $3
      Pop $2
      Pop $1
      Exch $0
    FunctionEnd

  !endif

!macroend

!macro FUNCTION_STRING_un.StrRep_Call ResultVar String StringToReplace ReplacementString
  !echo `$ {un.StrRep} "${ResultVar}" "${String}" "${StringToReplace}" "${ReplacementString}"$\r$\n`
  Push `${String}`
  Push `${StringToReplace}`
  Push `${ReplacementString}`
  Call un.StrReplace
  Pop `${ResultVar}`
!macroend

