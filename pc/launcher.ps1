# 위젯 실행기 - 최신 버전을 받아온 뒤 위젯을 띄운다.
# 웹의 [PC 위젯 열기] 버튼(bossclock:// 링크)이 이 파일을 실행한다.
$dir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ps  = Join-Path $dir 'boss-clock.ps1'
$url = 'https://raw.githubusercontent.com/dorazi95/zeus-boss-clock/main/pc/boss-clock.ps1'

try {
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  $tmp = $ps + '.new'
  Invoke-WebRequest -Uri $url -OutFile $tmp -UseBasicParsing -TimeoutSec 15
  if ((Get-Item $tmp).Length -gt 4000) { Move-Item $tmp $ps -Force }
  else { Remove-Item $tmp -Force -ErrorAction SilentlyContinue }
} catch {
  # 인터넷이 안 되면 갖고 있는 버전으로 실행한다
}

if (Test-Path $ps) {
  Start-Process powershell.exe -ArgumentList '-NoProfile', '-ExecutionPolicy', 'Bypass', '-STA', '-WindowStyle', 'Hidden', '-File', $ps
}
