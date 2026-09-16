# 제우스 보스 시계 - 좌측 상단 상주 위젯
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$Root    = Split-Path -Parent $MyInvocation.MyCommand.Definition
$CfgPath = Join-Path $Root 'bosses.json'

$C_BG    = [System.Drawing.Color]::FromArgb(0x14,0x16,0x1C)
$C_LINE  = [System.Drawing.Color]::FromArgb(0x3D,0x45,0x5E)
$C_DIM   = [System.Drawing.Color]::FromArgb(0x93,0x9C,0xB4)
$C_NAME  = [System.Drawing.Color]::FromArgb(0xB4,0xBD,0xD2)
$C_TIME  = [System.Drawing.Color]::FromArgb(0xF4,0xF7,0xFC)
$C_LIT   = [System.Drawing.Color]::FromArgb(0xEF,0x9F,0x27)
$C_LITTX = [System.Drawing.Color]::FromArgb(0x41,0x24,0x02)
$C_SOON  = [System.Drawing.Color]::FromArgb(0xFA,0xC7,0x75)
$C_WBG   = [System.Drawing.Color]::FromArgb(0xA8,0x18,0x22)
$C_WTX   = [System.Drawing.Color]::FromArgb(0xFF,0xFF,0xFF)
$C_WSUB  = [System.Drawing.Color]::FromArgb(0xFF,0xCF,0xD2)
$C_WLINE = [System.Drawing.Color]::FromArgb(0xE8,0x8A,0x90)
$C_ONBG  = [System.Drawing.Color]::FromArgb(0x1B,0x5E,0x3A)
$C_ONTX  = [System.Drawing.Color]::FromArgb(0x8C,0xE8,0xB4)

$script:Warn      = $false
$script:BorderCol = $C_LINE

$DefaultCfg = @'
{
    "Pos":  {
                "X":  null,
                "Y":  null
            },
    "Online":  true,
    "Bosses":  [
                   {
                       "Name":  "아르고스",
                       "Lv":  65,
                       "Loc":  "자하브",
                       "Watch":  true,
                       "Type":  "weekly",
                       "Weekday":  "월",
                       "Hour":  21,
                       "AvailHours":  0,
                       "WindowHours":  0,
                       "KillMinutes":  0
                   },
                   {
                       "Name":  "메데이아",
                       "Lv":  45,
                       "Loc":  "타르타로스 2계",
                       "Watch":  true,
                       "Type":  "weekly",
                       "Weekday":  "화",
                       "Hour":  21,
                       "AvailHours":  0,
                       "WindowHours":  0,
                       "KillMinutes":  0
                   },
                   {
                       "Name":  "아라크네",
                       "Lv":  50,
                       "Loc":  "테살리아",
                       "Watch":  true,
                       "Type":  "weekly",
                       "Weekday":  "수",
                       "Hour":  21,
                       "AvailHours":  0,
                       "WindowHours":  0,
                       "KillMinutes":  0
                   },
                   {
                       "Name":  "케르베로스",
                       "Lv":  75,
                       "Loc":  "타르타로스 5계",
                       "Watch":  true,
                       "Type":  "weekly",
                       "Weekday":  "금",
                       "Hour":  21,
                       "AvailHours":  0,
                       "WindowHours":  0,
                       "KillMinutes":  0
                   },
                   {
                       "Name":  "키메라",
                       "Lv":  60,
                       "Loc":  "타르타로스 4계",
                       "Watch":  true,
                       "Type":  "weekly",
                       "Weekday":  "토",
                       "Hour":  21,
                       "AvailHours":  0,
                       "WindowHours":  0,
                       "KillMinutes":  0
                   },
                   {
                       "Name":  "크리소파고스",
                       "Lv":  35,
                       "Loc":  "테살리아 평원",
                       "Watch":  true,
                       "Type":  "cycle",
                       "CycleHours":  8,
                       "NextSpawn":  "2026-09-16T19:43:40",
                       "KillMinutes":  1,
                       "AvailHours":  0,
                       "WindowHours":  0
                   },
                   {
                       "Name":  "아모르포스",
                       "Lv":  35,
                       "Loc":  "침식된 경작지",
                       "Watch":  true,
                       "Type":  "cycle",
                       "CycleHours":  8,
                       "NextSpawn":  "2026-09-16T19:45:40",
                       "KillMinutes":  1,
                       "AvailHours":  0,
                       "WindowHours":  0
                   },
                   {
                       "Name":  "트라손",
                       "Lv":  40,
                       "Loc":  "고대 신전 유적지",
                       "Watch":  true,
                       "Type":  "cycle",
                       "CycleHours":  8,
                       "NextSpawn":  "2026-09-16T19:47:40",
                       "KillMinutes":  1,
                       "AvailHours":  0,
                       "WindowHours":  0
                   },
                   {
                       "Name":  "이오칸토스",
                       "Lv":  45,
                       "Loc":  "아르보리아스 폐허",
                       "Watch":  true,
                       "Type":  "cycle",
                       "CycleHours":  12,
                       "NextSpawn":  "2026-09-17T01:53:40",
                       "KillMinutes":  1,
                       "AvailHours":  0,
                       "WindowHours":  0
                   },
                   {
                       "Name":  "키니 러우리",
                       "Lv":  45,
                       "Loc":  "금지된 숲",
                       "Watch":  true,
                       "Type":  "cycle",
                       "CycleHours":  12,
                       "NextSpawn":  "2026-09-17T01:52:50",
                       "KillMinutes":  1,
                       "AvailHours":  0,
                       "WindowHours":  0
                   },
                   {
                       "Name":  "알라스토르",
                       "Lv":  55,
                       "Loc":  "무법자의 길목",
                       "Watch":  true,
                       "Type":  "cycle",
                       "CycleHours":  8,
                       "NextSpawn":  "2026-09-16T19:06:56",
                       "KillMinutes":  5,
                       "AvailHours":  0,
                       "WindowHours":  0
                   },
                   {
                       "Name":  "베딕스",
                       "Lv":  60,
                       "Loc":  "공헌의 제단",
                       "Watch":  true,
                       "Type":  "cycle",
                       "CycleHours":  8,
                       "NextSpawn":  "2026-09-16T19:03:41",
                       "KillMinutes":  6,
                       "AvailHours":  0,
                       "WindowHours":  0
                   },
                   {
                       "Name":  "고트시스",
                       "Lv":  60,
                       "Loc":  "황금리라 부락",
                       "Watch":  true,
                       "Type":  "cycle",
                       "CycleHours":  8,
                       "NextSpawn":  "2026-09-16T18:57:20",
                       "KillMinutes":  6,
                       "AvailHours":  0,
                       "WindowHours":  0
                   },
                   {
                       "Name":  "트리포크",
                       "Lv":  65,
                       "Loc":  "가시 덤불 지대",
                       "Watch":  true,
                       "Type":  "cycle",
                       "CycleHours":  12,
                       "NextSpawn":  "2026-09-17T04:17:50",
                       "KillMinutes":  15,
                       "AvailHours":  0,
                       "WindowHours":  0
                   },
                   {
                       "Name":  "거인의 세번째 손",
                       "Lv":  70,
                       "Loc":  "유적지 폐허",
                       "Watch":  false,
                       "Type":  "cycle",
                       "CycleHours":  12,
                       "NextSpawn":  "2026-09-16T18:13:50",
                       "KillMinutes":  20,
                       "AvailHours":  0,
                       "WindowHours":  0
                   },
                   {
                       "Name":  "봉인된 아모르포스",
                       "Lv":  40,
                       "Loc":  "유폐의 둥지",
                       "Watch":  true,
                       "Type":  "cycle",
                       "CycleHours":  8,
                       "NextSpawn":  "2026-09-17T00:07:50",
                       "KillMinutes":  1,
                       "AvailHours":  0,
                       "WindowHours":  0
                   },
                   {
                       "Name":  "봉인된 브델레스",
                       "Lv":  45,
                       "Loc":  "배신의 심연굴",
                       "Watch":  true,
                       "Type":  "cycle",
                       "CycleHours":  24,
                       "NextSpawn":  "2026-09-17T11:49:50",
                       "KillMinutes":  1,
                       "AvailHours":  0,
                       "WindowHours":  0
                   }
               ],
    "UpMinutes":  20
}
'@

