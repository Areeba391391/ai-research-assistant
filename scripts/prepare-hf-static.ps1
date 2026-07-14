# Build React UI and copy into hf-static/ for Hugging Face Static Space deploy.
param(
    [Parameter(Mandatory = $true)]
    [string]$BackendUrl
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$frontend = Join-Path $root "frontend"
$out = Join-Path $root "hf-static"

$apiBase = $BackendUrl.TrimEnd("/")
if (-not $apiBase.EndsWith("/api")) {
    $apiBase = "$apiBase/api"
}

Write-Host "Building frontend with VITE_API_BASE=$apiBase"
Push-Location $frontend
$env:VITE_API_BASE = $apiBase
npm run build
Pop-Location

if (Test-Path $out) { Remove-Item $out -Recurse -Force }
New-Item -ItemType Directory -Path $out | Out-Null

Copy-Item -Recurse (Join-Path $frontend "dist\*") $out

@"
---
title: AI Research Assistant
emoji: 🔬
colorFrom: blue
colorTo: purple
sdk: static
pinned: false
---

# AI Research Assistant

Static UI for the [AI Research Assistant](https://github.com/afreen-gul/ai-research-assistant) app.
Backend API: $BackendUrl
"@ | Set-Content -Path (Join-Path $out "README.md") -Encoding utf8

Write-Host "Done. Upload contents of hf-static/ to your Hugging Face Static Space."
