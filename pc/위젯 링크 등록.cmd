@echo off
chcp 65001 > nul
setlocal
set "TARGET=%~dp0boss-clock.ps1"

if not exist "%TARGET%" (
  echo boss-clock.ps1 을 찾을 수 없습니다.
  echo 이 파일은 boss-clock.ps1 과 같은 폴더에 있어야 합니다.
  pause
  exit /b 1
)

reg add "HKCU\Software\Classes\bossclock" /ve /t REG_SZ /d "URL:Zeus Boss Clock" /f > nul
reg add "HKCU\Software\Classes\bossclock" /v "URL Protocol" /t REG_SZ /d "" /f > nul
reg add "HKCU\Software\Classes\bossclock\shell\open\command" /ve /t REG_SZ /d "\"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe\" -NoProfile -ExecutionPolicy Bypass -STA -WindowStyle Hidden -File \"%TARGET%\"" /f > nul

if errorlevel 1 (
  echo 등록에 실패했습니다.
) else (
  echo 등록 완료.
  echo.
  echo 이제 웹에서 [PC 위젯 열기] 버튼을 누르면 이 위젯이 실행됩니다.
  echo 처음 누를 때 브라우저가 "이 사이트에서 열려고 합니다" 라고 물어보면 허용해 주세요.
  echo.
  echo 위젯 파일을 다른 폴더로 옮기면 이 파일을 다시 실행해야 합니다.
)
echo.
pause