function Load-Cfg {
  if (-not (Test-Path $CfgPath)) {
    [System.IO.File]::WriteAllText($CfgPath, $DefaultCfg, (New-Object System.Text.UTF8Encoding($true)))
  }
  $cfg = $null
  try {
    $raw = Get-Content $CfgPath -Raw -Encoding UTF8 -ErrorAction Stop
    if (-not [string]::IsNullOrWhiteSpace($raw)) { $cfg = ($raw | ConvertFrom-Json) }
  } catch { $cfg = $null }
  if ((-not $cfg) -or (-not $cfg.Bosses) -or (@($cfg.Bosses).Count -eq 0)) {
    $cfg = ($DefaultCfg | ConvertFrom-Json)
    [System.IO.File]::WriteAllText($CfgPath, $DefaultCfg, (New-Object System.Text.UTF8Encoding($true)))
  }
  $def = ($DefaultCfg | ConvertFrom-Json)
  if ($null -eq $cfg.PSObject.Properties['UpMinutes']) { $cfg | Add-Member -NotePropertyName UpMinutes -NotePropertyValue 20 }
  if ($null -eq $cfg.PSObject.Properties['Online'])    { $cfg | Add-Member -NotePropertyName Online    -NotePropertyValue $false }

  # 게임 업데이트 반영 (구버전 bosses.json 자동 정리)
  $Removed = @('봉인된 스코톨라스마')
  $keep = @($cfg.Bosses | Where-Object { $Removed -notcontains [string]$_.Name })
  foreach ($nd in $def.Bosses) {
    if (-not ($keep | Where-Object { $_.Name -eq $nd.Name })) { $keep += $nd }
  }
  foreach ($b in $keep) {
    $dd = $def.Bosses | Where-Object { $_.Name -eq $b.Name } | Select-Object -First 1
    if (-not $dd) { continue }
    if ($dd.Type -eq 'weekly') {
      # 주간 보스 요일/시간은 게임 고정값이라 항상 최신 기본값을 따른다
      $b.Type = 'weekly'
      if ($null -eq $b.PSObject.Properties['Weekday']) { $b | Add-Member -NotePropertyName Weekday -NotePropertyValue $dd.Weekday } else { $b.Weekday = $dd.Weekday }
      if ($null -eq $b.PSObject.Properties['Hour'])    { $b | Add-Member -NotePropertyName Hour    -NotePropertyValue $dd.Hour }    else { $b.Hour    = $dd.Hour }
    }
    # 봉인 보스(컷 후 출현가능 + 지속창) 방식이 일반 주기로 바뀐 경우
    if (([double]$b.AvailHours -gt 0) -or ([double]$b.WindowHours -gt 0)) {
      $b.AvailHours  = 0.0
      $b.WindowHours = 0.0
      $b.CycleHours  = [double]$dd.CycleHours
      if ($null -eq $b.PSObject.Properties['KillMinutes']) { $b | Add-Member -NotePropertyName KillMinutes -NotePropertyValue ([double]$dd.KillMinutes) }
      else { $b.KillMinutes = [double]$dd.KillMinutes }
    }
    # 주기보다 멀리 잡힌 다음 출현 시각은 잘못된 값이므로 기본 시간표로 되돌린다
    if ($b.Type -ne 'weekly' -and [double]$b.CycleHours -gt 0 -and $b.NextSpawn) {
      $bad = $false
      try { $bad = ([datetime]::Parse([string]$b.NextSpawn) - (Get-Date)).TotalHours -gt ([double]$b.CycleHours + 1) } catch { $bad = $true }
      if ($bad) { $b.NextSpawn = $dd.NextSpawn }
    }
  }
  $cfg.Bosses = $keep

  foreach ($b in $cfg.Bosses) {
    $d = $def.Bosses | Where-Object { $_.Name -eq $b.Name } | Select-Object -First 1
    if ($null -eq $b.PSObject.Properties['Watch']) {
      $w = $true; if ($d) { $w = [bool]$d.Watch }
      $b | Add-Member -NotePropertyName Watch -NotePropertyValue $w
    }
    foreach ($k in @('AvailHours', 'WindowHours', 'KillMinutes')) {
      if ($null -eq $b.PSObject.Properties[$k]) {
        $v = 0.0
        if ($d -and $d.PSObject.Properties[$k]) { $v = [double]$d.$k }
        $b | Add-Member -NotePropertyName $k -NotePropertyValue $v
      }
    }
    if ($d -and [double]$b.CycleHours -le 0 -and [double]$d.CycleHours -gt 0) {
      $b.CycleHours = [double]$d.CycleHours
    }
  }
  return $cfg
}
function Save-Cfg($cfg) {
  if ((-not $cfg) -or (-not $cfg.Bosses) -or (@($cfg.Bosses).Count -eq 0)) { return }
  $json = $cfg | ConvertTo-Json -Depth 6
  if ([string]::IsNullOrWhiteSpace($json)) { return }
  $tmp = $CfgPath + '.tmp'
  [System.IO.File]::WriteAllText($tmp, $json, (New-Object System.Text.UTF8Encoding($true)))
  Move-Item -LiteralPath $tmp -Destination $CfgPath -Force
}

