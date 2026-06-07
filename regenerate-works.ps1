# Scans html/assets subfolders with images -> works-manifest.json + works-manifest.js
# (works-manifest.js sets window.__WORKS_MANIFEST for file:// viewing without a server)
# Run: powershell -ExecutionPolicy Bypass -File .\regenerate-works.ps1

$ErrorActionPreference = "Stop"
$htmlDir = $PSScriptRoot
$assets = Join-Path $htmlDir "assets"
if (-not (Test-Path -LiteralPath $assets)) {
  Write-Error "Missing folder: $assets"
  exit 1
}

$imageExt = @(
  ".jpg", ".jpeg", ".png", ".webp", ".gif", ".bmp", ".tif", ".tiff",
  ".JPG", ".JPEG", ".PNG", ".WEBP", ".GIF"
)
$projects = New-Object System.Collections.ArrayList
# "Двухэтажный кирпичный дом (Симоново)" — codepoints so .ps1 stays ASCII-only
$folderKeepForward = -join @(
  @(0x0414,0x0432,0x0443,0x0445,0x044D,0x0442,0x0430,0x0436,0x043D,0x044B,0x0439,0x0020,
    0x043A,0x0438,0x0440,0x043F,0x0438,0x0447,0x043D,0x044B,0x0439,0x0020,
    0x0434,0x043E,0x043C,0x0020,
    0x0028,0x0421,0x0438,0x043C,0x043E,0x043D,0x043E,0x0432,0x043E,0x0029) | ForEach-Object { [char]$_ }
)

Get-ChildItem -LiteralPath $assets -Directory | Sort-Object Name | ForEach-Object {
  $dir = $_
  $files = Get-ChildItem -LiteralPath $dir.FullName -File -ErrorAction SilentlyContinue |
    Where-Object { $imageExt -contains $_.Extension }
  if ($dir.Name -eq $folderKeepForward) {
    $ordered = $files | Sort-Object Name
  } else {
    $ordered = $files | Sort-Object Name -Descending
  }
  $imgs = $ordered | ForEach-Object { "assets/$($dir.Name)/$($_.Name)" }
  if ($imgs.Count -eq 0) { return }
  [void]$projects.Add([ordered]@{ folder = $dir.Name; images = @($imgs) })
}

$payload = [ordered]@{ projects = @($projects.ToArray()) }
$json = $payload | ConvertTo-Json -Depth 12
$jsonPath = Join-Path $assets "works-manifest.json"
$jsPath = Join-Path $assets "works-manifest.js"
$utf8 = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($jsonPath, $json, $utf8)
$jsBody = "window.__WORKS_MANIFEST = " + $json.Trim() + ";`r`n"
[System.IO.File]::WriteAllText($jsPath, $jsBody, $utf8)
Write-Host "OK: $($projects.Count) projects -> works-manifest.json + works-manifest.js"
