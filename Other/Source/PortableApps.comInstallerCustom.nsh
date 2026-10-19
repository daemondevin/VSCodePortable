
;= VARIABLES
;= ################
Var Developer
Var InstalledVersion
Var NewVersion
Var PortableVersion
Var ProgramVersion

;= DEFINES
;= ################
!define APP 		    `VSCode`
!define PORTABLE 	    `${APP}Portable`
!define DEVELOPER_ID	`daemon.devin`

;= FUNCTIONS
;= ################

; Sets $InstalledVersion to the version of the installed Code.exe
; ("1.132.0"), or "" when there is none.
Function GetInstalledVersion
	StrCpy $InstalledVersion ""
	ClearErrors
	GetDllVersion "$INSTDIR\App\${APP}\Code.exe" $R0 $R1
	${IfNot} ${Errors}
		IntOp $R2 $R0 / 0x00010000
		IntOp $R3 $R0 & 0x0000FFFF
		IntOp $R4 $R1 / 0x00010000
		StrCpy $InstalledVersion "$R2.$R3.$R4"
	${EndIf}
FunctionEnd

; Sets $NewVersion to the version of VS Code this installer is about to
; install ("1.142.0"), or "" when it can't be told. The installer has
; already downloaded the archive by now, so the version is read from the
; resources\app\package.json inside it. Newer builds keep that under a
; folder named after the commit, older ones at the top.
Function GetNewVersion
	StrCpy $NewVersion ""
	!ifdef DownloadURL & bolUses7Zip
		${If} ${FileExists} "$DOWNLOADEDFILE"
			InitPluginsDir
			CreateDirectory "$PLUGINSDIR\VSCodeVersion"
			SetOutPath "$PLUGINSDIR\VSCodeVersion"
			!ifdef UseLightweight7Zip
				File "${NSISDIR}\..\7zipLight\7z.exe"
			!else
				File "${NSISDIR}\..\7zip\7z.exe"
				File "${NSISDIR}\..\7zip\7z.dll"
			!endif
			SetOutPath $INSTDIR
			nsExec::Exec `"$PLUGINSDIR\VSCodeVersion\7z.exe" e "$DOWNLOADEDFILE" -o"$PLUGINSDIR\VSCodeVersion" "*\resources\app\package.json" "resources\app\package.json" -r- -aoa -y`
			Pop $R0
			ClearErrors
			FileOpen $R0 "$PLUGINSDIR\VSCodeVersion\package.json" r
			${IfNot} ${Errors}
				${Do}
					ClearErrors
					FileRead $R0 $R1
					${IfThen} ${Errors} ${|} ${ExitDo} ${|}
					; The first "version" key is the top level one: it comes
					; before any nested object in VS Code's package.json.
					${WordFind} $R1 `"version"` "E+1}" $R2
					${IfNot} ${Errors}
						; $R2 is now `: "1.142.0",` with the line end.
						${WordFind} $R2 `"` "E+2" $R3
						${IfNot} ${Errors}
							StrCpy $NewVersion $R3
						${EndIf}
						${ExitDo}
					${EndIf}
				${Loop}
				FileClose $R0
			${EndIf}
			RMDir /r "$PLUGINSDIR\VSCodeVersion"
			; A version starts with a digit; anything else wasn't one.
			StrCpy $R0 $NewVersion 1
			${If} $R0 S< 0
			${OrIf} $R0 S> 9
				StrCpy $NewVersion ""
			${EndIf}
		${EndIf}
	!endif
FunctionEnd