$script:Cfg = Load-Cfg
$script:Dirty = $false

$WeekMap = @{ '일'=0; '월'=1; '화'=2; '수'=3; '목'=4; '금'=5; '토'=6 }

function Parse-Remain([string]$s) {
  if ([string]::IsNullOrWhiteSpace($s)) { return $null }
  $s = $s.Trim(); $h = 0; $m = 0; $sec = 0
  if ($s -match '^(\d+)\s*:\s*(\d+)\s*(?::\s*(\d+))?$') {
    $h = [int]$Matches[1]; $m = [int]$Matches[2]
    if ($Matches[3]) { $sec = [int]$Matches[3] }
  } else {
    if ($s -match '(\d+)\s*시간') { $h   = [int]$Matches[1] }
    if ($s -match '(\d+)\s*분')   { $m   = [int]$Matches[1] }
    if ($s -match '(\d+)\s*초')   { $sec = [int]$Matches[1] }
    if ($h -eq 0 -and $m -eq 0 -and $sec -eq 0) {
      if ($s -match '^\d+$') { $m = [int]$s } else { return $null }
    }
  }
  return (New-TimeSpan -Hours $h -Minutes $m -Seconds $sec)
}

function Get-Spawn($b) {
  $now = Get-Date
  if ($b.Type -eq 'weekly') {
    $target = $WeekMap[[string]$b.Weekday]
    if ($null -eq $target) { return $null }
    $d = $now.Date.AddHours([int]$b.Hour)
    $d = $d.AddDays((($target - [int]$now.DayOfWeek) + 7) % 7)
    if ($d -le $now) { $d = $d.AddDays(7) }
    return $d
  }
  if (-not $b.NextSpawn) { return $null }
  try { $t = [datetime]::Parse([string]$b.NextSpawn) } catch { return $null }
  $cyc = [double]$b.CycleHours
  $win = 0.0
  if ($b.PSObject.Properties['WindowHours']) { $win = [double]$b.WindowHours }
  # 온라인 모드: 컷을 누르기 전까지 출현 중 상태로 계속 대기시킨다
  if ([bool]$script:Cfg.Online) { return $t }
  if ($cyc -gt 0) {
    $rolled = $false
    if ($win -gt 0) {
      while ($t.AddHours($win) -le $now) { $t = $t.AddHours($cyc); $rolled = $true }
    } else {
      $kill = 5.0
      if ($b.PSObject.Properties['KillMinutes']) { $kill = [double]$b.KillMinutes }
      if ($kill -le 0) { $kill = 5.0 }
      while ($t.AddMinutes($kill) -le $now) { $t = $t.AddMinutes($kill).AddHours($cyc); $rolled = $true }
    }
    if ($rolled) { $b.NextSpawn = $t.ToString('s'); $script:Dirty = $true }
  }
  return $t
}

