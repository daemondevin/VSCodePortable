; Visual Studio Code Portable custom code for PortableApps Compiler.
; For support, visit the GitHub project:
; https://github.com/daemondevin/pac-man
;
; What lives here and why:
;   Update      Optional self update of App\VSCode. Done as a journaled swap:
;               the current version is moved aside, the new one is extracted,
;               and only a complete new version is kept. A failure, or a crash
;               at any point, puts the previous version back.
;   VSCode      Journaled changes made for the session: the SendTo shortcut,
;               the vscode:// protocol and Applications\Code.exe keys VS Code
;               writes for itself, and LongPathsEnabled when started elevated.
;               All of them are undone on exit, or on the next launch after a
;               crash.
;   Tools       Optional Git, Python and Node.js from the user configuration,
;               put in front of PATH for VS Code only.
;   VSIX        Optional one time installation of bundled .vsix files.
;
; File associations and the Open with Code (Portable) context menu are not
; done here: they are declared in VSCodePortable.ini and handled by the
; journaled Associations segment.

; Variables
Var LocalVersion
Var RemoteVersion
Var ErrorReason
Var BasePath
Var ExtraPath
Var CmdPath
Var GitDir
Var GitHome
Var PythonDir
Var PythonUser
Var PythonPath
Var NodeJSDir
Var NodePrefix
Var DlWindow
Var DlLabel
Var DlBar
Var DlTotalKB
Var DlProcess
Var DlMsg
Var DlShown

; Defines
!define DOWNLOAD        `https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive`
!define URL             `https://update.code.visualstudio.com/api/update/win32-x64-archive/stable/latest`
!define ZIP             `VSCode-win32-x64.zip`
!define VSZIP           `$EXEDIR\${ZIP}`
!define CURL            `$SYSDIR\curl.exe`
!define jq              `$PLUGINSDIR\jq.exe`
!define 7za             `$PLUGINSDIR\7za.exe`
!define EXE             `${APPDIR}\Code.exe`
!define BACKUPDIR       `${APPDIR}-backup`
!define SND             `$SENDTO\${APP}.lnk`
!define VSIXLIST        `${DATA}\code\VSIXInstalled.ini`
!define LONGPATHS_KEY   `SYSTEM\CurrentControlSet\Control\FileSystem`

; Language
; The other languages the launcher loads use the English text.
!macro _VSCode::English _NAME _TEXT
	!ifdef LANG_ARMENIAN
		LangString ${_NAME} ${LANG_ARMENIAN} `${_TEXT}`
	!endif
	!ifdef LANG_BULGARIAN
		LangString ${_NAME} ${LANG_BULGARIAN} `${_TEXT}`
	!endif
	!ifdef LANG_DANISH
		LangString ${_NAME} ${LANG_DANISH} `${_TEXT}`
	!endif
	!ifdef LANG_DUTCH
		LangString ${_NAME} ${LANG_DUTCH} `${_TEXT}`
	!endif
	!ifdef LANG_ESTONIAN
		LangString ${_NAME} ${LANG_ESTONIAN} `${_TEXT}`
	!endif
	!ifdef LANG_FINNISH
		LangString ${_NAME} ${LANG_FINNISH} `${_TEXT}`
	!endif
	!ifdef LANG_GALICIAN
		LangString ${_NAME} ${LANG_GALICIAN} `${_TEXT}`
	!endif
	!ifdef LANG_HEBREW
		LangString ${_NAME} ${LANG_HEBREW} `${_TEXT}`
	!endif
	!ifdef LANG_HUNGARIAN
		LangString ${_NAME} ${LANG_HUNGARIAN} `${_TEXT}`
	!endif
	!ifdef LANG_INDONESIAN
		LangString ${_NAME} ${LANG_INDONESIAN} `${_TEXT}`
	!endif
	!ifdef LANG_POLISH
		LangString ${_NAME} ${LANG_POLISH} `${_TEXT}`
	!endif
	!ifdef LANG_PORTUGUESE
		LangString ${_NAME} ${LANG_PORTUGUESE} `${_TEXT}`
	!endif
	!ifdef LANG_ROMANIAN
		LangString ${_NAME} ${LANG_ROMANIAN} `${_TEXT}`
	!endif
	!ifdef LANG_SLOVENIAN
		LangString ${_NAME} ${LANG_SLOVENIAN} `${_TEXT}`
	!endif
	!ifdef LANG_SUNDANESE
		LangString ${_NAME} ${LANG_SUNDANESE} `${_TEXT}`
	!endif
	!ifdef LANG_SWEDISH
		LangString ${_NAME} ${LANG_SWEDISH} `${_TEXT}`
	!endif
	!ifdef LANG_THAI
		LangString ${_NAME} ${LANG_THAI} `${_TEXT}`
	!endif
	!ifdef LANG_TRADCHINESE
		LangString ${_NAME} ${LANG_TRADCHINESE} `${_TEXT}`
	!endif
	!ifdef LANG_TURKISH
		LangString ${_NAME} ${LANG_TURKISH} `${_TEXT}`
	!endif
	!ifdef LANG_VIETNAMESE
		LangString ${_NAME} ${LANG_VIETNAMESE} `${_TEXT}`
	!endif
!macroend
!define VSCode::English "!insertmacro _VSCode::English"

