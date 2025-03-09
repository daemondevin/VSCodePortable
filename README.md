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
* Associate compatible filetypes on launch for use when using VS Code Portable (See [Associations](#associations) below)
* Automatically install VSIX extentions on first launch. (See [VSIX Installations](#vsix-installs) below)
* Self-sustaining; no need to update this package as it should update itself.

## System Requirements
* Microsoft Windows 7 or later.
* At least v4.5 of the .NET Framework
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
Associations=true
UpdateCheck=true
InstallVSIX=false

#= Environment Settings
; Uncomment below congifurations to make use of it's setting
;GIT=%PAL:CommonFiles%\Git
;PYTHON=%PAL:CommonFiles%\Python
;NODEJS=%PAL:CommonFiles%\Node.js

#= Advanved Settings
; Uncomment below congifurations to make use of it's setting (true|false)
;GitHomePath=true
;PythonUserPath=true
;NodePrefixPath=true

#= Banner=
; Enable or disable Initialization Banner.

#= UpdateCheck=
; Enable or disable automatic portable updating (true|false).

#= InstallVSIX=
; Enable or disable the installation of VSIX files 
; in .\App\DefaultData\extensions (true|false)

#= Associations=
; Optionally turn on/off filetype associations (true|false).
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
- To install **VSIX extensions** on the *first initial* launch of VS Code Portable, be sure to set `InstallVSIX` to _true_ in the optional user configuration file located in the base directory (i.e. `VSCodePortable\VSCodePortable.ini`).
  - Refer to [Configuration](#configuration) to read more.
- Put any VSIX extension file in the **default data directory** under the **extensions** folder located at `.\App\DefaultData\extentions` 
  - Any file with an extension of `.vsix` will automatically be installed in the VS Code extensions directory for use with Visual Studio Code.
    - You can find this directory in `.\Data\code\extensions`

## Associations
> [!IMPORTANT]
> Do ***not*** associate any filetypes through the Visual Studio Code application. Doing so will cause trash to remain in the **Windows Registry** after exiting VSCode Portable. 

- Enable associations in the optional user configuration file located in the base directory (i.e. `VSCodePortable\VSCodePortable.ini`).
  - Refer to [Configuration](#configuration) to read more.
- The Launcher has been designed without administrative privilege dependency. Features which require elevated privileges have been made optional in the optional user configuration file.
  - Refer to [Configuration](#configuration) to read more.

### Setup
To have VSCode Portable associate compatible filetypes for use with Visual Studio Code just follow these simple steps:

1. Navigate to: `.\App\AppInfo\Launcher`
2. Open `VSCodePortable.ini` with Notepad or any text editor
3. Scroll down to: `[Associations]`
4. Simply add desired association underneath in numerical sequential order.
   - See the [example](#example-1) for more.

### Example:
```INI
[Associations]
1=txt
2=ini
3=xml
4=js
5=css
```

### Attention:
> [!NOTE]
> - Adding too many can impact launch time.
> - Windows XP cache icons which are visible even after exiting VSCode.
> - Windows 8.0 is problematic and may require unlocking for some filetypes (i.e. _Double-click file > select VSCode from list_). This is due to Win8.0's implementation of a hash ID for associations.
> - Do not associate through Visual Studio Code! Doing so will leave trash in the Windows Registry.
> - In addition, SendTo is available for un-associated but supported filetypes.

## Credits
* Visual Studio Code Portable is a redistribution of the
  [Visual Studio Code][C1], developed by [Microsoft.][C2].
* [PortableApps.com Suite][R1] by [PortableApps.com][D2].
* [PortableApps Compiler](https://github.com/daemondevin/pac-man) developed by [daemon.devin][C3].

 [C1]: https://code.visualstudio.com/
 [C2]: https://www.microsoft.com/
 [C3]: https://github.com/daemondevin
