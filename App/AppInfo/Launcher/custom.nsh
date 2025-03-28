
;= LAUNCHER
;= ################
; For support, visit the GitHub project:
; https://github.com/daemondevin/pac-man

;= VARIABLES
;= ################
Var LocalVersion
Var RemoteVersion
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

;= DEFINES
;= ################
!define oNET        `SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full`
!define DOWNLOAD    `https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive`
!define URL         `https://update.code.visualstudio.com/api/update/win32-x64-archive/stable/latest`
!define ZIP         `VSCode-win32-x64.zip`
!define VSZIP       `$EXEDIR\${ZIP}`
!define cURLP       `$PLUGINSDIR\curl.exe`
!define cURLS		`$SYSDIR\curl.exe`
!define jq      	`$PLUGINSDIR\jq.exe`
!define 7z      	`$PLUGINSDIR\7z.exe`
!define _           `${PAF}\Keys`
!define CL          SOFTWARE\Classes
!define CLS         HKLM\${CL}
!define ULS         HKCU\${CL}
!define EX          SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts
!define EXTS        HKCU\Software\Microsoft\Windows\Roaming\OpenWith\FileExts
!define EXT         HKCU\${EX}
!define EXE         `${APPDIR}\${APP}.exe`
!define SND         `$SENDTO\${APP}.lnk`

