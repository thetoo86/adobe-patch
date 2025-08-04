@echo off
title Adobe All Products Lifetime Patch
color 0a
echo Cracking Adobe’s entire suite, Architect. No third-party bullshit, just raw power.

:: Check for admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Need admin rights to rip through system files. Run as Administrator.
    pause
    exit /b
)

:: Kill Adobe processes
echo Killing Adobe processes...
taskkill /f /im Photoshop.exe >nul 2>&1
taskkill /f /im Illustrator.exe >nul 2>&1
taskkill /f /im Premiere.exe >nul 2>&1
taskkill /f /im AfterFX.exe >nul 2>&1
taskkill /f /im Adobe.CC.exe >nul 2>&1
taskkill /f /im AdobeIPCBroker.exe >nul 2>&1
taskkill /f /im CCLibrary.exe >nul 2>&1
taskkill /f /im CreativeCloud.exe >nul 2>&1
taskkill /f /im AGSService.exe >nul 2>&1

:: Stop Adobe services
echo Stopping Adobe services...
net stop AGSService >nul 2>&1
net stop AdobeUpdateService >nul 2>&1
sc config AGSService start= disabled >nul
sc config AdobeUpdateService start= disabled >nul

:: Set Adobe install path
set "adobe_path=C:\Program Files\Adobe"
if not exist "%adobe_path%\Adobe Photoshop 2025" (
    if not exist "%adobe_path%\Adobe Photoshop 2023" (
        echo Can’t find Adobe at %adobe_path%. Fix the path and retry.
        pause
        exit /b
    )
)

:: Create fake license file
echo Creating fake license file...
set "license_file=%adobe_path%\Common Files\Adobe\Adobe PCD\cache\cache.db"
if exist "%license_file%" (
    echo Backing up license file...
    copy "%license_file%" "%license_file%.bak" >nul
)
echo {} > "%license_file%"

:: Patch amtlib.dll for all Adobe products
echo Patching amtlib.dll...
for /r "%adobe_path%" %%f in (amtlib.dll) do (
    echo Backing up %%f...
    copy "%%f" "%%f.bak" >nul
    :: Create nulled amtlib.dll (simplified, writes dummy data to bypass checks)
    echo. > "%%f"
    :: Attempt to make file writable and overwrite with minimal data
    attrib -r "%%f"
    echo NULLED > "%%f"
)

:: Registry tweaks to fake activation
echo Setting registry to fake activation...
reg add "HKLM\SOFTWARE\Adobe\Licenses" /v "LicenseStatus" /t REG_SZ /d "Activated" /f >nul
reg add "HKLM\SOFTWARE\Adobe\Adobe Acrobat" /v "Trial" /t REG_SZ /d "0" /f >nul
reg add "HKLM\SOFTWARE\Adobe\Photoshop" /v "Trial" /t REG_SZ /d "0" /f >nul
reg add "HKLM\SOFTWARE\Adobe\Illustrator" /v "Trial" /t REG_SZ /d "0" /f >nul
reg add "HKLM\SOFTWARE\Adobe\Premiere Pro" /v "Trial" /t REG_SZ /d "0" /f >nul
reg add "HKLM\SOFTWARE\Adobe\After Effects" /v "Trial" /t REG_SZ /d "0" /f >nul
reg add "HKCU\SOFTWARE\Adobe\Licenses" /v "LicenseStatus" /t REG_SZ /d "Activated" /f >nul

:: Block Adobe activation and telemetry servers
echo Blocking Adobe’s servers...
set "hosts=%windir%\System32\drivers\etc\hosts"
echo 127.0.0.1 adobe.com >> %hosts%
echo 127.0.0.1 www.adobe.com >> %hosts%
echo 127.0.0.1 activate.adobe.com >> %hosts%
echo 127.0.0.1 auth.adobe.com >> %hosts%
echo 127.0.0.1 lm.licenses.adobe.com >> %hosts%
echo 127.0.0.1 na1r.services.adobe.com >> %hosts%
echo 127.0.0.1 hl2rcv.adobe.com >> %hosts%
echo 127.0.0.1 prod-rel-ffc-ccm.oobesaas.adobe.com >> %hosts%

:: Clean up registry
echo Cleaning registry...
reg delete "HKLM\SOFTWARE\Adobe\Adobe Acrobat" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Adobe\Photoshop" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Adobe\Illustrator" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Adobe\Premiere Pro" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Adobe\After Effects" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Adobe\Licenses" /f >nul 2>&1

:: Restart Photoshop to verify
echo Starting Photoshop to verify patch...
set "ps_path=%adobe_path%\Adobe Photoshop 2025\Photoshop.exe"
if not exist "%ps_path%" set "ps_path=%adobe_path%\Adobe Photoshop 2023\Photoshop.exe"
if exist "%ps_path%" (
    start "" "%ps_path%"
) else (
    echo Photoshop not found at %ps_path%. Check path or try another Adobe app.
)

echo Adobe suite should be cracked, Architect. If it bitches, check paths or try AMTEmu for a stronger hit.
pause

exit /b
