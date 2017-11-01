/*
================================================================================
functions
================================================================================
*/
Function .onInit
    ;Call funcMigrateToHKLM
    Call funcSectionSetInInst
FunctionEnd

Function TurnOff
/*
    Exch $0
    Push $1
    SectionGetFlags $0 $1
    IntOp $1 $1 & ${SECTION_OFF}
    SectionSetFlags $0 $1
    Pop $1
*/
FunctionEnd

Function funcMigrateToHKLM
!ifdef USE_HKLM_KEY
    ; Installer language key
    ClearErrors
    ReadRegStr "$0" HKCU "${PRODUCT_REGISTRY_KEY}" "${INSTALLER_LANGUAGE_KEY}"
    StrCmp "$0" "" +3
        WriteRegStr HKLM "${PRODUCT_REGISTRY_KEY}" "${INSTALLER_LANGUAGE_KEY}" "$0"
        DeleteRegValue HKCU "${PRODUCT_REGISTRY_KEY}" "${INSTALLER_LANGUAGE_KEY}"
    ; Install path key
    ClearErrors
    ReadRegStr "$0" HKCU "${PRODUCT_REGISTRY_KEY}" "${PRODUCT_INSTALL_PATH_KEY}"
    StrCmp "$0" "" +3
        WriteRegStr HKLM "${PRODUCT_REGISTRY_KEY}" "${PRODUCT_INSTALL_PATH_KEY}" "$0"
        DeleteRegValue HKCU "${PRODUCT_REGISTRY_KEY}" "${PRODUCT_INSTALL_PATH_KEY}"
    ; Product run key
    ClearErrors
    ReadRegStr "$0" HKCU "${PRODUCT_RUN_KEY}" "${PRODUCT}"
    StrCmp "$0" "" +3
        WriteRegStr HKLM "${PRODUCT_RUN_KEY}" "${PRODUCT}" "$0"
        DeleteRegValue HKCU "${PRODUCT_RUN_KEY}" "${PRODUCT}"
    ; Product locales key
    ClearErrors
    ReadRegStr "$0" HKCU "${PRODUCT_REGISTRY_KEY}" "${PRODUCT_LOCALES_KEY}"
    StrCmp "$0" "" +3
        WriteRegStr HKLM "${PRODUCT_REGISTRY_KEY}" "${PRODUCT_LOCALES_KEY}" "$0"
        DeleteRegValue HKCU "${PRODUCT_REGISTRY_KEY}" "${PRODUCT_LOCALES_KEY}"
    ; Product Start Menu key
    ClearErrors
    ReadRegStr "$0" HKCU "${PRODUCT_REGISTRY_KEY}" "${INSTALLER_STARTMENU_KEY}"
    StrCmp "$0" "" +3
        WriteRegStr HKLM "${PRODUCT_REGISTRY_KEY}" "${INSTALLER_STARTMENU_KEY}" "$0"
        DeleteRegValue HKCU "${PRODUCT_REGISTRY_KEY}" "${INSTALLER_STARTMENU_KEY}"
    ; Move the shortcuts
    SetShellVarContext current
    StrCmp "$0" "" +19
    ClearErrors
    FindFirst "$R0" "$R1" "$SMPROGRAMS\$0\${PRODUCT}${LINK_EXTENSION}"
    IfErrors +3
        StrCpy "$1" "1" ; Start Menu Exodus link
        Delete "$SMPROGRAMS\$0\${PRODUCT}${LINK_EXTENSION}"
    FindClose "$R0"
    ClearErrors
    FindFirst "$R0" "$R1" "$SMPROGRAMS\$0\${PRODUCT_UNINSTALLER}${LINK_EXTENSION}"
    IfErrors +3
        StrCpy "$2" "1" ; Uninstall link
        Delete "$SMPROGRAMS\$0\${PRODUCT_UNINSTALLER}${LINK_EXTENSION}"
    FindClose "$R0"
    ClearErrors
    FindFirst "$R0" "$R1" "$SMPROGRAMS\$0\${PRODUCT} ${HOMEPAGE}${LINK_EXTENSION}"
    IfErrors +3
        StrCpy "$3" "1" ; Exodus Homepage link
        Delete "$SMPROGRAMS\$0\${PRODUCT} ${HOMEPAGE}${LINK_EXTENSION}"
    FindClose "$R0"
    ClearErrors
    FindFirst "$R0" "$R1" "$DESKTOP\${PRODUCT}${LINK_EXTENSION}"
    IfErrors +3
        StrCpy "$4" "1" ; Desktop Exodus link
        Delete "$DESKTOP\${PRODUCT}${LINK_EXTENSION}"
    FindClose "$R0"
    ClearErrors
    FindFirst "$R0" "$R1" "$QUICKLAUNCH\${PRODUCT}${LINK_EXTENSION}"
    IfErrors +3
        StrCpy "$5" "1" ; Quick Launch Exodus link
        Delete "$QUICKLAUNCH\${PRODUCT}${LINK_EXTENSION}"
    FindClose "$R0"
    SetShellVarContext all
    ReadRegStr "$R0" HKLM "${PRODUCT_REGISTRY_KEY}" "${PRODUCT_INSTALL_PATH_KEY}"
    IntCmpU '$1' '1' 0 +2 +2
        CreateShortcut "$SMPROGRAMS\$0\${PRODUCT}${LINK_EXTENSION}" "$R0\${PRODUCT}${EXEC_EXTENSION}"
    IntCmpU '$2' '1' 0 +2 +2
        CreateShortcut "$SMPROGRAMS\$0\${PRODUCT_UNINSTALLER}${LINK_EXTENSION}" "$R0\${PRODUCT_UNINSTALLER}${EXEC_EXTENSION}"
    IntCmpU '$3' '1' 0 +2 +2
        CreateShortcut "$SMPROGRAMS\$0\${PRODUCT} ${HOMEPAGE}${LINK_EXTENSION}" "${HOME_URL}"
    IntCmpU '$4' '1' 0 +2 +2
        CreateShortcut "$DESKTOP\${PRODUCT}${LINK_EXTENSION}" "$R0\${PRODUCT}${EXEC_EXTENSION}"
    IntCmpU '$5' '1' 0 +2 +2
        CreateShortcut "$QUICKLAUNCH\${PRODUCT}${LINK_EXTENSION}" "$R0\${PRODUCT}${EXEC_EXTENSION}"
    ; Wrap and remove old empty keys (only if the keys are empty,
    ; so user preferences files won't be moved away)
    DeleteRegKey /ifempty HKCU "${PRODUCT_RESTART_KEY}"
    DeleteRegKey /ifempty HKCU "${PRODUCT_REGISTRY_KEY}"
    ClearErrors
!endif
FunctionEnd

Function funcSectionSetInInst
    ; BRANDING: To turn off bleeding edge updates,
    ; Comment out the following line.
    ;!insertmacro UnselectSection "${SEC_Bleed}"

    /* Install locales if they were and this one is silent */
    Push "${INSTALLER_SWITCH_SILENT}"
    Call funcGetConfigParam
    Pop $0
    IntCmpU '$0' '1' silent
    !ifdef USE_HKLM_KEY
        DeleteRegValue HKLM "${PRODUCT_REGISTRY_KEY}" "${PRODUCT_LOCALES_KEY}"
    !else
        DeleteRegValue HKCU "${PRODUCT_REGISTRY_KEY}" "${PRODUCT_LOCALES_KEY}"
    !endif
    goto locale_done

  silent:
    !ifdef USE_HKLM_KEY
        ReadRegStr "$0" HKLM "${PRODUCT_REGISTRY_KEY}" "${PRODUCT_LOCALES_KEY}"
    !else
        ReadRegStr "$0" HKCU "${PRODUCT_REGISTRY_KEY}" "${PRODUCT_LOCALES_KEY}"
    !endif
    IntCmpU '$0' '1' locale_done
    goto locale_done

  locale_done:
    /* Turn off SSL by default if this is not a NO_NETWORK build */
    !ifdef NO_NETWORK
        !insertmacro SelectSection "${SEC_SSL}"
    !endif

FunctionEnd

; NotifyInstances
Function NotifyInstances ; Closes all running instances of Exodus
    Push $0
    Push $1
  start:
    StrCpy "$1" '0'
    ; check to see if we have any instances
    ; if we do, show a warning..
    FindWindow "$0" "${PRODUCT_WINDOWCLASS}" "" '0'
    IntCmpU '$0' '0' done
    ;removing this for the time beinging. Shutdown problems that occur after
    ;the window has been destroyed can keep this from working correctly.
    ;probably need to check for a process rather than a window.
;  loop:
;    FindWindow "$0" "${PRODUCT_WINDOWCLASS}" "" '0'
;    IntCmpU '$0' '0' done
;    !define MUI_FINISHPAGE_RUN ""
;    SendMessage "$0" '6374' '0' '0'
;    Sleep '100'
;    IntOp '$1' '$1' + '1'
;    IntCmpU '$1' '30' prompt
;    Goto loop
;  prompt:
    MessageBox MB_RETRYCANCEL|MB_ICONEXCLAMATION \
        "$(MSG_NotifyInstances)" IDRETRY start
    ; cancel
    Quit
  done:
    ; wait for shutdowns to complete
    Sleep '1000'
    Pop $1
    Pop $0
FunctionEnd

Function RunPreviousUninstall ; Runs the uninstaller for previous instance
	ReadRegStr $R0 HKLM "${PRODUCT_REGISTRY_KEY}" "${PRODUCT_INSTALL_PATH_KEY}"
	StrCmp $R0 "" done
	IfFileExists "$R0\${PRODUCT_UNINSTALLER}${EXEC_EXTENSION}" uninst done
	
	uninst:
	ClearErrors
	CreateDirectory "$TEMP\${PRODUCT_NAME}"
	CopyFiles "$R0\${PRODUCT_UNINSTALLER}${EXEC_EXTENSION}" "$TEMP\${PRODUCT_NAME}"
	ExecWait '"$TEMP\${PRODUCT_NAME}\${PRODUCT_UNINSTALLER}${EXEC_EXTENSION}" _?=$INSTDIR'
	RMDir /r "$TEMP\${PRODUCT_NAME}"
	; RMDir "$1"
	 
	done:
FunctionEnd

Function funcGetWindowsVersion ; faster than GetWindowsVersion (cannot be tampered with)
    Push $R0
    Push $R1
    Call funcGetVersionExA
    IntCmpU '$3' '2' winnt win9x verX
    winnt:
        IntCmpU '$0' '5' 0 winnt34 verX
        winnt5:
            IntCmpU '$1' '0' winnt2000 error
            IntCmpU '$1' '1' winntXP
            IntCmpU '$1' '2' winntNET 0 verX
            winnt2000:
                StrCpy "$R0" "2000"
                Goto end
            winntXP:
                StrCpy "$R0" "XP"
                Goto end
            winntNET:
                StrCpy "$R0" ".NET Server"
                Goto end
        winnt34:
            IntCmpU '$0' '4' 0 winnt3x winnt5
                IntCmpU '$1' '0' 0 error verX
                    StrCpy "$R0" "NT $0.$1"
                    Goto end
            winnt3x:
                IntCmpU '$1' '1' 0 error winnt351
                    StrCpy "$R0" "NT $0.$1"
                    Goto end
                    winnt351:
                        IntCmpU '$1' '51' 0 verX verX
                            StrCpy "$R0" "NT $0.$1"
                            Goto end
    win9x:
        IntCmpU '$0' '4' 0 win3x verX
            IntCmpU '$1' '0' 0 error winwdm
                StrCpy "$R0" "95"
                Goto end
            winwdm:
                IntCmpU '$1' '90' winme 0 verX
                    IntCmpU '$1' '10' 0 verX verX
                        StrCpy "$R0" "98"
                        Goto end
                winme:
                    StrCpy "$R0" "ME"
                    Goto end
        win3x:
            IntCmpU '$0' '3' 0 verX verX
                StrCpy "$R0" "$0.$1"
                Goto end
    verX:
        StrCpy "$R0" "Unsupported version $0.$1 (Platform $3)"
        Goto end
    error:
        StrCpy "$R0" "Error: logical comparision failed!"
    end:
    Pop $R1
    Exch $R0
FunctionEnd

Function funcGetVersionExA ; Get Windows version information
    /*
    struct OSVERSIONINFO {
        unsigned long dwOSVersionInfoSize;
        unsigned long dwMajorVersion;
        unsigned long dwMinorVersion;
        unsigned long dwBuildNumber;
        unsigned long dwPlatformId;
        unsigned char[128]* szCSDVersion;
    };

    Returns:

    $0 - Major
    $1 - Minor
    $2 - Build
    $3 - Platform
    $4 - Service Pack
    */
    System::Call '*(&l4, i, i, i, i, &t128) i (,,,,,) .r10'
    System::Call 'kernel32::GetVersionExA(i) i (r10)'
    System::Call '*$R0(&l4, i, i, i, i, &t128) i (,.r0, .r1, .r2, .r3, .r4)'
    System::Free '$R0'
FunctionEnd

Function funcGetConfigParam
    /*
    Checks to see if a given parameter was used
    usage:
        Push "</My parameter>"
        Call funcGetConfigParam
        Pop $0
        IntCmpU '$0' '1' if_found [if_notfound]
    */
    Exch $0
    Call GetParameters
    Pop $R0
    ${StrStr} "$R0" "$R0" "$0"
    StrLen "$0" "$R0"
    IntCmpU '$0' '0' +3 +3 0
        StrCpy "$0" "1"
        Goto +2
        StrCpy "$0" "0"
    Exch $0
FunctionEnd

 ; GetParameters
 ; input, none
 ; output, top of stack (replaces, with e.g. whatever)
 ; modifies no other variables.
Function GetParameters
    Push $R0
    Push $R1
    Push $R2
    Push $R3

    StrCpy $R2 1
    StrLen $R3 $CMDLINE

    ;Check for quote or space
    StrCpy $R0 $CMDLINE $R2
    StrCmp $R0 '"' 0 +3
         StrCpy $R1 '"'
        Goto loop
    StrCpy $R1 " "

  loop:
    IntOp $R2 $R2 + 1
    StrCpy $R0 $CMDLINE 1 $R2
    StrCmp $R0 $R1 get
    StrCmp $R2 $R3 get
    Goto loop

  get:
    IntOp $R2 $R2 + 1
    StrCpy $R0 $CMDLINE 1 $R2
    StrCmp $R0 " " get
    StrCpy $R0 $CMDLINE "" $R2

    Pop $R3
    Pop $R2
    Pop $R1
    Exch $R0
FunctionEnd

Function DownloadPlugin
    Exch $1

    CreateDirectory "$INSTDIR\${PLUGINS_DIR}"
    NSISdl::download "${HOME_URL}/${PLUGINS_DOWNLOAD_PATH}/$1_${EXODUS_VERSION}${ZIP_EXTENSION}" \
        "$INSTDIR\${PLUGINS_DIR}\$1${ZIP_EXTENSION}"
    Pop $R0
    StrCmp $R0 "${NSISDL_SUCCESSFUL}" unzip
    Abort "$(MSG_PluginAbort)"

  unzip:
    !insertmacro MUI_ZIPDLL_EXTRACTALL "$INSTDIR\${PLUGINS_DIR}\$1${ZIP_EXTENSION}" "$INSTDIR\${PLUGINS_DIR}"
    !ifndef DEBUG
        Delete "$INSTDIR\${PLUGINS_DIR}\$1${ZIP_EXTENSION}"
    !endif
FunctionEnd

Function .onInstSuccess
    ; start up any instances that were previously closed.
  outer_loop:
    EnumRegKey "$1" HKCU "${PRODUCT_RESTART_KEY}" '0'
    StrCmp "$1" "" abort

    ; set the PWD to the last PWD, so that the command line args
    ; have the same context
    ReadRegStr "$2" HKCU "${PRODUCT_RESTART_KEY}\$1" "${PRODUCT_RESTART_CWD_KEY}"
    StrCmp "$2" "" done
    SetOutPath "$2"

    ReadRegStr "$2" HKCU "${PRODUCT_RESTART_KEY}\$1" "${PRODUCT_RESTART_CMDLINE_KEY}"
    StrCmp $2 "" done

    ; if it doesn't have .exe, add the Exodus.exe to the front of
    ; the command line.  This is so that the first time an "old"
    ; install upgrades, it will still work, since the "old" versions
    ; didn't store the executable name in cmdline.
    ${StrStr} "$3" "$2" "${EXEC_EXTENSION}"
    StrCmp "$3" "" insert exec

  insert:
    StrCpy "$2" '"$INSTDIR\${PRODUCT}${EXEC_EXTENSION}" "$2"'

  exec:
    DetailPrint "$2"
    Exec "$2"
    SetAutoClose true

  done:
    DeleteRegKey HKCU "${PRODUCT_RESTART_KEY}\$1"

    Goto outer_loop
  abort:
FunctionEnd

Function un.onInit ; On Uninstall initialization
    ;!insertmacro MUI_UNGETLANGUAGE
FunctionEnd

Function un.funcRemoveUserLogs
    /*
    Function to remove the user logs if specified by the user
    Usage:
        Push <path to the exodus.xml file>
        Call un.funcRemoveUserLogs
        (Optional) Pop <error check>
    The poped value if empty means that the path wasn't set
    in the exodus.xml file (well not a problem, just go on).
    */
    Exch $0
    Push $0
    Call un.funcMakeMultiLineXMLFile
    Pop $0
    StrCpy $1 "$0"
    Push $0
    Call un.funcGetUserLogsPath
    Pop $0
    StrCmp "$0" "" notfound
    RmDir /r "$0"
  notfound:
    Delete "$1"
    Exch $0
FunctionEnd

Function un.funcMakeMultiLineXMLFile
    /*
    Function to convert a one line XML file to a multiline one
    since NSIS functions file functions are string orientated.
    This function should need the StrFunc.nsh inclusion (if the
    file would allow to be included in the uninstaller).
    Usage:
        Push <name of file to convert>
        Call un.funcMakeMultiLineXMLFile
        Pop <name of temporary multiline XML file>

    Don't forget to remove the temporary file when done.
    */
    Exch $0
    FileOpen $R1 "$0" 'r'
    GetTempFileName $0
    FileOpen $R0 "$0" 'w'
  loop:
    ClearErrors
    FileRead $R1 $R2
    IfErrors done
    ${un.StrRep} $R2 "$R2" "${XML_TAG_SEPARATORS}" "${XML_ML_TAG_SEPARATORS}"
    FileWrite $R0 $R2
    Goto loop
  done:
    FileClose $R0
    FileClose $R1
    Exch $0
FunctionEnd

Function un.funcGetUserLogsPath
    /*
    Function to get the path to the user logs.
    This function should need the StrFunc.nsh inclusion (if the
    file would allow to be included in the uninstaller).
        Push <name of file to parse>
        Call un.funcGetUserLogsPath
        Pop <path to the user logs>
    */
    Exch $0
    FileOpen $R0 "$0" 'r'
  loop:
    ClearErrors
    FileRead $R0 $0
    IfErrors notfound
    ${un.StrStrAdv} $0 "$0" '${LOG_PATH_XML_TAG}' '>' '>' '0' '0'
    StrCmp "$0" "" 0 found
    Goto loop
  found:
    ${un.StrStrAdv} $0 "$0" '${XML_TAG_END}' '<' '<' '0' '0'
    Goto done
  notfound:
    StrCpy $0 ""
  done:
    FileClose $R0
    Exch $0
FunctionEnd