LangString PATH     ${LANG_ENGLISH}         `The "PATH" environment variable is too long!$\r$\n$\r$\nUsing the default setting.`
LangString PATH     ${LANG_SIMPCHINESE}     `“PATH”环境变量太长！$\r$\n$\r$\n使用默认设置。`
LangString PATH     ${LANG_FRENCH}          `La variable d'environnement « PATH » est trop longue !$\r$\n$\r$\nUtilisation du paramètre par défaut.`
LangString PATH     ${LANG_GERMAN}          `Die Umgebungsvariable „PATH“ ist zu lang!$\r$\n$\r$\nVerwende die Standardeinstellung.`
LangString PATH     ${LANG_ITALIAN}         `La variabile d'ambiente "PATH" è troppo lunga!$\r$\n$\r$\nSi utilizza l'impostazione predefinita.`
LangString PATH     ${LANG_JAPANESE}        `"PATH" 環境変数が長すぎます!$\r$\n$\r$\nデフォルト設定を使用します。`
LangString PATH     ${LANG_PORTUGUESEBR}    `A variável de ambiente "PATH" é muito longa!$\r$\n$\r$\nUsando a configuração padrão.`
LangString PATH     ${LANG_SPANISH}         `¡La variable de entorno "PATH" es demasiado larga!$\r$\n$\r$\nUsando la configuración predeterminada.`
LangString VSIX     ${LANG_ENGLISH}         `Install "$R2"?$\r$\n$\r$\nInstalling may take a while so please be patient.`
LangString VSIX     ${LANG_SIMPCHINESE}     `安装“$R2”？$\r$\n$\r$\n安装可能需要一段时间，请耐心等待。`
LangString VSIX     ${LANG_FRENCH}          `Installer « $R2 » ?$\r$\n$\r$\nL'installation peut prendre un certain temps, veuillez donc être patient.`
LangString VSIX     ${LANG_GERMAN}          `"$R2" installieren?$\r$\n$\r$\nDie Installation kann eine Weile dauern, haben Sie also bitte Geduld.`
LangString VSIX     ${LANG_ITALIAN}         `Installare "$R2"?$\r$\n$\r$\nL'installazione potrebbe richiedere un po' di tempo, quindi sii paziente.`
LangString VSIX     ${LANG_JAPANESE}        `「$R2」をインストールしますか?$\r$\n$\r$\nインストールにはしばらく時間がかかる場合がありますので、しばらくお待ちください。`
LangString VSIX     ${LANG_PORTUGUESEBR}    `Instalar "$R2"?$\r$\n$\r$\nA instalação pode demorar um pouco, então seja paciente.`
LangString VSIX     ${LANG_SPANISH}         `¿Instalar "$R2"?$\r$\n$\r$\nLa instalación puede tardar un poco, así que tenga paciencia.`
LangString FAILED   ${LANG_ENGLISH}         `Update check failed! $ErrorReason$\r$\n$\r$\nYou need to update ${PORTABLEAPPNAME} manually.`
LangString FAILED   ${LANG_SIMPCHINESE}     `更新检查失败！$ErrorReason$\r$\n$\r$\n您需要手动更新 ${PORTABLEAPPNAME}。`
LangString FAILED   ${LANG_FRENCH}          `Échec de la vérification de la mise à jour ! $ErrorReason$\r$\n$\r$\nVous devez mettre à jour ${PORTABLEAPPNAME} manuellement.`
LangString FAILED   ${LANG_GERMAN}          `Aktualisierungsprüfung fehlgeschlagen! $ErrorReason$\r$\n$\r$\nSie müssen ${PORTABLEAPPNAME} manuell aktualisieren.`
LangString FAILED   ${LANG_ITALIAN}         `Controllo aggiornamento fallito! $ErrorReason$\r$\n$\r$\nDevi aggiornare ${PORTABLEAPPNAME} manualmente.`
LangString FAILED   ${LANG_JAPANESE}        `更新の確認に失敗しました! $ErrorReason$\r$\n$\r$\n${PORTABLEAPPNAME} を手動で更新する必要があります。`
LangString FAILED   ${LANG_PORTUGUESEBR}    `Falha na verificação de atualização! $ErrorReason$\r$\n$\r$\nVocê precisa atualizar ${PORTABLEAPPNAME} manualmente.`
LangString FAILED   ${LANG_SPANISH}         `¡Error en la verificación de actualización! $ErrorReason$\r$\n$\r$\nNecesitas actualizar ${PORTABLEAPPNAME} manualmente.`
LangString UPDATE   ${LANG_ENGLISH}         `A new version of ${FULLNAME} is available!$\r$\n$\r$\nDo you want to update now?`
LangString UPDATE   ${LANG_SIMPCHINESE}     `${FULLNAME} 有新版本可用！$\r$\n$\r$\n是否立即更新？`
LangString UPDATE   ${LANG_FRENCH}          `Une nouvelle version de ${FULLNAME} est disponible !$\r$\n$\r$\nVoulez-vous mettre à jour maintenant ?`
LangString UPDATE   ${LANG_GERMAN}          `Eine neue Version von ${FULLNAME} ist verfügbar!$\r$\n$\r$\nMöchten Sie jetzt aktualisieren?`
LangString UPDATE   ${LANG_ITALIAN}         `È disponibile una nuova versione di ${FULLNAME}!$\r$\n$\r$\nVuoi aggiornare adesso?`
LangString UPDATE   ${LANG_JAPANESE}        `${FULLNAME} の新しいバージョンが利用可能です!$\r$\n$\r$\n今すぐ更新しますか?`
LangString UPDATE   ${LANG_PORTUGUESEBR}    `Uma nova versão de ${FULLNAME} está disponível!$\r$\n$\r$\nGostaria de atualizar agora?`
LangString UPDATE   ${LANG_SPANISH}         `¡Hay una nueva versión de ${FULLNAME} disponible!$\r$\n$\r$\n¿Le gustaría actualizar ahora?`
LangString FINISHED ${LANG_ENGLISH}         `${FULLNAME} has been updated successfully.$\r$\n$\r$\nNow launching ${PORTABLEAPPNAME}.`
LangString FINISHED ${LANG_SIMPCHINESE}     `${FULLNAME} 已成功更新。$\r$\n$\r$\n现在启动 ${PORTABLEAPPNAME}。`
LangString FINISHED ${LANG_FRENCH}          `${FULLNAME} a été mis à jour avec succès.$\r$\n$\r$\nLancement de ${PORTABLEAPPNAME}.`
LangString FINISHED ${LANG_GERMAN}          `${FULLNAME} wurde erfolgreich aktualisiert.$\r$\n$\r$\n${PORTABLEAPPNAME} wird jetzt gestartet.`
LangString FINISHED ${LANG_ITALIAN}         `${FULLNAME} è stato aggiornato con successo.$\r$\n$\r$\nAvvio di ${PORTABLEAPPNAME} in corso.`
LangString FINISHED ${LANG_JAPANESE}        `${FULLNAME} は正常に更新されました。$\r$\n$\r$\n${PORTABLEAPPNAME} を起動します。`
LangString FINISHED ${LANG_PORTUGUESEBR}    `${FULLNAME} foi atualizado com sucesso.$\r$\n$\r$\nAgora iniciando ${PORTABLEAPPNAME}.`
LangString FINISHED ${LANG_SPANISH}         `${FULLNAME} se ha actualizado correctamente.$\r$\n$\r$\nAhora iniciamos ${PORTABLEAPPNAME}.`
LangString DOWNLOAD ${LANG_ENGLISH}         `Downloading ${APP} $RemoteVersion..`
LangString DOWNLOAD ${LANG_SIMPCHINESE}     `正在下载 ${APP} $RemoteVersion 请稍等..`
LangString DOWNLOAD ${LANG_FRENCH}          `Téléchargement de ${APP} $RemoteVersion S'il vous plaît, attendez..`
LangString DOWNLOAD ${LANG_GERMAN}          `${APP} $RemoteVersion wird heruntergeladen Bitte warten..`
LangString DOWNLOAD ${LANG_ITALIAN}         `Download di ${APP} $RemoteVersion Attendere prego..`
LangString DOWNLOAD ${LANG_JAPANESE}        `${APP} $RemoteVersion をダウンロードしています お待ちください..`
LangString DOWNLOAD ${LANG_PORTUGUESEBR}    `Baixando ${APP} $RemoteVersion Por favor, aguarde..`
LangString DOWNLOAD ${LANG_SPANISH}         `Descargando ${APP} $RemoteVersion Espere por favor..`
LangString UPDATING ${LANG_ENGLISH}         `Updating ${APP}. Almost done..`
LangString UPDATING ${LANG_SIMPCHINESE}     `正在更新${APP}。 快完成了..`
LangString UPDATING ${LANG_FRENCH}          `Mise à jour de ${APP}. Presque fini..`
LangString UPDATING ${LANG_GERMAN}          `${APP} wird aktualisiert. Fast fertig..`
LangString UPDATING ${LANG_ITALIAN}         `Aggiornamento di ${APP}. Quasi fatto..`
LangString UPDATING ${LANG_JAPANESE}        `${APP} を更新しています。 ほぼ完了しました..`
LangString UPDATING ${LANG_PORTUGUESEBR}    `Atualizando ${APP}. Quase pronto..`
LangString UPDATING ${LANG_SPANISH}         `Actualizando ${APP}. Casi termino..`
${VSCode::English} PATH `The "PATH" environment variable is too long!$\r$\n$\r$\nUsing the default setting.`
${VSCode::English} VSIX `Install "$R2"?$\r$\n$\r$\nInstalling may take a while so please be patient.`
${VSCode::English} FAILED `Update check failed! $ErrorReason$\r$\n$\r$\nYou need to update ${PORTABLEAPPNAME} manually.`
${VSCode::English} UPDATE `A new version of ${FULLNAME} is available!$\r$\n$\r$\nDo you want to update now?`
${VSCode::English} FINISHED `${FULLNAME} has been updated successfully.$\r$\n$\r$\nNow launching ${PORTABLEAPPNAME}.`
${VSCode::English} DOWNLOAD `Downloading ${APP} $RemoteVersion..`
${VSCode::English} UPDATING `Updating ${APP}. Almost done..`

