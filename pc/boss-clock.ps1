# 제우스 보스 시계 - 출력 전용 위젯
# 컷 입력과 설정은 웹(https://dorazi95.github.io/zeus-boss-clock/)에서 하고,
# 이 위젯은 공유 서버의 시간을 받아 보여주기만 한다.

# 이미 떠 있으면 중복 실행하지 않는다
$script:__created = $false
$script:__mutex = New-Object System.Threading.Mutex($true, 'Local\ZeusBossClockSingleInstance', [ref]$script:__created)
if (-not $script:__created) { exit }

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$Root    = Split-Path -Parent $MyInvocation.MyCommand.Definition
$CfgPath = Join-Path $Root 'widget.json'
$DbUrl   = 'https://zeus-boss-clock-default-rtdb.firebaseio.com'
$WebUrl  = 'https://dorazi95.github.io/zeus-boss-clock/'

# 화면에서 뺄 보스 (웹의 체크 해제와 같은 역할)
$Hidden = @('거인의 세번째 손')

# ---------- 보스 정보 ----------
$Bosses = @(
  @{ Name='아르고스';          Lv=65; Type='weekly'; Weekday=1; Hour=21 }
  @{ Name='메데이아';          Lv=45; Type='weekly'; Weekday=2; Hour=21 }
  @{ Name='아라크네';          Lv=50; Type='weekly'; Weekday=3; Hour=21 }
  @{ Name='케르베로스';        Lv=75; Type='weekly'; Weekday=5; Hour=21 }
  @{ Name='키메라';            Lv=60; Type='weekly'; Weekday=6; Hour=21 }
  @{ Name='심연의 틈';         Lv=0;  Type='daily';  Hours=@(12, 20) }
  @{ Name='크리소파고스';      Lv=35; Type='cycle' }
  @{ Name='아모르포스';        Lv=35; Type='cycle' }
  @{ Name='트라손';            Lv=40; Type='cycle' }
  @{ Name='이오칸토스';        Lv=45; Type='cycle' }
  @{ Name='키니 러우리';       Lv=45; Type='cycle' }
  @{ Name='알라스토르';        Lv=55; Type='cycle' }
  @{ Name='베딕스';            Lv=60; Type='cycle' }
  @{ Name='고트시스';          Lv=60; Type='cycle' }
  @{ Name='트리포크';          Lv=65; Type='cycle' }
  @{ Name='거인의 세번째 손';  Lv=70; Type='cycle' }
  @{ Name='봉인된 아모르포스'; Lv=40; Type='cycle' }
  @{ Name='봉인된 브델레스';   Lv=45; Type='cycle' }
)
$script:Spawn = @{}   # 보스명 -> [datetime] (서버에서 받은 젠 시각)

# ---------- 설정 (위치, 테마) ----------
function Load-Cfg {
  $c = [pscustomobject]@{ X = $null; Y = $null; Theme = 'dark'; Sound = $true; Spawn = @{} }
  if (Test-Path $CfgPath) {
    try {
      $raw = Get-Content $CfgPath -Raw -Encoding UTF8
      if (-not [string]::IsNullOrWhiteSpace($raw)) {
        $j = $raw | ConvertFrom-Json
        if ($null -ne $j.X) { $c.X = [int]$j.X }
        if ($null -ne $j.Y) { $c.Y = [int]$j.Y }
        if ($j.Theme -eq 'light' -or $j.Theme -eq 'dark') { $c.Theme = $j.Theme }
        if ($null -ne $j.Sound) { $c.Sound = [bool]$j.Sound }
        if ($j.Spawn) { foreach ($p in $j.Spawn.PSObject.Properties) { $c.Spawn[$p.Name] = [string]$p.Value } }
      }
    } catch { }
  }
  return $c
}
function Save-Cfg {
  try {
    $keep = @{}
    foreach ($k in $script:Spawn.Keys) { $keep[$k] = $script:Spawn[$k].ToString('s') }
    $out = [pscustomobject]@{ X = $script:Cfg.X; Y = $script:Cfg.Y; Theme = $script:Cfg.Theme; Sound = $script:Cfg.Sound; Spawn = $keep }
    $tmp = $CfgPath + '.tmp'
    [System.IO.File]::WriteAllText($tmp, ($out | ConvertTo-Json -Depth 4), (New-Object System.Text.UTF8Encoding($true)))
    Move-Item -LiteralPath $tmp -Destination $CfgPath -Force
  } catch { }
}
$script:Cfg = Load-Cfg
foreach ($k in $script:Cfg.Spawn.Keys) {
  try { $script:Spawn[$k] = [datetime]::Parse($script:Cfg.Spawn[$k]) } catch { }
}