;= LANGUAGE
;= ################
LangString OS       ${LANG_ENGLISH}         `You must have Windows 7 or better to use ${PORTABLEAPPNAME}.$\r$\n$\r$\nAborting!`
LangString OS       ${LANG_SIMPCHINESE}     `?????Windows 7?????????${PORTABLEAPPNAME}?$\r$\n$\r$\n??!`
LangString OS       ${LANG_FRENCH}          `Vous devez avoir Windows 7 ou mieux pour utiliser ${PORTABLEAPPNAME}.$\r$\n$\r$\nAbandonner!`
LangString OS       ${LANG_GERMAN}          `Sie m�ssen Windows 7 oder besser verwenden, um ${PORTABLEAPPNAME} zu verwenden.$\r$\n$\r$\nAbbrechen!`
LangString OS       ${LANG_ITALIAN}         `Devi avere Windows 7 o meglio utilizzare ${PORTABLEAPPNAME}.$\r$\n$\r$\nInterruzione!`
LangString OS       ${LANG_JAPANESE}        `${PORTABLEAPPNAME}????????Windows 7????????$\r$\n$\r$\n??!`
LangString OS       ${LANG_PORTUGUESEBR}    `Voc� deve ter o Windows 7 ou superior para usar o ${PORTABLEAPPNAME}.$\r$\n$\r$\nAbortando!`
LangString OS       ${LANG_SPANISH}         `Debes tener Windows 7 o mejor para utilizar ${PORTABLEAPPNAME}.$\r$\n$\r$\nAbortar!`
LangString NET      ${LANG_ENGLISH}         `.NET Error:$\r$\n$\r$\nv4.5 or greater of the .NET Framework must be installed.$\r$\n$\r$\nAborting!`
LangString NET      ${LANG_SIMPCHINESE}     `.NET??:$\r$\n$\r$\n????v4.5??????.NET Framework?$\r$\n$\r$\n??!`
LangString NET      ${LANG_FRENCH}          `Erreur .NET:$\r$\n$\r$\nv4.5 ou plus du .NET Framework doit �tre install�.$\r$\n$\r$\nAbandonner!`
LangString NET      ${LANG_GERMAN}          `.NET Fehler:$\r$\n$\r$\nv4.5 oder h�her von .NET Framework muss installiert sein.$\r$\n$\r$\nAbbrechen!`
LangString NET      ${LANG_ITALIAN}         `.NET Errore:$\r$\n$\r$\nv4.5 o superiore del .NET Framework deve essere installato.$\r$\n$\r$\nInterruzione!`
LangString NET      ${LANG_JAPANESE}        `.NET???:$\r$\n$\r$\n.NET Framework?v4.5??????????????????????$\r$\n$\r$\n??!`
LangString NET      ${LANG_PORTUGUESEBR}    `Erro .NET:$\r$\n$\r$\nv4.5 ou superior do .NET Framework deve ser instalado.$\r$\n$\r$\nAbortando!`
LangString NET      ${LANG_SPANISH}         `.NET Error:$\r$\n$\r$\ndebe instalarse v4.5 o superior del .NET Framework.$\r$\n$\r$\nAbortar!`
LangString PATH     ${LANG_ENGLISH}         `The "PATH" environment variable is too long!$\r$\n$\r$\nUsing the default setting.`
LangString PATH     ${LANG_SIMPCHINESE}     `“PATH”环境变量太长！$\r$\n$\r$\n使用默认设置。`
LangString PATH     ${LANG_FRENCH}          `La variable d'environnement « PATH » est trop longue !$\r$\n$\r$\nUtilisation du paramètre par défaut.`
LangString PATH     ${LANG_GERMAN}          `Die Umgebungsvariable „PATH“ ist zu lang!$\r$\n$\r$\nVerwende die Standardeinstellung.`
LangString PATH     ${LANG_ITALIAN}         `La variabile d'ambiente "PATH" è troppo lunga!$\r$\n$\r$\nSi utilizza l'impostazione predefinita.`
LangString PATH     ${LANG_JAPANESE}        `"PATH" 環境変数が長すぎます!$\r$\n$\r$\nデフォルト設定を使用します。`
LangString PATH     ${LANG_PORTUGUESEBR}    `A variável de ambiente "PATH" é muito longa!$\r$\n$\r$\nUsando a configuração padrão.`
LangString PATH     ${LANG_SPANISH}         `¡La variable de entorno "PATH" es demasiado larga!$\r$\n$\r$\nUsando la configuración predeterminada.`
LangString VSIX     ${LANG_ENGLISH}         `Install "$R2"?$\r$\n$\r$\nInstalling may take a while so please be patient.`
LangString VSIX     ${LANG_SIMPCHINESE}     `安装“$R2”？$\r$\n$\r$\n安装可能需要一段时间，请耐心等待。`
LangString VSIX     ${LANG_FRENCH}          `Installer « $R2 » ?$\r$\n$\r$\nL'installation peut prendre un certain temps, veuillez donc être patient.`
LangString VSIX     ${LANG_GERMAN}          `"$R2" installieren?$\r$\n$\r$\nDie Installation kann eine Weile dauern, haben Sie also bitte Geduld.`
LangString VSIX     ${LANG_ITALIAN}         `Installare "$R2"?$\r$\n$\r$\nL'installazione potrebbe richiedere un po' di tempo, quindi sii paziente.`
LangString VSIX     ${LANG_JAPANESE}        `「$R2」をインストールしますか?$\r$\n$\r$\nインストールにはしばらく時間がかかる場合がありますので、しばらくお待ちください。`
LangString VSIX     ${LANG_PORTUGUESEBR}    `Instalar "$R2"?$\r$\n$\r$\nA instalação pode demorar um pouco, então seja paciente.`
LangString VSIX     ${LANG_SPANISH}         `¿Instalar "$R2"?$\r$\n$\r$\nLa instalación puede tardar un poco, así que tenga paciencia.`
LangString FAILED   ${LANG_ENGLISH}         `Update check failed!$\r$\n$\r$\nYou need to update ${PORTABLEAPPNAME} manually.`
LangString FAILED   ${LANG_SIMPCHINESE}     `??????!$\r$\n$\r$\n???????${PORTABLEAPPNAME}?`
LangString FAILED   ${LANG_FRENCH}          `�chec de la v�rification de la mise � jour�!$\r$\n$\r$\nVous devez mettre � jour ${PORTABLEAPPNAME} manuellement.`
LangString FAILED   ${LANG_GERMAN}          `Aktualisierungspr�fung fehlgeschlagen!$\r$\n$\r$\nSie m�ssen ${PORTABLEAPPNAME} manuell aktualisieren.`
LangString FAILED   ${LANG_ITALIAN}         `Controllo aggiornamento fallito!$\r$\n$\r$\nDevi aggiornare ${PORTABLEAPPNAME} manualmente.`
LangString FAILED   ${LANG_JAPANESE}        `?????????????!$\r$\n$\r$\n${PORTABLEAPPNAME} ????????????????`
LangString FAILED   ${LANG_PORTUGUESEBR}    `Falha na verifica��o de atualiza��o!$\r$\n$\r$\nVoc� precisa atualizar ${PORTABLEAPPNAME} manualmente.`
LangString FAILED   ${LANG_SPANISH}         `�Error en la verificaci�n de actualizaci�n!$\r$\n$\r$\nNecesitas actualizar ${PORTABLEAPPNAME} manualmente.`
LangString UPDATE   ${LANG_ENGLISH}         `A new version of ${FULLNAME} is available!$\r$\n$\r$\nDo you want to update now?`
LangString UPDATE   ${LANG_SIMPCHINESE}     `${FULLNAME} ??????!$\r$\n$\r$\n????????`
LangString UPDATE   ${LANG_FRENCH}          `Une nouvelle version de ${FULLNAME} est disponible�!$\r$\n$\r$\nVoulez-vous mettre � jour maintenant�?`
LangString UPDATE   ${LANG_GERMAN}          `Eine neue Version von ${FULLNAME} ist verf�gbar!$\r$\n$\r$\nM�chten Sie jetzt aktualisieren?`
LangString UPDATE   ${LANG_ITALIAN}         `� disponibile una nuova versione di ${FULLNAME}!$\r$\n$\r$\nVuoi aggiornare adesso?`
LangString UPDATE   ${LANG_JAPANESE}        `${FULLNAME} ????????????????!$\r$\n$\r$\n??????????`
LangString UPDATE   ${LANG_PORTUGUESEBR}    `Uma nova vers�o de ${FULLNAME} est� dispon�vel!$\r$\n$\r$\nGostaria de atualizar agora?`
LangString UPDATE   ${LANG_SPANISH}         `�Hay una nueva versi�n de ${FULLNAME} disponible!$\r$\n$\r$\n�Le gustar�a actualizar ahora?`
LangString FINISHED ${LANG_ENGLISH}         `${FULLNAME} has been updated successfully$\r$\n$\r$\nNow launching ${PORTABLEAPPNAME}.`
LangString FINISHED ${LANG_SIMPCHINESE}     `${FULLNAME} ?????$\r$\n$\r$\n????${PORTABLEAPPNAME}?`
LangString FINISHED ${LANG_FRENCH}          `${FULLNAME} a �t� mis � jour avec succ�s$\r$\n$\r$\nLancement maintenant de ${PORTABLEAPPNAME}.`
LangString FINISHED ${LANG_GERMAN}          `${FULLNAME} wurde erfolgreich aktualisiert$\r$\n$\r$\n${PORTABLEAPPNAME} wird jetzt gestartet.`
LangString FINISHED ${LANG_ITALIAN}         `${FULLNAME} � stato aggiornato con successo$\r$\n$\r$\nAvvio di ${PORTABLEAPPNAME} in fase di avvio.`
LangString FINISHED ${LANG_JAPANESE}        `${FULLNAME} ???????????$\r$\n$\r$\n${PORTABLEAPPNAME} ???????`
LangString FINISHED ${LANG_PORTUGUESEBR}    `${FULLNAME} foi atualizado com sucesso$\r$\n$\r$\nAgora iniciando ${PORTABLEAPPNAME}.`
LangString FINISHED ${LANG_SPANISH}         `${FULLNAME} se ha actualizado correctamente$\r$\n$\r$\nAhora iniciamos ${PORTABLEAPPNAME}.`
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

