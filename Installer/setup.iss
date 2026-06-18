; Inno Setup script لتجميع المثبّت
; هذا الإصدار من السكربت يعرض صفحة اختيار للمستخدم: LocalDB (أخف) أو SQL Server Express (احترافي).
; بعد الاختيار يقوم المثبّت بتنزيل مثبتات Microsoft الرسمية بصمت وتشغيلها.

[Setup]
AppName=AlBaraaHR
AppVersion=1.0.0
DefaultDirName={pf}\AlBaraaHR
DefaultGroupName=AlBaraaHR
OutputDir=Output
OutputBaseFilename=AlBaraaHR_Setup_v1.0.0
Compression=lzma
SolidCompression=yes
PrivilegesRequired=admin

[Files]
Source: "Publish\AlBaraaHR.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\AlBaraaHR"; Filename: "{app}\AlBaraaHR.exe"
Name: "{commondesktop}\AlBaraaHR"; Filename: "{app}\AlBaraaHR.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\AlBaraaHR.exe"; Description: "تشغيل AlBaraaHR"; Flags: nowait postinstall skipifsilent

[Code]
var
  SelectPage: TWizardPage;
  RadioLocalDB, RadioSQLExpress: TRadioButton;

function DownloadAndInstall(URL, TargetFile, Args: String): Boolean;
var
  PS, CmdLine: string;
  ResultCode: Integer;
begin
  // Build PowerShell command to download and run installer silently
  // Using Invoke-WebRequest to download to %TEMP% and then Start-Process to run it.
  PS := 'Try { $out = "' + TargetFile + '"; (New-Object System.Net.WebClient).DownloadFile("' + URL + '", $out); Start-Process -FilePath $out -ArgumentList "' + Args + '" -Wait -NoNewWindow; exit 0 } Catch { exit 1 }';
  CmdLine := '-NoProfile -ExecutionPolicy Bypass -Command "' + StringReplace(PS, '"', '""', [rfReplaceAll]) + '"';
  Result := Exec('powershell.exe', CmdLine, '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  // Exec returns True if the process launched; check ResultCode for success
  Result := Result and (ResultCode = 0);
end;

procedure InitializeWizard();
begin
  SelectPage := CreateCustomPage(wpSelectDir, 'خيار قاعدة البيانات', 'اختر نوع قاعدة البيانات لتثبيتها واستخدامها');

  RadioLocalDB := TRadioButton.Create(SelectPage);
  RadioLocalDB.Parent := SelectPage.Surface;
  RadioLocalDB.Left := 8;
  RadioLocalDB.Top := 8;
  RadioLocalDB.Width := SelectPage.SurfaceWidth - 16;
  RadioLocalDB.Caption := 'LocalDB (خيار خفيف، مناسب لأجهزة فردية)';
  RadioLocalDB.Checked := True;

  RadioSQLExpress := TRadioButton.Create(SelectPage);
  RadioSQLExpress.Parent := SelectPage.Surface;
  RadioSQLExpress.Left := 8;
  RadioSQLExpress.Top := RadioLocalDB.Top + 24;
  RadioSQLExpress.Width := SelectPage.SurfaceWidth - 16;
  RadioSQLExpress.Caption := 'SQL Server Express (يدعم الشبكة والنسخ الاحتياطي وإدارة أفضل)';
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  TempFile: string;
  URL: string;
  Args: string;
  OK: Boolean;
  ResultCode: Integer;
begin
  Result := True;
  if CurPageID = SelectPage.ID then
  begin
    // Ensure we run as admin for SQL Server Express install (PrivilegesRequired=admin in [Setup]).
    if RadioLocalDB.Checked then
    begin
      // LocalDB installer (مثال). نستخدم رابطًا عامًّا هنا — يُفضّل تحديث هذا الرابط إلى رابط Microsoft الرسمي عند الحاجة.
      URL := 'https://go.microsoft.com/fwlink/?linkid=866658'; // Placeholder link; please update if needed.
      TempFile := ExpandConstant('{tmp}\SqlLocalDB.exe');
      // Silent install arguments for LocalDB (per نسخة Microsoft): /Q /I or similar. Adjust if necessary.
      Args := '/qs';

      // Download and install
      OK := DownloadAndInstall(URL, TempFile, Args);
      if not OK then
      begin
        MsgBox('فشل تنزيل أو تثبيت LocalDB. يمكنك اختيار SQL Server Express أو متابعة يدوياً.', mbError, MB_OK);
        Result := False;
        exit;
      end;

      // After installing LocalDB we could create the database by running the app once or running SqlCmd scripts.
    end
    else if RadioSQLExpress.Checked then
    begin
      // SQL Server Express installer (مثال). يُرجى تحديث الرابط إلى الإصدار المرغوب (2019/2022).
      URL := 'https://go.microsoft.com/fwlink/?linkid=866662'; // Placeholder link; please update to Microsoft download link.
      TempFile := ExpandConstant('{tmp}\SqlExpress.exe');
      // Example silent args. For SQL Server Express, تخصيص الأوامر يعتمد على النسخة. هذا مثال عام.
      Args := '/QS /IACCEPTSQLSERVERLICENSETERMS /ACTION=Install /FEATURES=SQLEngine /INSTANCENAME=SQLEXPRESS /SECURITYMODE=SQL /SAPWD="P@ssw0rd!"';

      OK := DownloadAndInstall(URL, TempFile, Args);
      if not OK then
      begin
        MsgBox('فشل تنزيل أو تثبيت SQL Server Express. تأكد من اتصال الإنترنت وأعد المحاولة.', mbError, MB_OK);
        Result := False;
        exit;
      end;

      // بعد تثبيت Express يمكنك تهيئة قاعدة التطبيق (إن أردت يمكن تشغيل سكربت SQL هنا).
    end;
  end;
end;
