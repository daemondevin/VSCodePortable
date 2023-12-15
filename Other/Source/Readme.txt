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