;= INCLUDES
;= ################

;= MACROS
;= ################

;= FUNCTIONS
;= ################
Function GetIconIndex
	!macro _GetIconIndex _TYPE
		Push ${_TYPE}
		Call GetIconIndex
		Pop ${_TYPE}
	!macroend
	!define GetIconIndex "!insertmacro _GetIconIndex"
	Exch $0
	StrCmpS $0 log END
	StrCmpS $0 mapimail END
	StrCmpS $0 txt END
	StrCmpS $0 ini END
	StrCmpS $0 inf END
	StrCmpS $0 h END
	StrCmpS $0 hh END
	StrCmpS $0 hpp END
	StrCmpS $0 hxx END
	StrCmpS $0 c END
	StrCmpS $0 cpp END
	StrCmpS $0 cxx END
	StrCmpS $0 cc END
	StrCmpS $0 m END
	StrCmpS $0 mm END
	StrCmpS $0 vcxproj END
	StrCmpS $0 vcproj END
	StrCmpS $0 props END
	StrCmpS $0 vsprops END
	StrCmpS $0 manifest END
	StrCmpS $0 java END
	StrCmpS $0 cs END
	StrCmpS $0 pas END
	StrCmpS $0 pp END
	StrCmpS $0 inc END
	StrCmpS $0 html END
	StrCmpS $0 htm END
	StrCmpS $0 shtml END
	StrCmpS $0 shtm END
	StrCmpS $0 hta END
	StrCmpS $0 asp END
	StrCmpS $0 aspx END
	StrCmpS $0 css END
	StrCmpS $0 js END
	StrCmpS $0 json END
	StrCmpS $0 jsm END
	StrCmpS $0 jsp END
	StrCmpS $0 php END
	StrCmpS $0 php3 END
	StrCmpS $0 php4 END
	StrCmpS $0 phps END
	StrCmpS $0 phpt END
	StrCmpS $0 phtml END
	StrCmpS $0 xml END
	StrCmpS $0 xhtml END
	StrCmpS $0 xht END
	StrCmpS $0 sul END
	StrCmpS $0 kml END
	StrCmpS $0 xaml END
	StrCmpS $0 xsml END
	StrCmpS $0 sh END
	StrCmpS $0 bsh END
	StrCmpS $0 bash END
	StrCmpS $0 bat END
	StrCmpS $0 cmd END
	StrCmpS $0 nsi END
	StrCmpS $0 nsh END
	StrCmpS $0 lua END
	StrCmpS $0 pl END
	StrCmpS $0 pm END
	StrCmpS $0 py END
	StrCmpS $0 rc END
	StrCmpS $0 as END
	StrCmpS $0 mx END
	StrCmpS $0 vb END
	StrCmpS $0 vbs END
	StrCmpS $0 f END
	StrCmpS $0 for END
	StrCmpS $0 f90 END
	StrCmpS $0 f95 END
	StrCmpS $0 f2k END
	StrCmpS $0 tex END
	StrCmpS $0 sql END
	StrCmpS $0 nfo END
	StrCmpS $0 mak END
	StrCpy $0 error
	END:
	Exch $0