; Macros

; Shows the banner (or changes its text) to the language string _TEXT.
!define VSCode::Banner "!insertmacro _VSCode::Banner"
!macro _VSCode::Banner _TEXT
	Banner::show ""
	Banner::getWindow
	Pop $0
	GetDlgItem $0 $0 1030
	SendMessage $0 ${WM_SETTEXT} 0 "STR:${_TEXT}"
!macroend

; Appends _DIR to $ExtraPath with a separator when needed.
!define VSCode::AddPath "!insertmacro _VSCode::AddPath"
!macro _VSCode::AddPath _DIR
	${If} $ExtraPath == ""
		StrCpy $ExtraPath `${_DIR}`
	${Else}
		StrCpy $ExtraPath `$ExtraPath;${_DIR}`
	${EndIf}
!macroend

; Functions

; Sets $R9 to true when $RemoteVersion looks like a version (digits and
; dots, starting with a digit), else false. Anything else means the update
; service returned an error page or "null".
Function VSCode_IsVersion
	Push $0
	Push $1
	StrCpy $R9 false
	StrCpy $0 $RemoteVersion 1
	${If} $0 S>= 0
	${AndIf} $0 S<= 9
		StrCpy $R9 true
		StrCpy $1 0
		${Do}
			StrCpy $0 $RemoteVersion 1 $1
			${IfThen} $0 == "" ${|} ${ExitDo} ${|}
			${If} $0 S< 0
			${OrIf} $0 S> 9
				${If} $0 != .
					StrCpy $R9 false
					${ExitDo}
				${EndIf}
			${EndIf}
			IntOp $1 $1 + 1
		${Loop}
	${EndIf}
	Pop $1
	Pop $0
