# AlBaraaHR

تطبيق سطح مكتب بسيط لإدارة الموظفين (WPF, .NET 8, SQL Server).

التغييرات الرئيسية في هذا الإصدار:
- دعم SQL Server (LocalDB افتراضي وSQL Server Express كخيار احترافي).
- التطبيق يقرأ سلسلة الاتصال من App/appsettings.json (مفتاح ConnectionStrings:DefaultConnection).
- المثبّت (Installer/setup.iss) يعرض صفحة اختيار تثبيت LocalDB أو SQL Server Express وينزل المثبّتات الرسمية أثناء التثبيت.

ملاحظة مهمة حول روابط التنزيل في Installer/setup.iss:
- السكربت يستخدم روابط "placeholder" (روابط توجيه عامة). يُفضّل تحديث الروابط إلى روابط Microsoft الرسمية الخاصة بالإصدار الذي تريد توزيعه (مثال: SQL Server 2022 Express أو LocalDB).

البناء وتشغيل محلي:
1. انتقل إلى مجلد App:
   cd App
2. استعادة الحزم وبناء:
   dotnet restore
   dotnet build -c Release
3. تشغيل:
   dotnet run

نشر (ينتج EXE واحد self-contained):
 dotnet publish AlBaraaHR.csproj -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true -p:EnableCompressionInSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true -p:PublishReadyToRun=true --output Publish

بعد النشر:
- شغّل Inno Setup عبر ISCC.exe على Installer\setup.iss لبناء المثبّت النهائي.
- أثناء التثبيت سيُطلب من المستخدم اختيار LocalDB أو SQL Server Express؛ ويقوم المثبّت بتنزيل وتثبيت المُكوّنات المطلوبة بصمت.

ملاحظات أمان:
- تثبيت SQL Server Express يتطلب امتيازات مسؤولي (admin). سكربت المثبّت يضبط PrivilegesRequired=admin.
- معلمات تثبيت SQL Express (ككلمة المرور وعناصر التهيئة) هي أمثلة ويمكن تخصيصها أو مطالبة المستخدم بتحديدها أثناء التثبيت.