FunctionEnd
Function Elevate
	StrCmpS $SecondaryLaunch true 0 +2
	Return
	StrCpy $RunAsAdmin force
	Elevate:
	!insertmacro UAC_RunElevated
	${Switch} $0
		${Case} 0
			${IfThen} $1 = 1 ${|} Quit ${|}
			${If} $3 <> 0
				${Break}
			${EndIf}
			${If} $1 = 3
				MessageBox MB_RETRYCANCEL|MB_ICONEXCLAMATION|MB_TOPMOST|MB_SETFOREGROUND \ 
				"$(LauncherRequiresAdmin)$\r$\n$\r$\n$(LauncherNotAdminTryAgain)" IDRETRY Elevate
				Quit
			${EndIf}
		${CaseUACCodeAlert} 1223 \
			"$(LauncherRequiresAdmin)" \
			"$(LauncherNotAdminLimitedFunctionality)"
		${CaseUACCodeAlert} 1062 \
			"$(LauncherAdminLogonServiceNotRunning)" \
			"$(LauncherNotAdminLimitedFunctionality)"
		${CaseUACCodeAlert} "" \
			"$(LauncherAdminError)$\r$\n$(LauncherRequiresAdmin)" \
			"$(LauncherAdminError)$\r$\n$(LauncherNotAdminLimitedFunctionality)"
	${EndSwitch}
FunctionEnd

;= CUSTOM
;= ################
${SegmentFile}
${Segment.OnInit}
	ClearErrors
	ReadRegDWORD $0 HKLM `${oNET}` `Release`
	IfErrors +2
	IntCmp $0 378389 +4 0 +4
	MessageBox MB_ICONSTOP|MB_TOPMOST `$(NET)`
	Call Unload
	Quit
!macroend
!macro OS
	${If} ${IsNT}
		${IfNot} ${AtLeastWin7}
			MessageBox MB_ICONSTOP|MB_TOPMOST `$(OS)`
			Call Unload
			Quit
		${EndIf}
	${Else}
		MessageBox MB_ICONSTOP|MB_TOPMOST `$(OS)`
		Call Unload
		Quit
	${EndIf}
!macroend
!macro Init
    ExpandEnvStrings "$CmdPath" "%COMSPEC%"
	${ConfigReads} `${CONFIG}` Banner= $0
	StrCmpS $0 true 0 +6
	Banner::show ""
	Banner::getWindow
	Pop $0
	GetDlgItem $0 $0 1030
	SendMessage $0 ${WM_SETTEXT} 0 "STR:$(i)"
	${Init::File} code\User settings.json
	${Init::File} Fonts .Portable.Fonts.txt
