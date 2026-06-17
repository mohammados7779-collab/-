# AlBaraaHR

تطبيق سطح مكتب بسيط لإدارة الموظفين (WPF, .NET 8, SQLite).

بناء وتشغيل محلي:
1. انتقل إلى مجلد App:
   cd App
2. استعادة الحزم وبناء:
   dotnet restore
   dotnet build -c Release
3. إنشاء/تطبيق المهاجرت (إن رغبت):
   dotnet tool install --global dotnet-ef
   dotnet ef migrations add InitialCreate
   dotnet ef database update
4. تشغيل:
   dotnet run

نشر (تولّد نفس الأشياء التي يعمل عليها ملف workflow):
dotnet publish App/AlBaraaHR.csproj -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true -p:EnableCompressionInSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true -p:PublishReadyToRun=true --output Publish

تجميع المثبّت باستخدام Inno Setup (محليًا):
- ضع ملف setup.iss داخل مجلد Installer
- شغّل Inno Setup وابدأ التجميع أو استعمل ISCC.exe:
  "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" Installer\setup.iss
