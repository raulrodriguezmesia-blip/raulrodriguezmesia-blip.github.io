# Script: Update profile images and README assets
# Updates both portfolio repo and profile repo from source folders

param(
    [string]$PortfolioRepo = ".",
    [string]$ProfileRepo = "..\raulrodriguezmesia-blip",
    [string]$SourceImages = "C:\Users\Administrador\Documents\images",
    [string]$SourceCerts = "C:\Users\Administrador\Documents\certs"
)

$ErrorActionPreference = 'Stop'

function Write-Step($msg) { Write-Host "`n[STEP] $msg" -ForegroundColor Cyan }
function Write-Ok($msg) { Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }

# 1. Validate sources
Write-Step "Validating source folders"
if (-not (Test-Path -LiteralPath $SourceImages)) { throw "Source images folder not found: $SourceImages" }
if (-not (Test-Path -LiteralPath $SourceCerts)) { throw "Source certs folder not found: $SourceCerts" }

$bannerSrc = Join-Path $SourceImages "banner.png"
if (-not (Test-Path -LiteralPath $bannerSrc)) { throw "banner.png not found in $SourceImages" }

# 2. Update Portfolio Repo
Write-Step "Updating portfolio repo: $PortfolioRepo"
$portfolioImages = Join-Path $PortfolioRepo "images"
$portfolioCerts = Join-Path $PortfolioRepo "certs"

New-Item -ItemType Directory -Force -Path $portfolioImages | Out-Null
New-Item -ItemType Directory -Force -Path $portfolioCerts | Out-Null

Copy-Item -LiteralPath $bannerSrc -Destination (Join-Path $portfolioImages "banner.png") -Force
$certFiles = Get-ChildItem -LiteralPath $SourceCerts -File | Where-Object { $_.Extension -match '\.(png|jpg|jpeg|webp)$' }
foreach ($f in $certFiles) {
    Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $portfolioCerts $f.Name) -Force
}
Write-Ok "Portfolio images updated"

# 3. Update Profile Repo
Write-Step "Updating profile repo: $ProfileRepo"
if (-not (Test-Path -LiteralPath $ProfileRepo)) {
    Write-Warn "Profile repo folder not found, skipping profile update"
} else {
    $profileImages = Join-Path $ProfileRepo "images"
    $profileCerts = Join-Path $ProfileRepo "certs"

    New-Item -ItemType Directory -Force -Path $profileImages | Out-Null
    New-Item -ItemType Directory -Force -Path $profileCerts | Out-Null

    Copy-Item -LiteralPath $bannerSrc -Destination (Join-Path $profileImages "banner.png") -Force
    foreach ($f in $certFiles) {
        Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $profileCerts $f.Name) -Force
    }
    Write-Ok "Profile images updated"
}

# 4. Show summary
Write-Step "Summary of updated files"
Write-Host "`nPortfolio repo images:" -ForegroundColor Yellow
Get-ChildItem -LiteralPath $portfolioImages | Select-Object Name, Length | Format-Table -AutoSize
Get-ChildItem -LiteralPath $portfolioCerts | Select-Object Name, Length | Format-Table -AutoSize

if (Test-Path -LiteralPath $ProfileRepo) {
    Write-Host "`nProfile repo images:" -ForegroundColor Yellow
    Get-ChildItem -LiteralPath (Join-Path $ProfileRepo "images") | Select-Object Name, Length | Format-Table -AutoSize
    Get-ChildItem -LiteralPath (Join-Path $ProfileRepo "certs") | Select-Object Name, Length | Format-Table -AutoSize
}

Write-Host "`nNext steps:" -ForegroundColor Magenta
Write-Host "1. Review the changes in both repos"
Write-Host "2. Run: git add README.md images/ certs/"
Write-Host "3. Run: git commit -m 'Update banner and certification logos'"
Write-Host "4. Run: git push origin main"
Write-Host "`nRepeat steps 2-4 in the profile repo folder if needed."