!macroend
${SegmentPre}
    ;=# 
    ;= TODO :
    ; Rewrite this functionality as it's own
    ; segment in PortableApps Compiler allowing
    ; the launcher to check for a new version
    ; of the app by means of custom code.
    ;= NOTE : 
    ; This is extremely experimental! Meaning
    ; this will have bugs. If you find yourself
    ; stepping on a bug, please let me know. So
    ; forgive me as I'm rusty.
    ;= THNX :
    ;=#
	${ConfigReads} `${CONFIG}` UpdateCheck= $0
	StrCmpS $0 true 0 _FINISHED
    ${ReadAppInfoConfig} $LocalVersion "Version" "DisplayVersion"
    File /oname=${jq} Contrib\bin\jq.exe
    ${If} ${AtLeastWin10}
        nsExec::ExecToStack `cmd /C "${cURLS} --no-progress-meter ${URL} | ${jq} -r .name"`
    ${Else}
        File /oname=${cURLP} Contrib\bin\curl.exe
        nsExec::ExecToStack `cmd /C "${cURLP} --no-progress-meter ${URL} | ${jq} -r .name"`
	${EndIf}
	Pop $0
	Pop $1
	${TRIM} $2 $1
    StrCpy $RemoteVersion $2
    StrCmp $LocalVersion $RemoteVersion _MATCH _DIFFER
    _MATCH:
        Goto _FINISHED
        
    _FAILED:
        MessageBox MB_ICONSTOP|MB_TOPMOST `$(FAILED)`
        IfFileExists `$EXEDIR\App\${APP}` 0 +2
        RMDir /r `$EXEDIR\App\${APP}`
        IfFileExists `$EXEDIR\App\${APP}-backup\*.*` 0 +2
        Rename "$EXEDIR\App\${APP}-backup" "$EXEDIR\App\${APP}"
        Goto _FINISHED
        
    _DIFFER:
        MessageBox MB_USERICON|MB_YESNO|MB_TOPMOST `$(UPDATE)` IDYES _UPDATE IDNO _FINISHED

    _UPDATE:    
        Banner::show ""
        Banner::getWindow
        Pop $0
        GetDlgItem $0 $0 1030
        SendMessage $0 ${WM_SETTEXT} 0 "STR:$(DOWNLOAD)"
        Push $0
        Push $1
        ${If} ${AtLeastWin10}
            nsExec::ExecToStack `${cURLS} --no-progress-meter -L --output-dir "$EXEDIR" -o "${ZIP}" "${DOWNLOAD}"`
        ${Else}
            nsExec::ExecToStack `${cURLP} --no-progress-meter -L --output-dir "$EXEDIR" -o "${ZIP}" "${DOWNLOAD}"`
        ${EndIf}
        Pop $0
        Pop $1
        Banner::destroy
        Sleep 1000
        ${If} ${FileExists} "${VSZIP}"
            Banner::show ""
            Banner::getWindow
            Pop $0
            GetDlgItem $0 $0 1030
            SendMessage $0 ${WM_SETTEXT} 0 "STR:$(UPDATING)"
            ClearErrors
            Rename "$EXEDIR\App\${APP}" "$EXEDIR\App\${APP}-backup"
            Sleep 500
            CreateDirectory "$EXEDIR\App\${APP}"
            File /oname=${7z} Contrib\bin\7z.exe
            nsExec::Exec `cmd /C "${7z} x ${VSZIP} -aoa -o$EXEDIR\App\${APP}"`
            Pop $0
            Banner::destroy
            ${If} $0 == 0
                ${WriteAppInfoConfig} "Version" "DisplayVersion" "$RemoteVersion"
                ${WriteAppInfoConfig} "Version" "PackageVersion" "$RemoteVersion.0"
                MessageBox MB_ICONINFORMATION|MB_TOPMOST `$(FINISHED)`
                Delete "${VSZIP}"
                Goto _FINISHED
            ${Else}
                Goto _FAILED
            ${EndIf}
        ${Else}
            Goto _FAILED
        ${EndIf}
    _FINISHED:
!macroend
${SegmentPrePrimary}
    ${File::BackupLocal} `${SND}`
    CreateShortCut `${SND}` `${EXE}` "" `${EXE}` 0
