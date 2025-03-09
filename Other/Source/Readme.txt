;= SUPPORT
;= ################
To recompile this PAF you must use my PortableApps Compiler.

;= FEATURES
;= ################
• Runs the full Visual Studio Code desktop app.
• Completely portable - runs off a USB, cloud drive (DropBox, iCloud drive, OneDrive, etc) or hard drive.
• No need for any external software - simply download extract and run!
• Packaged in PortableApps.com format for easy integration.
• User configuration file for development environments and advanced settings (See Configuration below)
• Associate compatible filetypes on launch for use when using VSCode Portable (See Associations below)
• Automatically install VSIX extentions on first launch. (See VSIX Installations below)
• Self-sustaining; no need to update this package as it should update itself.

;= REQUIREMENTS
;= ################
• Microsoft Windows 7 or later.
• At least v4.5 of the .NET Framework
• PortableApps.com Platform (Optional)

;= CONFIGURATION
;= ################
An optional configuration file called VSCodePortable.ini is available in the ./Other/Source directory. Copy this file to the root directory next to the launcher file (VSCodePortable.exe) for custom options. A brief explanation for each option listed as follows:

ie.
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
    ; Uncomment below congifurations to make use of it's setting
    ;GitHomePath=true
    ;PythonUserPath=true
    ;NodePrefixPath=true

    #= Banner=
    ; Enable or disable Initialization Banner.

    #= UpdateCheck=
    ; Enable or disable automatic portable updating.

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

;= NOTES
;= ################
1. Do not associate through VSCode.
   Doing so will cause trash in the registry.
   Enable associations via VSCodePortable.ini (read ASSOCiATiONS below)
   Refer to VSCodePortable\App\AppInfo\Launcher\VSCodePortable.ini

The Launcher has been designed w/out Administrative Privilege dependency.

Features which require elevated privileges have been made optional.

You must specify to the Launcher, so it knows to cleanup after these features.

;= ASSOCIATIONS
;= ################
It is super easy to add associations.

1. Navigate to: VSCodePortable\App\AppInfo\Launcher
2. Open VSCodePortable.ini with Notepad or any text editor
3. Scroll down to: [Associations]
4. Simply add desired assocation underneath in numerical sequential order.

ie.
	[Associations]
	1=txt
	2=ini
	3=xml
	4=js
	5=css

Some supported filetypes are:
log, mapimail, txt, ini, inf, h, hh, hpp, hxx, c, cpp, cxx, cc, m, mm, 
vcxproj, vcproj, props, vsprops, manifest, java, cs, pas, pp, inc, html,
htm, shtml, shtm, hta, asp, aspx, css, js, json, jsm, jsp, php, php3, 
php4, phps, phpt, phtml, xml, xhtml, xht, sul, kml, xaml, xsml, sh, 
bsh, bash, bat, cmd, nsi, nsh, lua, pl, pm, py, rc, as, mx, vb, vbs, f,
for, f90, f95, f2k, tex, sql, nfo, mak

NOTES:
• Adding too many can impact launch time.
• Windows XP cache icons which are visible even after exiting VSCode.
• Windows 8.0 is problematic and may require unlocking for some filetypes:
  - Double-click file > select VSCode from list
  this is due to Win8.0's implementation of a hash id for associations
• Do not associate through VSCode!, which will leave trash in the registry.
• In addition, SendTo is available for un-associated but supported filetypes.

;= PRESERVE
;= ################
http://portableapps.com/manuals/PortableApps.comLauncher/ref/paf/installer.html

If there are any directories or files you'd like to preserve during upgrades or reinstalls:
- enter it in ..\App\AppInfo\installer.ini

Files example:
	[FilesToPreserve]
	PreserveFile1=App\file

Directories example:
	[DirectoriesToPreserve]
	PreserveDirectory1=App\directory

In addition, [DirectoriesToPreserve] & [FilesToPreserve] configurations are preserved.

;= CREDITS
;= ###############
• Visual Studio Code Portable is a redistribution of the Visual Studio Code, developed by Microsoft..
• PortableApps.com Suite by PortableApps.com
• PortableApps Compiler developed by daemon.devin