FunctionEnd

; Cleans up after an update that was interrupted between moving the current
; version aside and journaling that move, or between committing the new
; version and deleting the old one. Only called when the journal holds no
; update entry, so the journal never disagrees with what is done here.
Function VSCode_RecoverUpdate
	${If} ${FileExists} `${BACKUPDIR}\*.*`
		${If} ${FileExists} `${EXE}`
			; The new version was committed; the old copy is left over.
			RMDir /r `${BACKUPDIR}`
		${Else}
			; The new version never got in place; put the old one back.
			RMDir /r `${APPDIR}`
			Rename `${BACKUPDIR}` `${APPDIR}`
		${EndIf}
	${EndIf}
FunctionEnd

; Puts App\VSCode back after an update that was interrupted. This runs from
; the InstanceManagement segment, before the launcher checks that Code.exe
; exists: an interrupted update can leave App\VSCode without it, and the
; launcher would otherwise refuse to start before the journal got a chance to
; repair it. Primary launches only, so it never touches an update another
; launcher is still doing.
Function VSCode_RepairAppDir
	Push $0
	${Journal::HasEntries} VSCodeUpdate $0
	${If} $0 > 0
		${Journal::Rollback} VSCodeUpdate
	${Else}
		Call VSCode_RecoverUpdate
	${EndIf}
	; A download left behind by an interrupted update.
	Delete `${VSZIP}`
	Pop $0
FunctionEnd

; Opens the download window: the banner, made wider, with a progress bar
; under its text. The bar belongs to this thread, so VSCode_Pump has to run
; while the download is waiting, or it would never be drawn.
Function VSCode_ProgressOpen
	Push $0
	Push $1
	Push $2
	Push $3
	Push $4
	Push $5
	Push $6
	Push $7
	Push $8
	Push $9
	Banner::show "$(DOWNLOAD)"
	Banner::getWindow
	Pop $DlWindow
	GetDlgItem $DlLabel $DlWindow 1030
	StrCpy $DlShown ""
	System::Call 'comctl32::InitCommonControls()'
	System::Call '*(i,i,i,i) p .r0'
	System::Call 'user32::GetWindowRect(p $DlWindow, p r0)'
	System::Call '*$0(i .r1, i .r2, i .r3, i .r4)'
	System::Call 'user32::GetWindowRect(p $DlLabel, p r0)'
	System::Call 'user32::MapWindowPoints(p 0, p $DlWindow, p r0, i 2)'
	System::Call '*$0(i .r5, i .r6, i .r7, i .r8)'
	System::Free $0
	; Sizes come from the label, so they follow the DPI the banner uses:
	; the bar is as tall as the label, with half that as the gap above it,
	; and both are made half as wide again.
	Push $R8
	Push $R9
	IntOp $9 $7 - $5
	IntOp $0 $8 - $6
	IntOp $R9 $0 / 2
	IntOp $R8 $9 / 2
	IntOp $9 $9 + $R8
	; The window grows by the same amounts and stays centred where it was.
	IntOp $3 $3 - $1
	IntOp $3 $3 + $R8
	IntOp $4 $4 - $2
	IntOp $4 $4 + $0
	IntOp $4 $4 + $R9
	IntOp $7 $R8 / 2
	IntOp $1 $1 - $7
	IntOp $7 $0 + $R9
	IntOp $7 $7 / 2
	IntOp $2 $2 - $7
	; SWP_NOZORDER|SWP_NOACTIVATE
	System::Call 'user32::SetWindowPos(p $DlWindow, p 0, i r1, i r2, i r3, i r4, i 0x14)'
	; SWP_NOMOVE|SWP_NOZORDER|SWP_NOACTIVATE
	System::Call 'user32::SetWindowPos(p $DlLabel, p 0, i 0, i 0, i r9, i r0, i 0x16)'
	IntOp $8 $8 + $R9
	Pop $R9
	Pop $R8
	; WS_CHILD|WS_VISIBLE, PBS_SMOOTH
	System::Call 'user32::CreateWindowExW(i 0, w "msctls_progress32", w "", i 0x50000001, i r5, i r8, i r9, i r0, p $DlWindow, p 0, p 0, p 0) p .s'
	Pop $DlBar
	${If} $DlTotalKB > 0
		; PBM_SETRANGE32 0 to 100
		SendMessage $DlBar 0x406 0 100
	${Else}
		; Size unknown: a marquee (PBS_MARQUEE, PBM_SETMARQUEE).
		System::Call 'user32::GetWindowLongW(p $DlBar, i -16) i .r1'
		IntOp $1 $1 | 0x08
		System::Call 'user32::SetWindowLongW(p $DlBar, i -16, i r1)'
		SendMessage $DlBar 0x40A 1 30
	${EndIf}
	System::Call '*(&i32) p .s'
	Pop $DlMsg
	Call VSCode_Pump
	Pop $9
	Pop $8
	Pop $7
	Pop $6
	Pop $5
	Pop $4
	Pop $3
	Pop $2
	Pop $1
	Pop $0