function Fmt-Span([timespan]$ts) {
  if ($ts.TotalSeconds -lt 0) { return '00:00' }
  if ($ts.TotalDays -ge 1)  { return ('{0}일 {1}:{2:00}' -f [int][Math]::Floor($ts.TotalDays), $ts.Hours, $ts.Minutes) }
  if ($ts.TotalHours -ge 1) { return ('{0}:{1:00}:{2:00}' -f [int][Math]::Floor($ts.TotalHours), $ts.Minutes, $ts.Seconds) }
  return ('{0}:{1:00}' -f $ts.Minutes, $ts.Seconds)
}

function Fmt-Input([timespan]$ts) {
  if ($ts.TotalSeconds -lt 0) { return '0:00:00' }
  return ('{0}:{1:00}:{2:00}' -f [int][Math]::Floor($ts.TotalHours), $ts.Minutes, $ts.Seconds)
}

function Fmt-Short([timespan]$ts) {
  if ($ts.TotalSeconds -lt 0) { return '0분' }
  if ($ts.TotalDays -ge 1)  { return ('{0}일 {1}시간' -f [int][Math]::Floor($ts.TotalDays), $ts.Hours) }
  if ($ts.TotalHours -ge 1) { return ('{0}:{1:00}' -f [int][Math]::Floor($ts.TotalHours), $ts.Minutes) }
  return ('{0}분' -f $ts.Minutes)
}

# ---------- 위젯 본체 ----------
$W = 290; $H = 112

function Clamp-Loc([int]$x, [int]$y) {
  $vs = [System.Windows.Forms.SystemInformation]::VirtualScreen
  $maxX = $vs.Right - $W
  $maxY = $vs.Bottom - $H
  if ($x -lt $vs.Left) { $x = $vs.Left }
  if ($y -lt $vs.Top)  { $y = $vs.Top }
  if ($x -gt $maxX) { $x = $maxX }
  if ($y -gt $maxY) { $y = $maxY }
  return (New-Object System.Drawing.Point($x, $y))
}
$f = New-Object System.Windows.Forms.Form
$f.FormBorderStyle = 'None'
$f.ShowInTaskbar   = $false
$f.TopMost         = $true
$f.BackColor       = $C_BG
$f.Size            = New-Object System.Drawing.Size($W, $H)
$f.StartPosition   = 'Manual'
$f.Text            = '보스 시계'

$wa = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
$loc = New-Object System.Drawing.Point(($wa.Left + 12), ($wa.Top + 12))
if ($null -ne $script:Cfg.Pos.X -and $null -ne $script:Cfg.Pos.Y) {
  $saved = New-Object System.Drawing.Rectangle([int]$script:Cfg.Pos.X, [int]$script:Cfg.Pos.Y, $W, $H)
  $visible = $false
  foreach ($sc in [System.Windows.Forms.Screen]::AllScreens) {
    $ov = [System.Drawing.Rectangle]::Intersect($sc.WorkingArea, $saved)
    if ($ov.Width -ge 60 -and $ov.Height -ge 30) { $visible = $true }
  }
  if ($visible) { $loc = Clamp-Loc $saved.X $saved.Y }
}
$f.Location = $loc

$fontSlot = New-Object System.Drawing.Font('맑은 고딕', 9.0, [System.Drawing.FontStyle]::Bold)
$fontSlotSm = New-Object System.Drawing.Font('맑은 고딕', 8.0)
$fontName = New-Object System.Drawing.Font('맑은 고딕', 9.5)
$fontTime = New-Object System.Drawing.Font('Consolas', 26.0, [System.Drawing.FontStyle]::Bold)

function New-Slot($x, $y, $h, $font, $color) {
  $l = New-Object System.Windows.Forms.Label
  $l.Size      = New-Object System.Drawing.Size(142, $h)
  $l.Location  = New-Object System.Drawing.Point($x, $y)
  $l.TextAlign = 'MiddleCenter'
  $l.Font      = $font
  $l.ForeColor = $color
  $l.BackColor = $C_BG
  return $l
}
$slotL  = New-Slot 1   3  17 $fontSlot   $C_DIM
$slotLT = New-Slot 1   19 14 $fontSlotSm $C_DIM
$slotR  = New-Slot 147 3  17 $fontSlot   $C_DIM
$slotRT = New-Slot 147 19 14 $fontSlotSm $C_DIM

$vline = New-Object System.Windows.Forms.Panel
$vline.Size = New-Object System.Drawing.Size(1, 27)
$vline.Location = New-Object System.Drawing.Point(145, 4)
$vline.BackColor = $C_LINE

$hline = New-Object System.Windows.Forms.Panel
$hline.Size = New-Object System.Drawing.Size(($W - 2), 1)
$hline.Location = New-Object System.Drawing.Point(1, 37)
$hline.BackColor = $C_LINE

$lblName = New-Object System.Windows.Forms.Label
$lblName.Size = New-Object System.Drawing.Size(($W - 20), 18)
$lblName.Location = New-Object System.Drawing.Point(12, 41)
$lblName.Font = $fontName; $lblName.ForeColor = $C_NAME; $lblName.BackColor = $C_BG

$lblTime = New-Object System.Windows.Forms.Label
$lblTime.Size = New-Object System.Drawing.Size(($W - 20), 42)
$lblTime.Location = New-Object System.Drawing.Point(10, 62)
$lblTime.Font = $fontTime; $lblTime.ForeColor = $C_TIME; $lblTime.BackColor = $C_BG

