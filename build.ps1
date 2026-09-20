# 本地构建：从环境变量注入高德 Key，输出 dist/index.html（与 Actions 注入逻辑一致）
# 用法：先设置环境变量 AMAP_KEY / AMAP_JCODE，再运行  .\build.ps1，最后打开 dist/index.html
$ErrorActionPreference = "Stop"

$key = $env:AMAP_KEY
$jcode = $env:AMAP_JCODE
if (-not $key -or -not $jcode) {
    Write-Error "请先设置环境变量 AMAP_KEY 与 AMAP_JCODE（高德 Web 端 JS API Key 与安全密钥）"
    exit 1
}

$html = Get-Content -Raw -Encoding UTF8 "index.html"
if ($html -notmatch "__AMAP_KEY__" -or $html -notmatch "__AMAP_JCODE__") {
    Write-Error "index.html 中未找到占位符 __AMAP_KEY__ / __AMAP_JCODE__，可能已注入过"
    exit 1
}

$html = $html.Replace("__AMAP_KEY__", $key).Replace("__AMAP_JCODE__", $jcode)

New-Item -ItemType Directory -Force -Path "dist" | Out-Null
Set-Content -Path "dist/index.html" -Value $html -Encoding UTF8 -NoNewline
Write-Host "已生成 dist/index.html（dist/ 不纳入 git）"