FunctionEnd

Function VSCode_ProgressClose
	${If} $DlBar != ""
		System::Call 'user32::DestroyWindow(p $DlBar)'
		StrCpy $DlBar ""
	${EndIf}
	${If} $DlMsg != ""
		System::Free $DlMsg
		StrCpy $DlMsg ""
	${EndIf}
	Banner::destroy
FunctionEnd

; Handles the messages waiting for this thread (the progress bar's).
Function VSCode_Pump
	Push $0
	${Do}
		; PM_REMOVE
		System::Call 'user32::PeekMessageW(p $DlMsg, p 0, i 0, i 0, i 1) i .r0'
		${IfThen} $0 = 0 ${|} ${ExitDo} ${|}
		System::Call 'user32::TranslateMessage(p $DlMsg)'
		System::Call 'user32::DispatchMessageW(p $DlMsg)'
	${Loop}
	Pop $0
FunctionEnd

; Shows $0 bytes downloaded: "45%  (60.2 / 133.4 MB)", or "60.2 MB" when
; the size is unknown. The text only changes when the numbers do.
Function VSCode_ProgressSet
	Push $1
	Push $2
	Push $3
	Push $4
	IntOp $1 $0 / 1024
	; Tenths of a MB.
	IntOp $2 $1 * 10
	IntOp $2 $2 / 1024
	IntOp $3 $2 % 10
	IntOp $2 $2 / 10
	StrCpy $2 `$2.$3`
	${If} $DlTotalKB > 0
		IntOp $4 $1 * 100
		IntOp $4 $4 / $DlTotalKB
		${IfThen} $4 > 100 ${|} StrCpy $4 100 ${|}
		IntOp $3 $DlTotalKB * 10
		IntOp $3 $3 / 1024
		IntOp $1 $3 % 10
		IntOp $3 $3 / 10
		StrCpy $3 `$4%  ($2 / $3.$1 MB)`
		SendMessage $DlBar 0x402 $4 0
	${Else}
		StrCpy $3 `$2 MB`
	${EndIf}
	${If} $3 != $DlShown
		StrCpy $DlShown $3
		SendMessage $DlLabel ${WM_SETTEXT} 0 `STR:$(DOWNLOAD)  $3`
	${EndIf}
	Pop $4
	Pop $3
	Pop $2
	Pop $1
FunctionEnd

; Sets $DlTotalKB to the size of the download in KB, or 0 when the server
; doesn't say. curl writes the response headers to a file; the last
; Content-Length in it counts, the ones before belong to redirects.
Function VSCode_DownloadSize
	Push $0
	Push $1
	Push $2
	StrCpy $DlTotalKB 0
	InitPluginsDir
	Delete `$PLUGINSDIR\headers.txt`
	nsExec::Exec `"${CURL}" -fsSIL -o "$PLUGINSDIR\headers.txt" "${DOWNLOAD}"`
	Pop $0
	ClearErrors
	FileOpen $0 `$PLUGINSDIR\headers.txt` r
	${IfNot} ${Errors}
		${Do}
			ClearErrors
			FileRead $0 $1
			${IfThen} ${Errors} ${|} ${ExitDo} ${|}
			; == ignores case, and HTTP/2 headers are lower case.
			StrCpy $2 $1 15
			${If} $2 == "content-length:"
				StrCpy $1 $1 "" 15
				${Trim} $1 $1
				StrCpy $2 $1 1
				${If} $2 S>= 0
				${AndIf} $2 S<= 9
					IntOp $DlTotalKB $1 / 1024
				${EndIf}
			${EndIf}
		${Loop}
		FileClose $0
	${EndIf}
	${IfThen} $DlTotalKB < 0 ${|} StrCpy $DlTotalKB 0 ${|}
	Pop $2
	Pop $1
	Pop $0
FunctionEnd

; Downloads the new version to ${VSZIP} with curl, showing its progress.
; $0 is curl's exit code, or -1 when curl could not be started.
Function VSCode_Download
	Push $1
	Push $2
	Push $3
	Push $4
	Push $5
	Push $6
	Delete `${VSZIP}`
	Call VSCode_DownloadSize
	Call VSCode_ProgressOpen
	StrCpy $0 -1
	StrCpy $1 `"${CURL}" -fsSL -o "${VSZIP}" "${DOWNLOAD}"`
	System::Call '*(i 68, &i64) p .r2'
	System::Call '*(&i16) p .r3'
	; CREATE_NO_WINDOW
	System::Call 'kernel32::CreateProcessW(p 0, w r1, p 0, p 0, i 0, i 0x08000000, p 0, p 0, p r2, p r3) i .r4'
	${If} $4 <> 0
		System::Call '*$3(p .r4, p .r5)'
		System::Call 'kernel32::CloseHandle(p r5)'
		StrCpy $DlProcess $4
		System::Call '*(&i36) p .r6'
		${Do}
			System::Call 'kernel32::WaitForSingleObject(p $DlProcess, i 100) i .r5'
			Call VSCode_Pump
			; nFileSizeLow of WIN32_FILE_ATTRIBUTE_DATA, at offset 32.
			StrCpy $0 0
			System::Call 'kernel32::GetFileAttributesExW(w "${VSZIP}", i 0, p r6) i .r4'
			${If} $4 <> 0
				System::Call '*$6(&i32, i .r0)'
			${EndIf}
			Call VSCode_ProgressSet
		${LoopWhile} $5 <> 0
		System::Call 'kernel32::GetExitCodeProcess(p $DlProcess, *i .r0)'
		System::Call 'kernel32::CloseHandle(p $DlProcess)'
		System::Free $6
	${EndIf}
	System::Free $2
	System::Free $3
	Call VSCode_ProgressClose
	Pop $6
	Pop $5
	Pop $4
	Pop $3
	Pop $2
	Pop $1
FunctionEnd

; Checks for a newer VS Code and, if the user agrees, swaps it in.
Function VSCode_Update
	${ConfigReads} `${CONFIG}` UpdateCheck= $0
	${If} $0 != true
		Return
	${EndIf}
	; An earlier update that could not be undone yet (for example a file was
	; still in use) is retried on the next launch; don't start another one.
	${Journal::HasEntries} VSCodeUpdate $0
	${If} $0 > 0
		Return
	${EndIf}
	${IfNot} ${FileExists} `${EXE}`
		Return
	${EndIf}

	GetDllVersion `${EXE}` $R0 $R1
	IntOp $R2 $R0 / 0x00010000
	IntOp $R3 $R0 & 0x0000FFFF
	IntOp $R4 $R1 / 0x00010000
	StrCpy $LocalVersion `$R2.$R3.$R4`

	InitPluginsDir
	File /oname=$PLUGINSDIR\jq.exe Contrib\bin\jq.exe
	ExpandEnvStrings $CmdPath "%COMSPEC%"
	nsExec::ExecToStack `"$CmdPath" /C ""${CURL}" -fsS "${URL}" | "${jq}" -r .productVersion 2>nul"`
	Pop $0
	Pop $1
	${Trim} $RemoteVersion $1
	Call VSCode_IsVersion
	${If} $0 != 0
	${OrIf} $R9 != true
		StrCpy $ErrorReason "Couldn't retrieve the latest version information."
		Goto failed
	${EndIf}

	; 0 = same, 1 = local is newer, 2 = remote is newer.
	${VersionCompare} $LocalVersion $RemoteVersion $0
	${If} $0 != 2
		Return
	${EndIf}
	MessageBox MB_USERICON|MB_YESNO|MB_TOPMOST `$(UPDATE)` IDYES +2
	Return

	Call VSCode_Download
	${If} $0 != 0
	${OrIfNot} ${FileExists} `${VSZIP}`
		StrCpy $ErrorReason "The download failed."
		Goto failed
	${EndIf}

	${VSCode::Banner} `$(UPDATING)`
	File /oname=${7za} Contrib\bin\7za.exe
	; Moving the current version aside is the backup. It is journaled right
	; away, so from here on a failure or a crash puts it back: the undo
	; deletes whatever was extracted and moves the backup into place again.
	ClearErrors
	Rename `${APPDIR}` `${BACKUPDIR}`
	${If} ${Errors}
		Banner::destroy
		StrCpy $ErrorReason "${APP} is in use and can't be replaced right now."
		Goto failed
	${EndIf}
	${Journal::Record} VSCodeUpdate DIR `${APPDIR}` `${BACKUPDIR}` recursive ""
	CreateDirectory `${APPDIR}`
	nsExec::Exec `"${7za}" x "${VSZIP}" -o"${APPDIR}" -y -bso0 -bsp0`
	Pop $0
	Banner::destroy
	${If} $0 != 0
	${OrIfNot} ${FileExists} `${EXE}`
		${Journal::Rollback} VSCodeUpdate
		StrCpy $ErrorReason "The download could not be extracted (7-Zip exit code $0). The previous version was kept."
		Goto failed
	${EndIf}

	; Commit. The entry goes first: if the launcher stops before the old
	; copy is deleted, VSCode_RecoverUpdate deletes it on the next launch.
	${Journal::Discard} VSCodeUpdate
	RMDir /r `${BACKUPDIR}`
	Delete `${VSZIP}`
	${WriteAppInfoConfig} Version DisplayVersion `$RemoteVersion.0`
	${WriteAppInfoConfig} Version PackageVersion `$RemoteVersion.0`
	MessageBox MB_ICONINFORMATION|MB_TOPMOST `$(FINISHED)`
	Return

	failed:
	Delete `${VSZIP}`
	MessageBox MB_ICONSTOP|MB_TOPMOST `$(FAILED)`
FunctionEnd

; Journals a registry key under HKCU that VS Code writes for itself while it
; runs, so it is put back the way it was afterwards.
Function VSCode_JournalUserKey
	Exch $1
	Push $0
	${Journal::RegKey} VSCode HKCU `$1` $0
	${If} $0 == ""
		${DebugMsg} "HKCU\$1 could not be backed up; VS Code's change to it will stay."
	${EndIf}
	Pop $0
	Pop $1
FunctionEnd

; The journaled session changes. Every one is recorded before it is made.
Function VSCode_Apply
	; SendTo shortcut. It runs the launcher, so a file sent while VS Code is
	; open goes to the running portable instance.
	SetShellVarContext current
	${Journal::BackupFile} VSCode `${SND}` $0
	${Journal::Record} VSCode FILE `${SND}` $0 "" ""
	CreateShortCut `${SND}` `$EXEPATH` "" `${EXE}` 0

	; VS Code registers the vscode:// protocol for itself on every start.
	Push `Software\Classes\vscode`
	Call VSCode_JournalUserKey
	Push `Software\Classes\Applications\Code.exe`
	Call VSCode_JournalUserKey

	; Long path support is machine wide and needs administrator rights. The
	; launcher doesn't ask for them (VS Code must not run elevated, and an
	; elevated launcher can't pass PATH to a program it starts as the user),
	; so this only happens when it was started as administrator on purpose,
	; and only for the session.
	${If} $Admin == true
		ClearErrors
		ReadRegDWORD $0 HKLM `${LONGPATHS_KEY}` LongPathsEnabled
		${If} ${Errors}
			StrCpy $0 ""
			StrCpy $1 ""
		${Else}
			StrCpy $1 `DWORD:$0`
		${EndIf}
		${If} $0 != 1
			${Journal::Record} VSCode REGVALUE HKLM `${LONGPATHS_KEY}` LongPathsEnabled $1
			WriteRegDWORD HKLM `${LONGPATHS_KEY}` LongPathsEnabled 1
		${EndIf}
	${EndIf}
FunctionEnd

; Git, Python and Node.js from the user configuration.
Function VSCode_ToolPaths
	ExpandEnvStrings $CmdPath "%COMSPEC%"
	StrCpy $ExtraPath ""
	StrCpy $PythonPath ""

	; Git
	${ConfigReads} `${CONFIG}` GIT= $GitDir
	ExpandEnvStrings $GitDir $GitDir
	${If} $GitDir != ""
	${AndIf} ${FileExists} `$GitDir\cmd\git.exe`
		${ConfigReads} `${CONFIG}` GitHomePath= $GitHome
		${If} $GitHome == true
			CreateDirectory `${DATA}\Git\home`
			; If not set, the default is "%UserProfile%".
			${SetEnvironmentVariablesPath} HOME `${DATA}\Git\home`
			; Also copy custom shell config files on first run (contains a
			; workaround for the "cd" command). Oh My Zsh may overwrite them,
			; so the "cd" alias may need to be added again by hand.
			${IfNot} ${FileExists} `${DATA}\Git\home\.bashrc`
				CopyFiles /SILENT `${DEFDATA}\Git\home\.bashrc` `${DATA}\Git\home`
			${EndIf}
		${EndIf}
		${If} ${PrimaryInstance}
		${AndIf} ${FileExists} `$GitDir\post-install.bat`
			; Portable Git post installation. It deletes itself when done.
			; Cmd removes the outer quotes, so the command is nested in a pair.
			nsExec::Exec `"$CmdPath" /C ""$GitDir\post-install.bat""`
			Pop $0
		${EndIf}
		${VSCode::AddPath} `$GitDir\bin;$GitDir\cmd`
	${EndIf}

	; Python
	${ConfigReads} `${CONFIG}` PYTHON= $PythonDir
	ExpandEnvStrings $PythonDir $PythonDir
	${If} $PythonDir != ""
	${AndIf} ${FileExists} `$PythonDir\python.exe`
		${ConfigReads} `${CONFIG}` PythonUserPath= $PythonUser
		${If} $PythonUser == true
			; Changes the user base directory (the default is
			; "%AppData%\Python"). Globally installed packages are not affected.
			${SetEnvironmentVariablesPath} PYTHONUSERBASE `${DATA}\Python`
		${EndIf}
		; Add the user "scripts" directory to PATH as well.
		nsExec::ExecToStack `"$PythonDir\python.exe" -m site --user-site`
		Pop $R1
		Pop $R2
		${If} $R1 == 0
			${Trim} $R2 $R2
			${GetParent} $R2 $R2
			${VSCode::AddPath} `$PythonDir;$PythonDir\Scripts;$R2\Scripts`
		${Else}
			${VSCode::AddPath} `$PythonDir;$PythonDir\Scripts`
		${EndIf}
		ReadEnvStr $PythonPath PYTHONPATH
		${If} $PythonPath == ""
			StrCpy $PythonPath `$PythonDir\Lib;$PythonDir\DLLs`
		${Else}
			StrCpy $PythonPath `$PythonDir\Lib;$PythonDir\DLLs;$PythonPath`
		${EndIf}
		${SetEnvironmentVariablesPath} PYTHONPATH $PythonPath
	${EndIf}

	; Node.js
	${ConfigReads} `${CONFIG}` NODEJS= $NodeJSDir
	ExpandEnvStrings $NodeJSDir $NodeJSDir
	${If} $NodeJSDir != ""
	${AndIf} ${FileExists} `$NodeJSDir\node.exe`
		${ConfigReads} `${CONFIG}` NodePrefixPath= $NodePrefix
		${If} $NodePrefix == true
		${AndIf} ${PrimaryInstance}
			; Moves the npm prefix and cache (the defaults are "%AppData%\npm"
			; and "%AppData%\npm-cache"). npm writes this to
			; "%UserProfile%\.npmrc", so think twice on a shared computer.
			nsExec::Exec `"$CmdPath" /C ""$NodeJSDir\npm.cmd" config set prefix "${DATA}\Node.js\npm""`
			Pop $0
			nsExec::Exec `"$CmdPath" /C ""$NodeJSDir\npm.cmd" config set cache "${DATA}\Node.js\npm-cache""`
			Pop $0
		${EndIf}
		; Add the prefix directory to PATH as well.
		nsExec::ExecToStack `"$CmdPath" /C ""$NodeJSDir\npm.cmd" config get prefix"`
		Pop $R1
		Pop $R2
		${If} $R1 == 0
			${Trim} $R2 $R2
			${VSCode::AddPath} `$NodeJSDir;$R2`
		${Else}
			${VSCode::AddPath} $NodeJSDir
		${EndIf}
	${EndIf}

	; The tools go in front of the existing PATH, for VS Code only.
	${If} $ExtraPath != ""
		ReadEnvStr $BasePath PATH
		StrLen $R1 `$ExtraPath;$BasePath`
		${If} $R1 < ${NSIS_MAX_STRLEN}
			System::Call `kernel32::SetEnvironmentVariable(t "PATH", t "$ExtraPath;$BasePath")`
		${Else}
			MessageBox MB_OK|MB_ICONEXCLAMATION `$(PATH)`
		${EndIf}
	${EndIf}
FunctionEnd

; Offers each bundled .vsix file once. The answer is remembered in
; Data\code\VSIXInstalled.ini, so a file added later is offered too.
Function VSCode_InstallVSIX
	${ConfigReads} `${CONFIG}` InstallVSIX= $0
	${If} $0 != true
		Return
	${EndIf}
	ExpandEnvStrings $CmdPath "%COMSPEC%"
	FindFirst $R1 $R2 `${DEFDATA}\code\extensions\*.vsix`
	${DoWhile} $R2 != ""
		ReadINIStr $0 `${VSIXLIST}` Installed $R2
		${If} $0 == ""
			StrCpy $3 declined
			MessageBox MB_YESNO|MB_ICONQUESTION `$(VSIX)` IDNO +2
			StrCpy $3 yes
			${If} $3 == yes
				nsExec::Exec `"$CmdPath" /C ""${APPDIR}\bin\code.cmd" --user-data-dir "${DATA}\code" --extensions-dir "${DATA}\code\extensions" --install-extension "${DEFDATA}\code\extensions\$R2""`
				Pop $0
				${If} $0 == 0
					StrCpy $3 installed
				${Else}
					; Not remembered, so it is offered again next time.
					StrCpy $3 ""
				${EndIf}
			${EndIf}
			${If} $3 != ""
				WriteINIStr `${VSIXLIST}` Installed $R2 $3
			${EndIf}
		${EndIf}
		FindNext $R1 $R2
	${Loop}
	FindClose $R1
FunctionEnd

; Hooks

; Environment segment, Init and Pre. The launcher's own path, used by the
; association, context menu and SendTo commands so they go through it.
!macro Variables
	System::Call `kernel32::SetEnvironmentVariable(t "PAL:LauncherPath", t "$EXEPATH")`
	System::Call `kernel32::SetEnvironmentVariable(t "PAL:LauncherDir", t "$EXEDIR")`
!macroend

; InstanceManagement segment, Init, right before Code.exe is looked for.
!macro EXE
	${If} $SecondaryLaunch != true
		Call VSCode_RepairAppDir
	${EndIf}
!macroend

; Settings segment, Init, primary instance only.
!macro Init
	${Init::File} code\User settings.json
	${Init::File} Fonts ""
!macroend

${SegmentFile}

${SegmentPrePrimary}
	; Runs after crash recovery and after the journal session is open.
	Call VSCode_Update
	Call VSCode_Apply
	${ConfigReads} `${CONFIG}` Banner= $0
	${If} $0 == true
		${VSCode::Banner} `$(i)`
	${EndIf}
!macroend

!macro PreExecExecute
	${If} ${PrimaryInstance}
		Banner::destroy
	${EndIf}
	Call VSCode_ToolPaths
	${If} ${PrimaryInstance}
		Call VSCode_InstallVSIX
	${EndIf}
!macroend

${SegmentPostPrimary}
	${Journal::HasEntries} VSCode $R0
	${If} $R0 > 0
		${Journal::Rollback} VSCode
	${EndIf}
!macroend
