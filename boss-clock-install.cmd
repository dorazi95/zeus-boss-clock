@echo off
chcp 65001 > nul
title 제우스 보스 시계 설치
echo.
echo   제우스 보스 시계 - PC 위젯 설치
echo   --------------------------------
echo.

set "DIR=%LOCALAPPDATA%\ZeusBossClock"
set "BASE=https://raw.githubusercontent.com/dorazi95/zeus-boss-clock/main/pc"

if not exist "%DIR%" mkdir "%DIR%"

echo   파일을 받는 중...
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Invoke-WebRequest '%BASE%/boss-clock.ps1' -OutFile '%DIR%\boss-clock.ps1' -UseBasicParsing; Invoke-WebRequest '%BASE%/launcher.ps1' -OutFile '%DIR%\launcher.ps1' -UseBasicParsing"

if not exist "%DIR%\boss-clock.ps1" goto fail
if not exist "%DIR%\launcher.ps1" goto fail

echo   웹 버튼과 연결하는 중...
reg add "HKCU\Software\Classes\bossclock" /ve /t REG_SZ /d "URL:Zeus Boss Clock" /f > nul
reg add "HKCU\Software\Classes\bossclock" /v "URL Protocol" /t REG_SZ /d "" /f > nul
reg add "HKCU\Software\Classes\bossclock\shell\open\command" /ve /t REG_SZ /d "\"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe\" -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File \"%DIR%\launcher.ps1\"" /f > nul
if errorlevel 1 goto fail

echo   위젯을 실행합니다.
start "" powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%DIR%\launcher.ps1"

echo.
echo   설치 완료.
echo.
echo   앞으로는 웹 페이지의 [PC 위젯 열기] 버튼만 누르면 켜집니다.
echo   버튼을 처음 누를 때 브라우저가 물어보면 [열기]를 눌러 주세요.
echo   위젯은 켤 때마다 최신 버전으로 자동 갱신됩니다.
echo.
timeout /t 8 > nul
exit /b 0

:fail
echo.
echo   설치에 실패했습니다. 인터넷 연결을 확인하고 다시 실행해 주세요.
echo.
pause
exit /b 1
