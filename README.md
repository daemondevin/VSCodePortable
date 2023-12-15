# Visual Studio Code Portable
VSCodePortable is a portable version of the popular [Visual Studio Code](https://code.visualstudio.com/) application. 

## Support
To recompile this PAF you must use my [PortableApps Compiler](https://github.com/daemondevin/pac-man).

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
* Self-sustaining; no need to update this package as it should update itself.

## System Requirements
* Microsoft Windows 7 or later.
* Atleast v4.5 of the .NET Framework
* [PortableApps.com Platform][R1] (Optional)

 [R1]: http://portableapps.com/download

## Configuration
An optional configuration file called `VSCodePortable.ini` is available in the `./Other/Source` directory. Copy this file to the root directory next to the launcher file (`VSCodePortable.exe`) for custom options. A brief explaination for each option listed as follows:
```INI
[VSCodePortable]
AdditionalParameters=
RunLocally=false
Banner=true
Associations=true
UpdateCheck=true

# Banner=
; Enable or disable Initialization Banner.

# UpdateCheck=
; Enable or disable automatic portable updating.

# Associations=
; Optionally turn on/off filetype associations (true|false).
; For more information refer to the ReadMe.txt file located at:
; .\Other\Source\ReadMe.txt

# AdditionalParameters=
; Pass additional command-line switches.

# RunLocally=
; Application is copied to & executed from $TEMP directory.
```

## Notes
- Do not associate any filetypes through Visual Studio Code. Doing so will cause trash in the Windows Registry. Enable associations in the optional configuration file via `VSCodePortable.ini`.
- The Launcher has been designed without administrative privilege dependency. Features which require elevated privileges have been made optional in the optional configuration file.

## Associations
To have VSCode Portable associate compatible filetypes for use with Visual Studio Code just follow these simple steps:

1. Navigate to: `.\App\AppInfo\Launcher`
2. Open `VSCodePortable.ini` with Notepad or any text editor
3. Scroll down to: `[Associations]`
4. Simply add desired assocation underneath in numerical sequential order.

#### Example:
```INI
[Associations]
1=txt
2=ini
3=xml
4=js
5=css
```

#### Attention:
- Adding too many can impact launch time.
- Windows XP cache icons which are visible even after exiting VSCode.
- Windows 8.0 is problematic and may require unlocking for some filetypes (i.e. _Double-click file > select VSCode from list_). This is due to Win8.0's implementation of a hash ID for associations.
- Do not associate through Visual Studio Code! Doing so will leave trash in the Windows Registry.
- In addition, SendTo is available for un-associated but supported filetypes.

## Credits
* Visual Studio Code Portable is a redistribution of the
  [Visual Studio Code][C1], developed by [Microsoft.][C2].
* [PortableApps.com Suite][R1] by [PortableApps.com][D2].
* [PortableApps Compiler](https://github.com/daemondevin/pac-man) developed by [daemon.devin][C3].

 [C1]: https://code.visualstudio.com/
 [C2]: https://www.microsoft.com/
 [C3]: https://github.com/daemondevin