# ---------- 서버에서 시간 받아오기 ----------
function Boss-Key([string]$name) { return ($name -replace '[.#$\[\]/\s]', '_') }
$script:Online = $false
$script:LastPull = [datetime]::MinValue

function Sync-Pull {
  try {
    $r = Invoke-RestMethod -Uri ($DbUrl + '/cuts.json') -Method GET -TimeoutSec 8
  } catch { $script:Online = $false; return }
  $script:Online = $true
  if (-not $r) { return }
  foreach ($b in $Bosses) {
    if ($b.Type -ne 'cycle') { continue }
    $v = $r.PSObject.Properties[(Boss-Key $b.Name)]
    if (-not $v -or -not $v.Value.at) { continue }
    try { $script:Spawn[$b.Name] = [datetime]::Parse([string]$v.Value.at) } catch { }
  }
  Save-Cfg
}

# ---------- 시간 계산 ----------
function Next-Weekly($b, $now) {
  $d = $now.Date.AddHours([int]$b.Hour).AddDays((([int]$b.Weekday - [int]$now.DayOfWeek) + 7) % 7)
  while ($d -le $now) { $d = $d.AddDays(7) }
  return $d
}
function Next-Daily($b, $now) {
  $best = $null
  foreach ($day in 0..1) {
    foreach ($h in $b.Hours) {
      $d = $now.Date.AddDays($day).AddHours([int]$h)
      if ($d -gt $now -and ($null -eq $best -or $d -lt $best)) { $best = $d }
    }
  }
  return $best
}
function Spawn-Of($b, $now) {
  switch ($b.Type) {
    'weekly' { return (Next-Weekly $b $now) }
    'daily'  { return (Next-Daily  $b $now) }
    default  { if ($script:Spawn.ContainsKey($b.Name)) { return $script:Spawn[$b.Name] } else { return $null } }
  }
}
function Fmt-Span([timespan]$ts) {
  if ($ts.TotalSeconds -lt 0) { return '00:00' }
  if ($ts.TotalDays -ge 1)  { return ('{0}일 {1}:{2:00}' -f [int][Math]::Floor($ts.TotalDays), $ts.Hours, $ts.Minutes) }
  if ($ts.TotalHours -ge 1) { return ('{0}:{1:00}:{2:00}' -f [int][Math]::Floor($ts.TotalHours), $ts.Minutes, $ts.Seconds) }
  return ('{0}:{1:00}' -f $ts.Minutes, $ts.Seconds)
}
function Fmt-Short([timespan]$ts) {
  if ($ts.TotalSeconds -lt 0) { return '0분' }
  if ($ts.TotalDays -ge 1)  { return ('{0}일 {1}시간' -f [int][Math]::Floor($ts.TotalDays), $ts.Hours) }
  if ($ts.TotalHours -ge 1) { return ('{0}:{1:00}' -f [int][Math]::Floor($ts.TotalHours), $ts.Minutes) }
  return ('{0}분' -f $ts.Minutes)
}
# ---------- 5분 전 음성 알림 ----------
# 브라우저와 달리 위젯은 클릭 없이도 소리를 낼 수 있다.
$script:Warned = @{}
$script:Primed = $false
$script:Synth  = $null

