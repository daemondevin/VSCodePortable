# Visual Studio Code Portable
VS Code Portable is a portable version of the popular [Visual Studio Code](https://code.visualstudio.com/) application. 

## Support
To recompile this PAF you must use my [PortableApps Compiler][PACMAN].

 [PACMAN]: https://github.com/daemondevin/pac-man

## Download
All downloads available in the [Releases section][D1]. This portable application was packaged using a modified version of the [PortableApps.com][D2] Launcher.

 [D1]: https://github.com/daemondevin/VSCodePortable/releases/latest
 [D2]: http//portableapps.com/

## Features
* Runs the full Visual Studio Code desktop app.
* Completely portable - runs off a USB, cloud drive (DropBox, iCloud drive,
  OneDrive, etc) or hard drive.
* No need for any external software - simply download extract and run!
* Packaged in PortableApps.com format for easy integration.
* User configuration file for advanced portable settings (See [Configuration](#configuration) below)
* Allows for some developmental environments to be recognized by Visual Studio Code across various devices (See [Environments](#environments) below)
* Open with entries and an Open with Code (Portable) context menu while it runs, removed again on exit (See [Associations](#associations) below)
* Installs bundled VSIX extensions, each one once. (See [VSIX Installations](#vsix-installs) below)
* Self-sustaining; no need to update this package as it should update itself, showing the download's progress. An update that fails or is interrupted puts the previous version back.
* Crash safe: everything the launcher changes on the computer is journaled and undone on exit, or on the next launch if it was interrupted.

## System Requirements
* Microsoft Windows 10 or later.
* [PortableApps.com Platform][R1] (Optional)

 [R1]: http://portableapps.com/download

## Configuration
- An optional user configuration file called `VSCodePortable.ini` is available in the VS Code Portable root directory (i.e. `VSCodePortable\VSCodePortable.ini`). 
  - If this file somehow becomes corrupted or you just need to go back to a default state, there's a default user configuration file located in the `Source` folder located at `.\Other\Source\VSCodePortable.ini`
  - Copy this file to the root directory next to the launcher file (`VSCodePortable.exe`) to reset these options. 
- Refer to the [Example](#example) section for a brief explanation for each user configuration option.

### Example
```INI
[VSCodePortable]
AdditionalParameters=
RunLocally=false
Banner=true
FileAssociations=true
UpdateCheck=true
InstallVSIX=false

#= Environment Settings
; Uncomment the configurations below to use them
;GIT=%PAL:CommonFiles%\Git
;PYTHON=%PAL:CommonFiles%\Python
;NODEJS=%PAL:CommonFiles%\Node.js

#= Advanced Settings
; Uncomment the configurations below to use them
;GitHomePath=true
;PythonUserPath=true
;NodePrefixPath=true

#= Banner=
; Enable or disable the initialization banner.

#= UpdateCheck=
; Enable or disable automatic portable updating.

#= InstallVSIX=
; Enable or disable the installation of VSIX files found in
; .\App\DefaultData\code\extensions. Each file is offered once.

#= FileAssociations=
; Turn the Open with entries and the Open with Code (Portable) context menu
; on or off (true|false). Everything is removed again when VS Code closes.
; For more information refer to the ReadMe.txt file located at:
; .\Other\Source\ReadMe.txt

#= AdditionalParameters=
; Pass additional command-line switches.

#= RunLocally=
; Application is copied to & executed from $TEMP directory.

#= GIT=
; Path to the Git directory

#= GitHomePath=
; Change Git home path to "Data\Git\home"

#= PYTHON=
; Path to the Python directory

#= PythonUserPath=
; Change Python user path to "Data\Python"

#= NODEJS=
; Path to the NodeJS directory

#= NodePrefixPath=
; Change Node.js (npm) prefix path to "Data\Node.js\npm"
```

## Environments
VS Code Portable has support for certain development environments (i.e. `Git`, `Node.js`, etc). 

### Preconfigured Environments
To set up your development environments, follow the steps below.

1. Using your preferred text editor, open the optional user configuration file located in the base directory (i.e. `VSCodePortable\VSCodePortable.ini`).
   - Refer to [Configuration](#configuration) for more information.
2. Underneath the comment line `#= Environment Settings` you'll find some preconfigured environment options you can set.
   - Uncomment the environments that pertain to you by deleting the semi-colon at the beginning of that line.
   - Add the path to that corresponding environment after the equals symbol (e.g. `GIT=%PAL:CommonFiles%\Git`).
   - If the path doesn't exist, then that option is simply ignored.
     
> [!NOTE]
> VS Code Portable supports all **Windows** environment variables including all standard [**Portable Apps Compiler**][PACMAN] and [**PortableApps.com**][D2] ones too.
> For instance:
> - `%APPDATA%`
> - `%PAL:CommonFiles%`

> [!IMPORTANT]
> Do not point to any `bin` directories directly. This is automatically done by the **Launcher**.

> [!TIP]
> To see if you're development environment was recognized by VS Code Portable, use the Visual Studio Code terminal to check for your environment's version.
> - `git --version`

### Adding Unsupported Environments
To add support for an environment that is not preconfigured already, follow the steps below.

1. Using your preferred text editor, open the launcher configuration file located in the app directory (i.e. `VSCodePortable\App\Launcher\VSCodePortable.ini`).
   - Refer to the [Launcher.ini](https://github.com/daemondevin/pac-man?tab=readme-ov-file#launcherini) documentation section for more information.
2. Underneath the `[Environment]` section, add any necessary paths to your environment's applicable variables.
   - For instance, for **JDK** support, you could add `JAVA_HOME=%PAL:CommonFiles%\jdk-21` which would point to `X:\PortableApps\CommonFiles\jdk-21`
> [!NOTE]
> You could add your environment to the system's path environment variable by simply appending your environment's path to it.
> The following is an example of how an Android Studio/SDK environment might look.
> ```INI
> [Environment]
> ANDROID_HOME=%PAL:CommonFiles%\Android\sdk
> ANDROID_USER_HOME=%PAL:DataDir%\.android\
> STUDIO_JDK=%PAL:CommonFiles%\JDK64
> PATH=%PATH%;%ANDROID_HOME%\tools;%ANDROID_HOME%\tools\bin;%ANDROID_HOME%\platform-tools
> ```

> [!TIP]
> To see if you're development environment was recognized by VS Code Portable, use the Visual Studio Code terminal to check for your environment's version.
> - `adb version`
  - Try ensuring your environment is portable by having it's files installed in the **Portable Common Files** folder located at `X:\PortableApps

## VSIX Installs
- To install bundled **VSIX extensions**, set `InstallVSIX` to _true_ in the optional user configuration file located in the base directory (i.e. `VSCodePortable\VSCodePortable.ini`). Each file is offered once; the answer is remembered in `.\Data\code\VSIXInstalled.ini`, so a file added later is offered on the next launch.
  - Refer to [Configuration](#configuration) to read more.
- Put any VSIX extension file in the **default data directory** under the **extensions** folder located at `.\App\DefaultData\code\extensions`
  - Any file with an extension of `.vsix` will be installed in the VS Code extensions directory for use with Visual Studio Code.
    - You can find this directory in `.\Data\code\extensions`

## Associations
> [!IMPORTANT]
> Do ***not*** associate any filetypes through the Visual Studio Code application. Doing so will cause trash to remain in the **Windows Registry** after exiting VSCode Portable. 

- Associations are on by default. Turn them off with `FileAssociations=false` in the optional user configuration file located in the base directory (i.e. `VSCodePortable\VSCodePortable.ini`).
  - Refer to [Configuration](#configuration) to read more.
- Nothing needs administrator rights. Everything is written for the current user only and removed again when VS Code Portable closes, or on the next launch if it didn't close properly.
- Windows stays in charge of which program is the default: a file type that already has a default program only gets an **Open with** entry for VS Code Portable.

### Setup
The file types and context menus are declared in the launcher configuration file:

1. Navigate to: `.\App\AppInfo\Launcher`
2. Open `VSCodePortable.ini` with Notepad or any text editor
3. Edit the `Extension` list in `[FileAssociation1]`, or add `[FileAssociation2]` and so on.
   - See the [example](#example-1) and the [pac-man README](https://github.com/daemondevin/pac-man) for every key.

### Example:
```INI
[FileAssociation1]
Extension=.txt,.ini,.xml,.js,.css
ProgID=VSCodePortable.SourceFile
Description=Source File
DefaultIcon=%PAL:AppDir%\VSCode\Code.exe,0
OpenCommand="%PAL:LauncherPath%" "%1"
IfExists=skip
```

Set `IfExists=replace` to make VS Code Portable the default for those types while it runs; the previous default comes back when it closes.

### Attention:
> [!NOTE]
> - Do not associate through Visual Studio Code! Doing so will leave trash in the Windows Registry.
> - SendTo is available for every file type while VS Code Portable runs.
> - Files opened from Explorer while VS Code Portable is running open in the running window.

## Credits
* Visual Studio Code Portable is a redistribution of the
  [Visual Studio Code][C1], developed by [Microsoft.][C2].
* [PortableApps.com Suite][R1] by [PortableApps.com][D2].
* [PortableApps Compiler](https://github.com/daemondevin/pac-man) developed by [daemon.devin][C3].

 [C1]: https://code.visualstudio.com/
 [C2]: https://www.microsoft.com/
 [C3]: https://github.com/daemondevin