;= PRE INSTALL
;= ################
!macro CustomCodePreInstall
	SetDetailsPrint textonly
	DetailPrint "Checking if ${APP} Portable is already installed.."
	SetDetailsPrint lastused
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
		SetDetailsPrint listonly
		DetailPrint "${APP} Portable is already installed.."
		DetailPrint "Checking if ${APP} Portable was created by a different developer.."
		ClearErrors
		ReadINIStr $Developer "$INSTDIR\App\AppInfo\appinfo.ini" Team Developer
		${If} ${Errors}
		${OrIf} $Developer == ""
			ClearErrors
			ReadINIStr $Developer "$INSTDIR\App\AppInfo\appinfo.ini" Details Publisher
			StrCpy $1 $Developer 12
			${If} $1 == "${DEVELOPER_ID}"
				StrCpy $Developer "${DEVELOPER_ID}"
			${ElseIf} $Developer == ""
				StrCpy $Developer "Unknown Developer"
			${EndIf}
		${EndIf}

		${If} $Developer == "${DEVELOPER_ID}"
			DetailPrint "${APP} Portable was created by ${DEVELOPER_ID}.."
			Call GetInstalledVersion
			Call GetNewVersion
			${If} $InstalledVersion != ""
			${AndIf} $NewVersion != ""
				DetailPrint "Installed: ${APP} $InstalledVersion, this installer: ${APP} $NewVersion.."
				${VersionCompare} $InstalledVersion $NewVersion $1
				; 0 = the same, 1 = installed is newer, 2 = this one is newer.
				${If} $1 != 2
					${If} ${Silent}
						DetailPrint "${APP} Portable is already up to date.."
						Call .onInstFailed
						Quit
					${EndIf}
					${If} $1 == 0
						StrCpy $2 "${APP} Portable already has ${APP} $NewVersion, the version this installer contains."
					${Else}
						StrCpy $2 "${APP} Portable already has ${APP} $InstalledVersion, which is newer than the $NewVersion this installer contains."
					${EndIf}
					MessageBox MB_YESNO|MB_DEFBUTTON2|MB_ICONINFORMATION|MB_TOPMOST "$2$\r$\n$\r$\nInstall it anyway?" IDYES _CustomCodePreInstall_Reinstall
					DetailPrint "${APP} Portable is already up to date.."
					DetailPrint "Exiting current install process.."
					Call .onInstFailed
					Quit
					_CustomCodePreInstall_Reinstall:
				${EndIf}
			${EndIf}
		${Else}
			SetDetailsPrint textonly
			DetailPrint "Different developer detected!"
			SetDetailsPrint lastused
			MessageBox MB_OKCANCEL|MB_ICONINFORMATION|MB_TOPMOST "Your current version of ${APP} Portable was created by another developer ($Developer).$\r$\n$\r$\nClick OK to overwrite everything and continue.$\r$\nClick Cancel to abort current installation.$\r$\n$\r$\nNOTE: If you select OK, everything will be overwritten (including any settings in ..\Data)." IDOK _CustomCodePreInstall_Overwrite
			Call .onInstFailed
			Quit
			_CustomCodePreInstall_Overwrite:
			SetDetailsPrint textonly
			DetailPrint "Preparing current ${APP} Portable for new installation.."
			SetDetailsPrint listonly
			DetailPrint "Erasing previous settings and data.."
			Delete `$INSTDIR\${PORTABLE}.ini`
			RMDir /r `$INSTDIR\Data`
			SetDetailsPrint lastused
		${EndIf}
	${Else}
		SetDetailsPrint listonly
		DetailPrint "${APP} Portable is not installed.."
		DetailPrint "Continuing with current installation.."
		SetDetailsPrint lastused
	${EndIf}
!macroend

;= POST INSTALL 
;= ################
!macro CustomCodePostInstall
    Rename "$INSTDIR\App\VSCode-win32-x64" "$INSTDIR\App\${APP}"
	IfFileExists "$INSTDIR\${PORTABLE}.ini" +2
	CopyFiles /SILENT "$INSTDIR\Other\Source\${PORTABLE}.ini" "$INSTDIR"
    GetDllVersion "$INSTDIR\App\${APP}\code.exe" $R0 $R1
    IntOp $R2 $R0 / 0x00010000
    IntOp $R3 $R0 & 0x0000FFFF
    IntOp $R4 $R1 / 0x00010000
    IntOp $R5 $R1 & 0x0000FFFF
    StrCpy $ProgramVersion "$R2.$R3.$R4.$R5"
    ReadINIStr $PortableVersion "$INSTDIR\App\AppInfo\appinfo.ini" Version PackageVersion
    ${VersionCompare} $PortableVersion $ProgramVersion $0
    ${If} $0 == 2
        WriteINIStr "$INSTDIR\App\AppInfo\appinfo.ini" Version PackageVersion $ProgramVersion
        WriteINIStr "$INSTDIR\App\AppInfo\appinfo.ini" Version DisplayVersion "$R2.$R3.$R4"
    ${EndIf}
!macroend