function Get-Synth {
  if ($null -ne $script:Synth) { return $script:Synth }
  try {
    Add-Type -AssemblyName System.Speech -ErrorAction Stop
    $s = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $ko = $s.GetInstalledVoices() | Where-Object { $_.Enabled -and $_.VoiceInfo.Culture.Name -like 'ko*' } | Select-Object -First 1
    if ($ko) { $s.SelectVoice($ko.VoiceInfo.Name) }
    $script:Synth = $s
  } catch { $script:Synth = $null }
  return $script:Synth
}

function Announce([string]$name) {
  try { [System.Media.SystemSounds]::Exclamation.Play() } catch { }
  $s = Get-Synth
  if ($null -ne $s) {
    try { [void]$s.SpeakAsync("$name 5분 전입니다") } catch { }
  }
}

function Check-Alert($item, [timespan]$left) {
  $k = [string]$item.B.Name + '|' + $item.T.Ticks
  if ($left.TotalMilliseconds -gt 300000 -or $left.TotalMilliseconds -le 0) { return }
  if ($script:Warned.ContainsKey($k)) { return }
  $script:Warned[$k] = $true
  if ($script:Primed -and $script:Cfg.Sound) { Announce ([string]$item.B.Name) }
}

function Short-Name([string]$n) {
  $s = $n -replace '^봉인된 ', ''
  if ($s.Length -gt 9) { $s = $s.Substring(0, 8) + [string][char]0x2026 }
  return $s
}

# ---------- 색 ----------
$script:P = @{}
function Set-Palette {
  if ($script:Cfg.Theme -eq 'light') {
    $script:P.BG   = [System.Drawing.Color]::FromArgb(0xFF,0xFF,0xFF)
    $script:P.LINE = [System.Drawing.Color]::FromArgb(0xD8,0xDE,0xE6)
    $script:P.DIM  = [System.Drawing.Color]::FromArgb(0x7A,0x84,0x94)
    $script:P.NAME = [System.Drawing.Color]::FromArgb(0x4A,0x54,0x64)
    $script:P.TIME = [System.Drawing.Color]::FromArgb(0x15,0x19,0x22)
    $script:P.LIT  = [System.Drawing.Color]::FromArgb(0xB0,0x6A,0x08)
    $script:P.WBG  = [System.Drawing.Color]::FromArgb(0xC8,0x38,0x2F)
    $script:P.WTX  = [System.Drawing.Color]::FromArgb(0xFF,0xFF,0xFF)
    $script:P.WSUB = [System.Drawing.Color]::FromArgb(0xFF,0xDA,0xD7)
    $script:P.WLINE= [System.Drawing.Color]::FromArgb(0xE8,0x8A,0x90)
  } else {
    $script:P.BG   = [System.Drawing.Color]::FromArgb(0x14,0x16,0x1C)
    $script:P.LINE = [System.Drawing.Color]::FromArgb(0x3D,0x45,0x5E)
    $script:P.DIM  = [System.Drawing.Color]::FromArgb(0x93,0x9C,0xB4)
    $script:P.NAME = [System.Drawing.Color]::FromArgb(0xB4,0xBD,0xD2)
    $script:P.TIME = [System.Drawing.Color]::FromArgb(0xF4,0xF7,0xFC)
    $script:P.LIT  = [System.Drawing.Color]::FromArgb(0xEF,0xA1,0x27)
    $script:P.WBG  = [System.Drawing.Color]::FromArgb(0xA8,0x18,0x22)
    $script:P.WTX  = [System.Drawing.Color]::FromArgb(0xFF,0xFF,0xFF)
    $script:P.WSUB = [System.Drawing.Color]::FromArgb(0xFF,0xCF,0xD2)
    $script:P.WLINE= [System.Drawing.Color]::FromArgb(0xE8,0x8A,0x90)
  }
}
Set-Palette

# ---------- 위젯 ----------
$W = 290; $H = 112
$script:Warn = $false
$script:BorderCol = $script:P.LINE

$f = New-Object System.Windows.Forms.Form
$f.FormBorderStyle = 'None'
$f.ShowInTaskbar   = $false
$f.TopMost         = $true
$f.BackColor       = $script:P.BG
$f.Size            = New-Object System.Drawing.Size($W, $H)
$f.StartPosition   = 'Manual'
$f.Text            = '보스 시계'

