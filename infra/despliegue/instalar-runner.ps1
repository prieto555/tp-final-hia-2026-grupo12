param(
    [Parameter(Mandatory=$false)]
    [string]$Token = "",
    [string]$RepoUrl = "https://github.com/prieto555/tp-final-hia-2026-grupo12",
    [string]$RunnerDir = "$HOME\actions-runner"
)

Write-Host "=== Configurando GitHub Self-Hosted Runner para RestoYa ===" -ForegroundColor Cyan

if (-not $Token) {
    Write-Host "`n[!] Falta el token de registro de GitHub." -ForegroundColor Red
    Write-Host "Para obtenerlo:" -ForegroundColor Yellow
    Write-Host "1. Anda a tu repositorio en GitHub: $RepoUrl"
    Write-Host "2. Settings -> Actions -> Runners -> New self-hosted runner"
    Write-Host "3. Copia el token que aparece despues de --token"
    Write-Host "`nEjecuta el script pasando el token:" -ForegroundColor Yellow
    Write-Host "powershell -ExecutionPolicy Bypass -File infra/despliegue/instalar-runner.ps1 -Token TU_TOKEN_DE_GITHUB`n"
    exit 1
}

# 1. Crear directorio del runner
if (!(Test-Path $RunnerDir)) {
    New-Item -ItemType Directory -Path $RunnerDir -Force | Out-Null
    Write-Host "[+] Directorio creado: $RunnerDir" -ForegroundColor Green
}

Set-Location $RunnerDir

# 2. Descargar runner si no existe config.cmd
$runnerZip = "$RunnerDir\actions-runner-win.zip"
if (!(Test-Path "$RunnerDir\config.cmd")) {
    $runnerVersion = "2.321.0"
    $downloadUrl = "https://github.com/actions/runner/releases/download/v$runnerVersion/actions-runner-win-x64-$runnerVersion.zip"
    Write-Host "[*] Descargando GitHub Runner v$runnerVersion..." -ForegroundColor Yellow
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $downloadUrl -OutFile $runnerZip
    Write-Host "[*] Descomprimiendo runner..." -ForegroundColor Yellow
    Expand-Archive -Path $runnerZip -DestinationPath $RunnerDir -Force
    Remove-Item $runnerZip -Force
}

# 3. Configurar el runner con la etiqueta requerida por entrega.yml: restoya-produccion
Write-Host "[*] Registrando el runner con la etiqueta 'restoya-produccion'..." -ForegroundColor Yellow
& .\config.cmd --url $RepoUrl --token $Token --name "restoya-runner-$(hostname)" --labels "restoya-produccion" --unattended --replace

Write-Host "`n=======================================================" -ForegroundColor Green
Write-Host "  RUNNER REGISTRADO CON EXITO CON 'restoya-produccion' " -ForegroundColor Green
Write-Host "=======================================================" -ForegroundColor Green
Write-Host "Para ponerlo a escuchar trabajos de despliegue ahora mismo:" -ForegroundColor Cyan
Write-Host "cd $RunnerDir"
Write-Host ".\run.cmd`n" -ForegroundColor White