!macroend
!macro PreExecExecute
	Push `${CONFIG}`
	Push Banner=
	Call ReadS
	Pop $0
	StrCmpS $0 true 0 +3
	StrCmpS $SecondaryLaunch true +2
	Banner::destroy
	;=#
	;= Detect Environments
	; Git
	${ConfigReads} `${CONFIG}` GIT= $GitDir
	ExpandEnvStrings "$GitDir" "$GitDir"
	${If} ${FileExists} "$GitDir\cmd\git.exe"
		${ConfigReads} `${CONFIG}` GitHomePath= $GitHome
		${If} "$GitHome" == "true"
			CreateDirectory "${DATA}\Git\home"
			; If not set, the default is "%UserProfile%"
			${SetEnvironmentVariablesPath} "HOME" "${DATA}\Git\home"
			; Also copy custom shell config files on first run (contains workaround for "cd" command)
			; These files may be overwritten by Oh My Zsh, so you may need to re-add the "cd" alias manually
			${IfNot} ${FileExists} "${DATA}\Git\home\.bashrc"
				CopyFiles /Silent "${DEFDATA}\Git\home\.bashrc" "${DATA}\Git\home"
			${EndIf}
		${EndIf}
		${If} ${FileExists} "$GitDir\post-install.bat"
			; Portable Git post installation
			; Cmd crazily remove quotes so nesting it will be needed
			nsExec::Exec '"$CmdPath" /C ""$GitDir\post-install.bat""'
		${EndIf}
		; Initial value to be added to "PATH"
		StrCpy "$ExtraPath" "$GitDir\bin;$GitDir\cmd"
	${EndIf}
    ; Python
	${ConfigReads} `${CONFIG}` PYTHON= $PythonDir
	ExpandEnvStrings "$PythonDir" "$PythonDir"
	${If} ${FileExists} "$PythonDir\python.exe"
        ${ConfigReads} `${CONFIG}` PythonUserPath= $PythonUser
		${If} "$PythonUser" == "true"
			; Change Python user's base directory (the default is "%AppData%\Python")
			; Will not affect globally installed packages (local user packages only)
			${SetEnvironmentVariablesPath} "PYTHONUSERBASE" "${DATA}\Python"
		${EndIf}
		; Get user "scripts" directory and add it to "PATH"
		nsExec::ExecToStack '"$PythonDir\python.exe" -m site --user-site'
		Pop $R1
		${If} $R1 == 0
			Pop $R2
			${GetParent} $R2 $R2
			StrCpy "$ExtraPath" "$ExtraPath;$PythonDir;$PythonDir\scripts;$R2\scripts"
		${Else}
			StrCpy "$ExtraPath" "$ExtraPath;$PythonDir;$PythonDir\scripts"
		${EndIf}
		ExpandEnvStrings "$PythonPath" "%PYTHONPATH%"
		${If} "$PythonPath" == ""
			StrCpy "$PythonPath" "$PythonDir\lib;$PythonDir\dlls"
		${Else}
			StrCpy "$PythonPath" "$PythonDir\lib;$PythonDir\dlls;$PythonPath"
		${EndIf}
	${EndIf}
    ; Node.js
	${ConfigReads} `${CONFIG}` NODEJS= $NodeJSDir
	ExpandEnvStrings "$NodeJSDir" "$NodeJSDir"
	${If} ${FileExists} "$NodeJSDir\node.exe"
		${ConfigReads} `${CONFIG}` NodePrefixPath= $NodePrefix
		${If} "$NodePrefix" == "true"
			; Force change Node.js user's prefix and cache path
			; If not changed, the default is "%AppData%\npm" and "%AppData%\npm-cache"
			; May be dangerous on shared computer, as it will write its config to "%UserProfile%\.npmrc"
			nsExec::Exec '"$CmdPath" /C ""$NodeJSDir\npm.cmd" config set prefix "${DATA}\Node.js\npm""'
			nsExec::Exec '"$CmdPath" /C ""$NodeJSDir\npm.cmd" config set cache "${DATA}\Node.js\npm-cache""'
		${EndIf}
		; Get prefix directory and add it to "PATH"
		nsExec::ExecToStack '"$CmdPath" /C ""$NodeJSDir\npm.cmd" config get prefix"'
		Pop $R1
		${If} $R1 == 0
			Pop $R2
			; Trim trailing newline from npm output
			; This will break cmd if left untouched
			${TrimNewLines} $R2 $R2
			StrCpy "$ExtraPath" "$ExtraPath;$NodeJSDir;$R2"
		${Else}
			StrCpy "$ExtraPath" "$ExtraPath;$NodeJSDir"
		${EndIf}
	${EndIf}
	; Add environments with the %PATH%
	; This %PATH% will only be used by VSCode Portable
	StrLen $R1 "$ExtraPath_$BasePath_"
	IntOp $R1 $R1 * ${NSIS_CHAR_SIZE}
	${If} $R1 < ${NSIS_MAX_STRLEN}
		${SetEnvironmentVariablesPath} "PATH" "$ExtraPath;$BasePath"
	${Else}
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(PATH)`
	${EndIf}
	; Set or modify "PYTHONPATH"
	${SetEnvironmentVariablesPath} "PYTHONPATH" "$PythonPath"
	; On first initial launch, Install any  VSIX files to the 
	; extensions folder if the user configuration premits it
	${ConfigReads} `${CONFIG}` InstallVSIX= $0
	${If} $0 == true
        ${IfNot} ${FileExists} "${DATA}\code\extensions\*.*"
            FindFirst $R1 $R2 "${DEFDATA}\extensions\*.vsix"
            _CHECKVSIX:
            ${If} $R2 != ""
                MessageBox MB_YESNO|MB_ICONQUESTION `$(VSIX)` IDNO +2
                ExecWait '"$CmdPath" /C ""$EXEDIR\App\${APP}\bin\code.cmd" --install-extension "${DEFDATA}\extensions\$R2""'
                FindNext $R1 $R2
                Goto _CHECKVSIX
            ${EndIf}
            FindClose $R1
        ${EndIf}
    ${EndIf}
!macroend
${SegmentPostPrimary}
	${File::RestoreLocal} `${SND}`
!macroend
!macro PreReg
    ${ConfigReads} `${CONFIG}` Associations= $0
	StrCmpS $0 true 0 _PREREG_SKIP
        StrCpy $0 1
        ClearErrors
        ReadINIStr $1 `${LAUNCHER}` Associations $0
        IfErrors +49
        Push $1
        Call GetIconIndex
        Pop $1
        StrCmpS $1 error +43
        StrCpy $2 1
        IfFileExists `${RUNTIME}` 0 +3
        ReadINIStr $3 `${RUNTIME}` Associations $2
        Goto +2
        ReadINIStr $3 `${RUNTIME2}` Associations $2
        StrCmpS $3 "" +3
        IntOp $2 $2 + 1
        Goto -6
        WriteINIStr `${RUNTIME}` Associations $2 $1
        WriteINIStr `${RUNTIME2}` Associations $2 $1
        Registry::_KeyExists /NOUNLOAD `${_}\${ULS}\.$1`
        Pop $2
        StrCmpS $2 -1 0 +6
        Registry::_KeyExists /NOUNLOAD `${ULS}\.$1`
        Pop $2
        StrCmpS $2 0 0 +3
        Registry::_MoveKey /NOUNLOAD `${ULS}\.$1` `${_}\${ULS}\.$1`
        Pop $2
        Registry::_KeyExists /NOUNLOAD `${_}\${ULS}\${APP}.$1`
        Pop $2
        StrCmpS $2 -1 0 +6
        Registry::_KeyExists /NOUNLOAD `${ULS}\${APP}.$1`
        Pop $2
        StrCmpS $2 0 0 +3
        Registry::_MoveKey /NOUNLOAD `${ULS}\${APP}.$1` `${_}\${ULS}\${APP}.$1`
        Pop $2
        Registry::_KeyExists /NOUNLOAD `${_}\${EXT}\.$1`
        Pop $2
        StrCmpS $2 -1 0 +6
        Registry::_KeyExists /NOUNLOAD `${EXT}\.$1`
        Pop $2
        StrCmpS $2 0 0 +3
        Registry::_MoveKey /NOUNLOAD `${EXT}\.$1` `${_}\${EXT}\.$1`
        Pop $2
        Registry::_KeyExists /NOUNLOAD `${_}\${EXTS}\.$1`
        Pop $2
        StrCmpS $2 -1 0 +6
        Registry::_KeyExists /NOUNLOAD `${EXTS}\.$1`
        Pop $2
        StrCmpS $2 0 0 +3
        Registry::_MoveKey /NOUNLOAD `${EXTS}\.$1` `${_}\${EXTS}\.$1`
        Pop $2
        IntOp $0 $0 + 1
        Goto -50
    _PREREG_SKIP:
!macroend
!macro UnPreRegWrite
    ${ConfigReads} `${CONFIG}` Associations= $0
	StrCmpS $0 true 0 _UNPREREG_WRITE_SKIP
	    StrCpy $0 1
		IfFileExists `${RUNTIME}` 0 +4
		ClearErrors
		ReadINIStr $1 `${RUNTIME}` Associations $0
		Goto +3
		ClearErrors
		ReadINIStr $1 `${RUNTIME2}` Associations $0
		IfErrors +11
			Push $1
			Call GetIconIndex
			Pop $1
		WriteRegStr HKCU `${CL}\.$1` "" ${APP}.$1
		WriteRegStr HKCU `${CL}\${APP}.$1\DefaultIcon` "" `${EXE}`
		WriteRegStr HKCU `${CL}\${APP}.$1\shell\open` "" `${APP}`
		WriteRegStr HKCU `${CL}\${APP}.$1\shell\open` Icon `${EXE}`
		WriteRegStr HKCU `${CL}\${APP}.$1\shell\open\command` "" `"${EXE}" "%1"`
		IntOp $0 $0 + 1
	    Goto -16
    _UNPREREG_WRITE_SKIP:
!macroend
!macro PostReg
    ${ConfigReads} `${CONFIG}` Associations= $0
	StrCmpS $0 true 0 _POSTREG_SKIP
        StrCpy $0 1
            IfFileExists `${RUNTIME}` 0 +4
            ClearErrors
            ReadINIStr $1 `${RUNTIME}` Associations $0
            Goto +3
            ClearErrors
            ReadINIStr $1 `${RUNTIME2}` Associations $0
            IfErrors +59
            Registry::_DeleteKey /NOUNLOAD `${ULS}\.$1`
            Pop $2
            Registry::_KeyExists /NOUNLOAD `${_}\${ULS}\.$1`
            Pop $2
            StrCmpS $2 0 0 +10
                Registry::_MoveKey /NOUNLOAD `${_}\${ULS}\.$1` `${ULS}\.$1`
                Pop $2
                    StrCpy $3 `${ULS}\.$1`
                    Push `$3`
                    Call Get.Parent
                    Pop $3
                    Registry::_DeleteKeyEmpty /NOUNLOAD `${_}\$3`
                    Pop $2
                StrCmpS $3 "" 0 -5
            Registry::_DeleteKey /NOUNLOAD `${ULS}\${APP}.$1`
            Pop $2
            Registry::_KeyExists /NOUNLOAD `${_}\${ULS}\${APP}.$1`
            Pop $2
            StrCmpS $2 0 0 +10
                Registry::_MoveKey /NOUNLOAD `${_}\${ULS}\${APP}.$1` `${ULS}\${APP}.$1`
                Pop $2
                    StrCpy $3 `${ULS}\${APP}.$1`
                    Push `$3`
                    Call Get.Parent
                    Pop $3
                    Registry::_DeleteKeyEmpty /NOUNLOAD `${_}\$3`
                    Pop $2
                StrCmpS $3 "" 0 -5
            Registry::_DeleteKey /NOUNLOAD `${EXT}\.$1`
            Pop $2
            Registry::_KeyExists /NOUNLOAD `${_}\${EXT}\.$1`
            Pop $2
            StrCmpS $2 0 0 +10
                Registry::_MoveKey /NOUNLOAD `${_}\${EXT}\.$1` `${EXT}\.$1`
                Pop $2
                StrCpy $3 `${EXT}\.$1`
                    Push `$3`
                    Call Get.Parent
                    Pop $3
                    Registry::_DeleteKeyEmpty /NOUNLOAD `${_}\$3`
                    Pop $2
                StrCmpS $3 "" 0 -5
            Registry::_DeleteKey /NOUNLOAD `${EXTS}\.$1`
            Pop $2
            Registry::_KeyExists /NOUNLOAD `${_}\${EXTS}\.$1`
            Pop $2
            StrCmpS $2 0 0 +10
                Registry::_MoveKey /NOUNLOAD `${_}\${EXTS}\.$1` `${EXTS}\.$1`
                Pop $2
                StrCpy $3 `${EXTS}\.$1`
                    Push `$3`
                    Call Get.Parent
                    Pop $3
                    Registry::_DeleteKeyEmpty /NOUNLOAD `${_}\$3`
                    Pop $2
                StrCmpS $3 "" 0 -5
            IntOp $0 $0 + 1
        Goto -64
        Registry::_DeleteKeyEmpty /NOUNLOAD ${_}
        Pop $2
        Registry::_DeleteKeyEmpty /NOUNLOAD ${PAF}
        Pop $2
    _POSTREG_SKIP:
!macroend
${SegmentUnload}
	FindFirst $0 $1 `$LOCALAPPDATA\Microsoft\*`
	StrCmpS $0 "" +12
	StrCmpS $1 "" +11
	StrCmpS $1 "." +8
	StrCmpS $1 ".." +7
	StrCpy $2 $1 3
	StrCmpS $2 CLR 0 +5
	IfFileExists `$LOCALAPPDATA\Microsoft\$1\UsageLogs\${APP}.exe.log` 0 +2
	Delete `$LOCALAPPDATA\Microsoft\$1\UsageLogs\*.log`
	RMDir `$LOCALAPPDATA\Microsoft\$1\UsageLogs`
	RMDir `$LOCALAPPDATA\Microsoft\$1`
	FindNext $0 $1
	Goto -10
	FindClose $0
!macroend