function Clamp-Loc([int]$x, [int]$y) {
  $vs = [System.Windows.Forms.SystemInformation]::VirtualScreen
  if ($x -lt $vs.Left) { $x = $vs.Left }
  if ($y -lt $vs.Top)  { $y = $vs.Top }
  if ($x -gt ($vs.Right - $W))  { $x = $vs.Right - $W }
  if ($y -gt ($vs.Bottom - $H)) { $y = $vs.Bottom - $H }
  return (New-Object System.Drawing.Point($x, $y))
}
$wa = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
$loc = New-Object System.Drawing.Point(($wa.Left + 12), ($wa.Top + 12))
if ($null -ne $script:Cfg.X -and $null -ne $script:Cfg.Y) { $loc = Clamp-Loc $script:Cfg.X $script:Cfg.Y }
$f.Location = $loc

$fontSlot   = New-Object System.Drawing.Font('맑은 고딕', 9.0, [System.Drawing.FontStyle]::Bold)
$fontSlotSm = New-Object System.Drawing.Font('맑은 고딕', 8.0)
$fontName   = New-Object System.Drawing.Font('맑은 고딕', 9.5)
$fontTime   = New-Object System.Drawing.Font('Consolas', 26.0, [System.Drawing.FontStyle]::Bold)

function New-Lbl($x, $y, $w, $h, $font, $color, $align) {
  $l = New-Object System.Windows.Forms.Label
  $l.Size = New-Object System.Drawing.Size($w, $h)
  $l.Location = New-Object System.Drawing.Point($x, $y)
  $l.TextAlign = $align
  $l.Font = $font
  $l.ForeColor = $color
  $l.BackColor = $script:P.BG
  return $l
}
$slotL  = New-Lbl 1   3  142 17 $fontSlot   $script:P.DIM  'MiddleCenter'
$slotLT = New-Lbl 1   19 142 14 $fontSlotSm $script:P.DIM  'MiddleCenter'
$slotR  = New-Lbl 147 3  142 17 $fontSlot   $script:P.DIM  'MiddleCenter'
$slotRT = New-Lbl 147 19 142 14 $fontSlotSm $script:P.DIM  'MiddleCenter'
$lblName = New-Lbl 12 41 ($W - 20) 18 $fontName $script:P.NAME 'MiddleLeft'
$lblTime = New-Lbl 10 62 ($W - 20) 42 $fontTime $script:P.TIME 'MiddleLeft'

$vline = New-Object System.Windows.Forms.Panel
$vline.Size = New-Object System.Drawing.Size(1, 27)
$vline.Location = New-Object System.Drawing.Point(145, 4)
$vline.BackColor = $script:P.LINE

$hline = New-Object System.Windows.Forms.Panel
$hline.Size = New-Object System.Drawing.Size(($W - 2), 1)
$hline.Location = New-Object System.Drawing.Point(1, 37)
$hline.BackColor = $script:P.LINE

$btnTheme = New-Object System.Windows.Forms.Button
$btnTheme.Text = [string][char]0x25D0
$btnTheme.Font = New-Object System.Drawing.Font('Segoe UI Symbol', 11.0)
$btnTheme.Size = New-Object System.Drawing.Size(24, 24)
$btnTheme.Location = New-Object System.Drawing.Point(258, 80)
$btnTheme.TextAlign = 'MiddleCenter'
$btnTheme.FlatStyle = 'Flat'
$btnTheme.FlatAppearance.BorderSize = 0
$btnTheme.TabStop = $false
$btnTheme.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnTheme.ForeColor = $script:P.DIM
$btnTheme.BackColor = $script:P.BG

$f.Controls.AddRange(@($slotL, $slotLT, $slotR, $slotRT, $vline, $hline, $lblName, $lblTime, $btnTheme))
$btnTheme.BringToFront()
$tip = New-Object System.Windows.Forms.ToolTip
$tip.SetToolTip($btnTheme, '다크 모드 / 일반 모드 전환')