$btnCfg = New-Object System.Windows.Forms.Button
$btnCfg.Text = [string][char]0x2699
$btnCfg.Font = New-Object System.Drawing.Font('Segoe UI Symbol', 12.0)
$btnCfg.Size = New-Object System.Drawing.Size(24, 24)
$btnCfg.Location = New-Object System.Drawing.Point(258, 80)
$btnCfg.TextAlign = 'MiddleCenter'
$btnCfg.ForeColor = $C_DIM
$btnCfg.BackColor = $C_BG
$btnCfg.FlatStyle = 'Flat'
$btnCfg.FlatAppearance.BorderSize = 0
$btnCfg.FlatAppearance.MouseOverBackColor = $C_LINE
$btnCfg.TabStop = $false
$btnCfg.Cursor = [System.Windows.Forms.Cursors]::Hand

$btnOn = New-Object System.Windows.Forms.Button
$btnOn.Font = New-Object System.Drawing.Font('맑은 고딕', 7.5, [System.Drawing.FontStyle]::Bold)
$btnOn.Size = New-Object System.Drawing.Size(40, 18)
$btnOn.Location = New-Object System.Drawing.Point(246, 41)
$btnOn.TextAlign = 'MiddleCenter'
$btnOn.FlatStyle = 'Flat'
$btnOn.FlatAppearance.BorderSize = 0
$btnOn.TabStop = $false
$btnOn.Cursor = [System.Windows.Forms.Cursors]::Hand

function Update-OnlineBtn {
  if ([bool]$script:Cfg.Online) {
    $btnOn.Text = 'ON'
    $btnOn.BackColor = $C_ONBG
    $btnOn.ForeColor = $C_ONTX
    $btnOn.FlatAppearance.MouseOverBackColor = $C_ONTX
  } else {
    $btnOn.Text = 'OFF'
    if ($script:Warn) { $btnOn.BackColor = $C_WBG; $btnOn.ForeColor = $C_WSUB; $btnOn.FlatAppearance.MouseOverBackColor = $C_WLINE }
    else { $btnOn.BackColor = $C_BG; $btnOn.ForeColor = $C_LINE; $btnOn.FlatAppearance.MouseOverBackColor = $C_LINE }
  }
  if ($null -ne $script:MiOnline) { $script:MiOnline.Checked = [bool]$script:Cfg.Online }
}

function Toggle-Online {
  $script:Cfg.Online = -not [bool]$script:Cfg.Online
  Update-OnlineBtn
  Save-Cfg $script:Cfg
}
$btnOn.Add_Click({ Toggle-Online })
$script:MiOnline = $null

function New-CutBtn($x, $y, $w, $h, $size) {
  $b = New-Object System.Windows.Forms.Button
  $b.Text = '컷'
  $b.Font = New-Object System.Drawing.Font('맑은 고딕', $size, [System.Drawing.FontStyle]::Bold)
  $b.Size = New-Object System.Drawing.Size($w, $h)
  $b.Location = New-Object System.Drawing.Point($x, $y)
  $b.BackColor = $C_LITTX
  $b.ForeColor = $C_LIT
  $b.FlatStyle = 'Flat'
  $b.FlatAppearance.BorderSize = 0
  $b.TabStop = $false
  $b.Cursor = [System.Windows.Forms.Cursors]::Hand
  $b.Visible = $false
  return $b
}
$btnCut  = New-CutBtn 196 76 56 24 9.0

$cutClick = {
  param($s, $e)
  if ($s.Tag) { Do-Cut ([string]$s.Tag) }
}
$btnCut.Add_Click($cutClick)

$f.Controls.AddRange(@($slotL, $slotLT, $slotR, $slotRT, $vline, $hline, $lblName, $lblTime, $btnCfg, $btnOn, $btnCut))
$btnCut.BringToFront()
$btnOn.BringToFront()
Update-OnlineBtn
$btnCfg.BringToFront()
$tip = New-Object System.Windows.Forms.ToolTip
$tip.SetToolTip($btnCfg, '설정 (보스 선택 / 시간 입력)')
$tip.SetToolTip($btnOn, "온라인 모드`r`nON: 컷을 눌러야 다음 젠으로 넘어감`r`nOFF: 시간이 지나면 자동으로 다음 젠")
$btnCfg.Add_MouseEnter({ param($s, $e) $s.ForeColor = $C_TIME })
$btnCfg.Add_MouseLeave({ param($s, $e) if ($script:Warn) { $s.ForeColor = $C_WSUB } else { $s.ForeColor = $C_DIM } })
$btnCfg.Add_Click({
  param($s, $e)
  try {
    Show-Settings
  } catch {
    [System.IO.File]::AppendAllText((Join-Path $Root 'error.log'), ((Get-Date).ToString('s') + ' ' + $_.Exception.ToString() + "`r`n"))
  }
})
$f.Add_Paint({
  param($s, $e)
  $p = New-Object System.Drawing.Pen($script:BorderCol, 1)
  $e.Graphics.DrawRectangle($p, 0, 0, $s.Width - 1, $s.Height - 1)
  $p.Dispose()
})

# ---------- 드래그 이동 ----------
$script:Drag = $false
$script:Moved = $false
$script:DragStart = New-Object System.Drawing.Point(0, 0)
$script:DragOrigin = New-Object System.Drawing.Point(0, 0)

