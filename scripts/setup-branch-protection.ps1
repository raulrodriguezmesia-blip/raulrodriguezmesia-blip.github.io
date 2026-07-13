<#
.SYNOPSIS
Configura branch protection para main en todos los repositorios del portfolio.
#>

param(
    [string]$GitHubToken = "",
    [string]$Owner = "raulrodriguezmesia-blip"
)

# Si no se pasa por parámetro, buscar en variable de entorno
if (-not $GitHubToken) {
    $GitHubToken = $env:GITHUB_TOKEN
}

if (-not $GitHubToken) {
    Write-Error "ERROR: Debes proporcionar un GitHub PAT. Ejecuta:"
    Write-Host "  `$env:GITHUB_TOKEN = 'TU_TOKEN_AQUI'" -ForegroundColor Yellow
    Write-Host "  .\scripts\setup-branch-protection.ps1" -ForegroundColor Yellow
    Write-Host "O bien:" -ForegroundColor Yellow
    Write-Host "  .\scripts\setup-branch-protection.ps1 -GitHubToken 'TU_TOKEN_AQUI'" -ForegroundColor Yellow
    exit 1
}

$headers = @{
    "Authorization" = "token $GitHubToken"
    "Accept" = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
}

$repos = @(
    "raulrodriguezmesia-blip.github.io",
    "excepciones",
    "ferreteria",
    "java-junior-portfolio",
    "springboot",
    "springboot-feature-flag",
    "Alcaldia",
    "eros-code-analysis-agent",
    "aws-cost-optimizer-ml",
    "Aws-Portfolio-final",
    "sdk-springboot"
)

$protection = @{
    required_status_checks = @{
        strict = $true
        checks = @(
            @{ context = "build"; app_id = 0 }
        )
    }
    enforce_admins = $true
    required_pull_request_reviews = @{
        required_approving_review_count = 1
        dismiss_stale_reviews = $true
    }
    restrictions = $null
    allow_force_pushes = $false
    allow_deletions = $false
    block_creations = $false
    required_linear_history = $false
} | ConvertTo-Json -Depth 10

foreach ($repo in $repos) {
    $url = "https://api.github.com/repos/$Owner/$repo/branches/main/protection"
    
    try {
        $response = Invoke-RestMethod -Uri $url -Method Put -Headers $headers -Body $protection -ContentType "application/json"
        Write-Host "✅ Branch protection aplicada: $repo" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error en $repo : $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nProceso completado." -ForegroundColor Cyan