$f.Add_Paint({
  param($s, $e)
  $p = New-Object System.Drawing.Pen($script:BorderCol, 1)
  $e.Graphics.DrawRectangle($p, 0, 0, $s.Width - 1, $s.Height - 1)
  $p.Dispose()
})

# ---------- 테마 ----------
function Paint-Theme {
  Set-Palette
  $bg = $script:P.BG
  if ($script:Warn) { $bg = $script:P.WBG }
  $ln = $script:P.LINE
  if ($script:Warn) { $ln = $script:P.WLINE }
  $f.BackColor = $bg
  foreach ($c in @($slotL, $slotLT, $slotR, $slotRT, $lblName, $lblTime, $btnTheme)) { $c.BackColor = $bg }
  $vline.BackColor = $ln
  $hline.BackColor = $ln
  $script:BorderCol = $ln
  if ($script:Warn) { $btnTheme.ForeColor = $script:P.WSUB } else { $btnTheme.ForeColor = $script:P.DIM }
  $btnTheme.FlatAppearance.MouseOverBackColor = $ln
  $f.Invalidate()
}
function Toggle-Theme {
  if ($script:Cfg.Theme -eq 'light') { $script:Cfg.Theme = 'dark' } else { $script:Cfg.Theme = 'light' }
  Paint-Theme
  Save-Cfg
}
$btnTheme.Add_Click({ Toggle-Theme })

function Set-Warn([bool]$on) {
  if ($script:Warn -eq $on) { return }
  $script:Warn = $on
  Paint-Theme
}

# ---------- 드래그 이동 ----------
$script:Drag = $false; $script:Moved = $false
$script:DragStart = New-Object System.Drawing.Point(0, 0)
$script:DragOrigin = New-Object System.Drawing.Point(0, 0)
$onDown = {
  param($s, $e)
  if ($e.Button -ne [System.Windows.Forms.MouseButtons]::Left) { return }
  $script:Drag = $true; $script:Moved = $false
  $script:DragStart = [System.Windows.Forms.Cursor]::Position
  $script:DragOrigin = $f.Location
}
$onMove = {
  param($s, $e)
  if (-not $script:Drag) { return }
  $c = [System.Windows.Forms.Cursor]::Position
  $dx = $c.X - $script:DragStart.X; $dy = $c.Y - $script:DragStart.Y
  if ([Math]::Abs($dx) -gt 3 -or [Math]::Abs($dy) -gt 3) { $script:Moved = $true }
  if ($script:Moved) { $f.Location = Clamp-Loc ($script:DragOrigin.X + $dx) ($script:DragOrigin.Y + $dy) }
}
$onUp = {
  param($s, $e)
  if (-not $script:Drag) { return }
  $script:Drag = $false
  if ($script:Moved) { $script:Cfg.X = $f.Location.X; $script:Cfg.Y = $f.Location.Y; Save-Cfg }
}
foreach ($c in @($f, $slotL, $slotLT, $slotR, $slotRT, $lblName, $lblTime)) {
  $c.Add_MouseDown($onDown); $c.Add_MouseMove($onMove); $c.Add_MouseUp($onUp)
}

# ---------- 우클릭 메뉴 ----------
$menu = New-Object System.Windows.Forms.ContextMenuStrip
$miTheme = $menu.Items.Add('다크 / 일반 모드 전환')
$miTheme.Add_Click({ Toggle-Theme })
$script:MiSound = $menu.Items.Add('5분 전 소리 알림')
$script:MiSound.CheckOnClick = $false
$script:MiSound.Checked = [bool]$script:Cfg.Sound
$script:MiSound.Add_Click({
  $script:Cfg.Sound = -not [bool]$script:Cfg.Sound
  $script:MiSound.Checked = [bool]$script:Cfg.Sound
  Save-Cfg
  if ($script:Cfg.Sound) { Announce '소리 알림' }
})
$miWeb = $menu.Items.Add('웹에서 컷 입력하기')
$miWeb.Add_Click({ Start-Process $WebUrl })
$miPos = $menu.Items.Add('위치 초기화')
$miPos.Add_Click({
  $wa2 = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
  $f.Location = New-Object System.Drawing.Point(($wa2.Left + 12), ($wa2.Top + 12))
  $script:Cfg.X = $f.Location.X; $script:Cfg.Y = $f.Location.Y; Save-Cfg
})
[void]$menu.Items.Add('-')
$miEnd = $menu.Items.Add('종료')
$miEnd.Add_Click({ $f.Close() })
$f.ContextMenuStrip = $menu
foreach ($c in @($slotL, $slotLT, $slotR, $slotRT, $lblName, $lblTime)) { $c.ContextMenuStrip = $menu }