$onDown = {
  param($s, $e)
  if ($e.Button -ne [System.Windows.Forms.MouseButtons]::Left) { return }
  $script:Drag = $true
  $script:Moved = $false
  $script:DragStart = [System.Windows.Forms.Cursor]::Position
  $script:DragOrigin = $f.Location
}
$onMove = {
  param($s, $e)
  if (-not $script:Drag) { return }
  $c = [System.Windows.Forms.Cursor]::Position
  $dx = $c.X - $script:DragStart.X
  $dy = $c.Y - $script:DragStart.Y
  if ([Math]::Abs($dx) -gt 3 -or [Math]::Abs($dy) -gt 3) { $script:Moved = $true }
  if ($script:Moved) {
    $f.Location = Clamp-Loc ($script:DragOrigin.X + $dx) ($script:DragOrigin.Y + $dy)
  }
}
$onUp = {
  param($s, $e)
  if (-not $script:Drag) { return }
  $script:Drag = $false
  if ($script:Moved) {
    $script:Cfg.Pos.X = $f.Location.X
    $script:Cfg.Pos.Y = $f.Location.Y
    Save-Cfg $script:Cfg
  }
}
foreach ($c in @($f, $slotL, $slotLT, $slotR, $slotRT, $lblName, $lblTime)) {
  $c.Add_MouseDown($onDown); $c.Add_MouseMove($onMove); $c.Add_MouseUp($onUp)
}

