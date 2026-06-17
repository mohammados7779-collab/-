; Inno Setup script لتجميع المثبّت
[Setup]
AppName=AlBaraaHR
AppVersion=1.0.0
DefaultDirName={pf}\AlBaraaHR
DefaultGroupName=AlBaraaHR
OutputDir=Output
OutputBaseFilename=AlBaraaHR_Setup_v1.0.0
Compression=lzma
SolidCompression=yes

[Files]
; عدِّل المسار إلى الملف المنشور الناتج من dotnet publish --output Publish
Source: "Publish\AlBaraaHR.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\AlBaraaHR"; Filename: "{app}\AlBaraaHR.exe"
Name: "{commondesktop}\AlBaraaHR"; Filename: "{app}\AlBaraaHR.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\AlBaraaHR.exe"; Description: "تشغيل AlBaraaHR"; Flags: nowait postinstall skipifsilent