# ---------- 1초 갱신 ----------
function Set-Preview($lbl, $tlbl, $list, $idx) {
  if ($idx -ge @($list).Count) {
    $lbl.Text = '-'; $tlbl.Text = ''
    if ($script:Warn) { $c = $script:P.WLINE } else { $c = $script:P.LINE }
    $lbl.ForeColor = $c; $tlbl.ForeColor = $c
    return
  }
  $it = @($list)[$idx]
  $now = Get-Date
  $lbl.Text = Short-Name ([string]$it.B.Name)
  if ($it.T -le $now) {
    $tlbl.Text = '출현 중'
    if ($script:Warn) { $c = $script:P.WTX } else { $c = $script:P.LIT }
    $lbl.ForeColor = $c; $tlbl.ForeColor = $c
  } else {
    $tlbl.Text = Fmt-Short ($it.T - $now)
    if ($script:Warn) { $lbl.ForeColor = $script:P.WSUB; $tlbl.ForeColor = $script:P.WTX }
    else { $lbl.ForeColor = $script:P.DIM; $tlbl.ForeColor = $script:P.NAME }
  }
}

$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1000
$timer.Add_Tick({
  $now = Get-Date
  if (($now - $script:LastPull).TotalSeconds -ge 15) { $script:LastPull = $now; Sync-Pull }

  $ups = New-Object System.Collections.ArrayList
  $pend = New-Object System.Collections.ArrayList
  foreach ($b in $Bosses) {
    if ($Hidden -contains $b.Name) { continue }
    $sp = Spawn-Of $b $now
    if (-not $sp) { continue }
    $item = [pscustomobject]@{ B = $b; T = $sp }
    if ($sp -le $now) { [void]$ups.Add($item) } else { [void]$pend.Add($item) }
  }
  $list = @()
  if ($ups.Count  -gt 0) { $list += @($ups  | Sort-Object T) }
  if ($pend.Count -gt 0) { $list += @($pend | Sort-Object T) }
  foreach ($it in $pend) { Check-Alert $it ($it.T - $now) }
  $script:Primed = $true

  if (@($list).Count -gt 0) {
    $m = @($list)[0]
    $rem = $m.T - $now
    $lblName.Text = [string]$m.B.Name
    if ($m.T -le $now) {
      $lblTime.Text = '출현 중 +' + (Fmt-Span ($now - $m.T))
      Set-Warn $false
      if (-not $script:Warn) { $lblTime.ForeColor = $script:P.LIT }
    } else {
      $lblTime.Text = Fmt-Span $rem
      Set-Warn ($rem.TotalMinutes -le 5)
      if ($script:Warn) { $lblTime.ForeColor = $script:P.WTX } else { $lblTime.ForeColor = $script:P.TIME }
    }
    if ($script:Warn) { $lblName.ForeColor = $script:P.WSUB } else { $lblName.ForeColor = $script:P.NAME }
  } else {
    Set-Warn $false
    $lblName.Text = '서버 연결 대기 중'
    $lblTime.Text = '--:--'
    $lblTime.ForeColor = $script:P.DIM
  }
  Set-Preview $slotL $slotLT $list 1
  Set-Preview $slotR $slotRT $list 2
  if (-not $script:Online) { $lblName.Text = $lblName.Text + '  (오프라인)' }
})

Paint-Theme
Sync-Pull
$timer.Start()

[System.Windows.Forms.Application]::Run($f)