# ---------- 컷 (처치) 기록 ----------
function Do-Cut($name) {
  $b = $script:Cfg.Bosses | Where-Object { $_.Name -eq $name } | Select-Object -First 1
  if (-not $b) { return }
  $h = [double]$b.CycleHours
  if ($b.PSObject.Properties['AvailHours'] -and [double]$b.AvailHours -gt 0) { $h = [double]$b.AvailHours }
  if ($h -le 0) {
    [System.Windows.Forms.MessageBox]::Show("$name 의 주기(시간)가 비어 있습니다.`r`n우클릭 > 시간 설정에서 입력해 주세요.", '보스 시계') | Out-Null
    return
  }
  $b.NextSpawn = (Get-Date).AddHours($h).ToString('s')
  Save-Cfg $script:Cfg
}
# ---------- 설정 창 ----------
function Show-Settings {
  $d = New-Object System.Windows.Forms.Form
  $d.Text = '보스 시간 설정'
  $d.Size = New-Object System.Drawing.Size(560, 620)
  $d.StartPosition = 'CenterScreen'
  $d.TopMost = $true

  $pan = New-Object System.Windows.Forms.Panel
  $pan.Dock = 'Fill'; $pan.AutoScroll = $true
  $d.Controls.Add($pan)

  $y = 10
  $hdr = New-Object System.Windows.Forms.Label
  $hdr.Text = "체크한 보스만 아래 카운트다운 대상이 됩니다." + "`r`n" + "남은: 시:분:초 (예: 0:48:00 = 48분) / 현황판 표기도 인식 (예: 6시간 51분, 29분 44초)" + "`r`n" + "주기h: 컷 이후 리젠까지 걸리는 시간   /   컷분: 출현 후 잡는 데 걸리는 시간"
  $hdr.Location = New-Object System.Drawing.Point(12, $y)
  $hdr.Size = New-Object System.Drawing.Size(510, 54)
  $pan.Controls.Add($hdr)
  $y += 58

  $rows = New-Object System.Collections.ArrayList

  $btnAll = New-Object System.Windows.Forms.Button
  $btnAll.Text = '모두 선택'
  $btnAll.Location = New-Object System.Drawing.Point(12, $y)
  $btnAll.Size = New-Object System.Drawing.Size(90, 24)
  $btnAll.Add_Click({ foreach ($r in $rows) { $r.Check.Checked = $true } }.GetNewClosure())

  $btnNone = New-Object System.Windows.Forms.Button
  $btnNone.Text = '모두 해제'
  $btnNone.Location = New-Object System.Drawing.Point(108, $y)
  $btnNone.Size = New-Object System.Drawing.Size(90, 24)
  $btnNone.Add_Click({ foreach ($r in $rows) { $r.Check.Checked = $false } }.GetNewClosure())

  $pan.Controls.AddRange(@($btnAll, $btnNone))
  $y += 32

  foreach ($b in $script:Cfg.Bosses) {
    $cb = New-Object System.Windows.Forms.CheckBox
    $cb.Text = ('[{0}] {1}' -f $b.Lv, $b.Name)
    $cb.Location = New-Object System.Drawing.Point(12, ($y + 2))
    $cb.Size = New-Object System.Drawing.Size(190, 22)
    $cb.Checked = [bool]$b.Watch
    $pan.Controls.Add($cb)

    $tb1 = $null
    $tb2 = $null
    $tb3 = $null
    if ($b.Type -eq 'weekly') {
      $info = New-Object System.Windows.Forms.Label
      $info.Text = ('{0}요일 {1}시 고정 - 자동 계산' -f $b.Weekday, $b.Hour)
      $info.Location = New-Object System.Drawing.Point(210, ($y + 4))
      $info.Size = New-Object System.Drawing.Size(300, 20)
      $info.ForeColor = [System.Drawing.Color]::Gray
      $pan.Controls.Add($info)
    } else {
      $tb1 = New-Object System.Windows.Forms.TextBox
      $tb1.Location = New-Object System.Drawing.Point(206, $y)
      $tb1.Size = New-Object System.Drawing.Size(90, 22)
      $sp = Get-Spawn $b
      if ($sp) { $tb1.Text = (Fmt-Input ($sp - (Get-Date))) }

      $l1 = New-Object System.Windows.Forms.Label
      $l1.Text = '남은'
      $l1.Location = New-Object System.Drawing.Point(300, ($y + 4))
      $l1.Size = New-Object System.Drawing.Size(32, 20)

      $tb2 = New-Object System.Windows.Forms.TextBox
      $tb2.Location = New-Object System.Drawing.Point(334, $y)
      $tb2.Size = New-Object System.Drawing.Size(44, 22)
      if ([double]$b.CycleHours -gt 0) { $tb2.Text = [string]$b.CycleHours }

      $l2 = New-Object System.Windows.Forms.Label
      $l2.Text = '주기h'
      $l2.Location = New-Object System.Drawing.Point(382, ($y + 4))
      $l2.Size = New-Object System.Drawing.Size(36, 20)

      $tb3 = New-Object System.Windows.Forms.TextBox
      $tb3.Location = New-Object System.Drawing.Point(420, $y)
      $tb3.Size = New-Object System.Drawing.Size(40, 22)
      if ($b.PSObject.Properties['KillMinutes']) { $tb3.Text = [string]$b.KillMinutes }

      $l3 = New-Object System.Windows.Forms.Label
      $l3.Text = '컷분'
      $l3.Location = New-Object System.Drawing.Point(464, ($y + 4))
      $l3.Size = New-Object System.Drawing.Size(34, 20)

      $pan.Controls.AddRange(@($tb1, $l1, $tb2, $l2, $tb3, $l3))
    }
    [void]$rows.Add([pscustomobject]@{ Boss = $b; Check = $cb; Remain = $tb1; Cycle = $tb2; Kill = $tb3 })
    $y += 28
  }

  $cfgRef = $script:Cfg
  $ok = New-Object System.Windows.Forms.Button
  $ok.Text = '저장'
  $ok.Location = New-Object System.Drawing.Point(374, ($y + 12))
  $ok.Size = New-Object System.Drawing.Size(126, 30)
  $ok.Add_Click({
    $pendingBoss = New-Object System.Collections.ArrayList
    $pendingSpan = New-Object System.Collections.ArrayList
    $odd = New-Object System.Collections.ArrayList
    foreach ($r in $rows) {
      $r.Boss.Watch = [bool]$r.Check.Checked
      if ($null -eq $r.Remain) { continue }
      $cy = 0.0
      if (-not [string]::IsNullOrWhiteSpace($r.Cycle.Text)) {
        [void][double]::TryParse($r.Cycle.Text.Trim(), [ref]$cy)
      }
      $r.Boss.CycleHours = $cy
      if ($r.Kill) {
        $km = 0.0
        if (-not [string]::IsNullOrWhiteSpace($r.Kill.Text)) { [void][double]::TryParse($r.Kill.Text.Trim(), [ref]$km) }
        if ($null -eq $r.Boss.PSObject.Properties['KillMinutes']) { $r.Boss | Add-Member -NotePropertyName KillMinutes -NotePropertyValue $km }
        else { $r.Boss.KillMinutes = $km }
      }
      $ts = Parse-Remain $r.Remain.Text
      if ($null -ne $ts) {
        [void]$pendingBoss.Add($r.Boss)
        [void]$pendingSpan.Add($ts)
        # 남은 시간이 주기보다 길면 오타(분을 시간으로 적는 등)일 가능성이 높다
        if ($cy -gt 0 -and $ts.TotalHours -gt ($cy + 0.5)) {
          [void]$odd.Add(('  {0} : {1}' -f [string]$r.Boss.Name, (Fmt-Input $ts)))
        }
      } elseif ([string]::IsNullOrWhiteSpace($r.Remain.Text)) {
        $r.Boss.NextSpawn = $null
      }
    }
    if ($odd.Count -gt 0) {
      $msg = "다음 보스는 남은 시간이 젠 주기보다 깁니다." + "`r`n`r`n" + ($odd -join "`r`n") + "`r`n`r`n" + "이대로 저장할까요?" + "`r`n" + "(아니오를 누르면 이 보스들의 시간은 그대로 둡니다)"
      $ans = [System.Windows.Forms.MessageBox]::Show($msg, '보스 시계 - 확인', 'YesNo', 'Warning')
      if ($ans -eq [System.Windows.Forms.DialogResult]::No) {
        for ($i = 0; $i -lt $pendingBoss.Count; $i++) {
          $cy2 = [double]$pendingBoss[$i].CycleHours
          if ($cy2 -gt 0 -and ([timespan]$pendingSpan[$i]).TotalHours -gt ($cy2 + 0.5)) { $pendingSpan[$i] = $null }
        }
      }
    }
    $stamp = Get-Date
    for ($i = 0; $i -lt $pendingBoss.Count; $i++) {
      if ($null -ne $pendingSpan[$i]) { $pendingBoss[$i].NextSpawn = $stamp.Add([timespan]$pendingSpan[$i]).ToString('s') }
    }
    Save-Cfg $cfgRef
    $d.Close()
  }.GetNewClosure())
  $pan.Controls.Add($ok)

  [void]$d.ShowDialog()
}

# ---------- 우클릭 메뉴 ----------
$menu = New-Object System.Windows.Forms.ContextMenuStrip
$miSet = $menu.Items.Add('시간 설정')
$miSet.Add_Click({ Show-Settings })
$script:MiOnline = $menu.Items.Add('온라인 모드 (컷 눌러야 넘어감)')
$script:MiOnline.CheckOnClick = $false
$script:MiOnline.Checked = [bool]$script:Cfg.Online
$script:MiOnline.Add_Click({ Toggle-Online })
$miPos = $menu.Items.Add('위치 초기화 (좌측 상단)')
$miPos.Add_Click({
  $wa2 = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
  $f.Location = New-Object System.Drawing.Point(($wa2.Left + 12), ($wa2.Top + 12))
  $script:Cfg.Pos.X = $f.Location.X
  $script:Cfg.Pos.Y = $f.Location.Y
  Save-Cfg $script:Cfg
})
[void]$menu.Items.Add('-')
$miEnd = $menu.Items.Add('종료')
$miEnd.Add_Click({ $f.Close() })
$f.ContextMenuStrip = $menu
foreach ($c in @($slotL, $slotLT, $slotR, $slotRT, $lblName, $lblTime)) { $c.ContextMenuStrip = $menu }

# ---------- 임박 경고 (빨간 위젯) ----------
function Set-Warn([bool]$on) {
  if ($script:Warn -eq $on) { return }
  $script:Warn = $on
  if ($on) { $bg = $C_WBG; $ln = $C_WLINE } else { $bg = $C_BG; $ln = $C_LINE }
  $f.BackColor = $bg
  foreach ($c in @($slotL, $slotLT, $slotR, $slotRT, $lblName, $lblTime, $btnCfg)) { $c.BackColor = $bg }
  if ($on) { $btnCfg.ForeColor = $C_WSUB } else { $btnCfg.ForeColor = $C_DIM }
  $btnCfg.FlatAppearance.MouseOverBackColor = $ln
  $vline.BackColor = $ln
  $hline.BackColor = $ln
  $script:BorderCol = $ln
  Update-OnlineBtn
  $f.Invalidate()
}

# ---------- 1초 갱신 ----------
function Short-Name([string]$n) {
  $s = $n -replace '^봉인된 ', ''
  if ($s.Length -gt 9) { $s = $s.Substring(0, 8) + [string][char]0x2026 }
  return $s
}

function Set-Preview($lbl, $tlbl, $list, $idx) {
  $w = $script:Warn
  if ($idx -ge @($list).Count) {
    $lbl.Text = '-'; $tlbl.Text = ''
    if ($w) { $c = $C_WLINE } else { $c = $C_LINE }
    $lbl.ForeColor = $c; $tlbl.ForeColor = $c
    return
  }
  $it = @($list)[$idx]
  $now = Get-Date
  $lbl.Text = Short-Name ([string]$it.B.Name)
  if ($it.T -le $now) {
    $tlbl.Text = '출현 중'
    if ($w) { $c = $C_WTX } else { $c = $C_LIT }
    $lbl.ForeColor = $c; $tlbl.ForeColor = $c
  } else {
    $tlbl.Text = Fmt-Short ($it.T - $now)
    if ($w) { $lbl.ForeColor = $C_WSUB; $tlbl.ForeColor = $C_WTX }
    else    { $lbl.ForeColor = $C_DIM;  $tlbl.ForeColor = $C_NAME }
  }
}

$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1000
$timer.Add_Tick({
  $script:Dirty = $false
  $now = Get-Date
  $ups  = New-Object System.Collections.ArrayList
  $pend = New-Object System.Collections.ArrayList
  foreach ($b in $script:Cfg.Bosses) {
    if (-not [bool]$b.Watch) { continue }
    $sp = Get-Spawn $b
    if (-not $sp) { continue }
    $item = [pscustomobject]@{ B = $b; T = $sp }
    if ($sp -le $now) { [void]$ups.Add($item) } else { [void]$pend.Add($item) }
  }
  # 출현 중인 보스 먼저, 그 다음 가까운 순서
  $list = @()
  if ($ups.Count  -gt 0) { $list += @($ups  | Sort-Object T) }
  if ($pend.Count -gt 0) { $list += @($pend | Sort-Object T) }

  if (@($list).Count -gt 0) {
    $m = @($list)[0]
    if ($m.T -le $now) {
      Set-Warn $false
      $lblName.Text = ('{0}  ·  출현 중' -f [string]$m.B.Name)
      $lblName.ForeColor = $C_NAME
      $lblTime.Text = '+' + (Fmt-Span ($now - $m.T))
      $lblTime.ForeColor = $C_LIT
      $btnCut.Tag = [string]$m.B.Name
      if (-not $btnCut.Visible) { $btnCut.Visible = $true }
    } else {
      $rem = $m.T - $now
      Set-Warn ($rem.TotalMinutes -le 5)
      $lblName.Text = [string]$m.B.Name
      $lblTime.Text = Fmt-Span $rem
      if ($script:Warn) {
        $lblName.ForeColor = $C_WSUB
        $lblTime.ForeColor = $C_WTX
      } else {
        $lblName.ForeColor = $C_NAME
        $lblTime.ForeColor = $C_TIME
      }
      $btnCut.Tag = $null
      if ($btnCut.Visible) { $btnCut.Visible = $false }
    }
  } else {
    Set-Warn $false
    $lblName.Text = '감시 대상 없음'
    $lblName.ForeColor = $C_NAME
    $lblTime.Text = '--:--'
    $lblTime.ForeColor = $C_DIM
    $btnCut.Tag = $null
    if ($btnCut.Visible) { $btnCut.Visible = $false }
  }
  Set-Preview $slotL $slotLT $list 1
  Set-Preview $slotR $slotRT $list 2
  if ($script:Dirty) { Save-Cfg $script:Cfg }
})
$timer.Start()

[System.Windows.Forms.Application]::Run($f)
