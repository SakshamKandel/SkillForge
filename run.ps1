$ErrorActionPreference = 'Stop'

# ── Tooling paths ──────────────────────────────────────────────────
$tooling   = "E:\SkillForge\tooling"
$tomcatDir = "$tooling\apache-tomcat-10.1.20"
$jdkDir    = "$tooling\jdk-17.0.10+7"

# ── Copy tooling from GymPulse if not present ──────────────────────
if (-not (Test-Path $tomcatDir)) {
    Write-Host "[1/6] Copying Tomcat 10.1.20 from GymPulse..."
    New-Item -ItemType Directory -Force -Path $tooling | Out-Null
    Copy-Item -Path "E:\GymPulse\tooling\apache-tomcat-10.1.20" -Destination $tomcatDir -Recurse -Force
    # Change port to 8082 to avoid conflict with XAMPP (8080) and GymPulse (8081)
    $serverXml = "$tomcatDir\conf\server.xml"
    (Get-Content -Path $serverXml) -replace 'port="8081"', 'port="8082"' | Set-Content -Path $serverXml
    (Get-Content -Path $serverXml) -replace 'port="8080"', 'port="8082"' | Set-Content -Path $serverXml
    Write-Host "       Tomcat configured on port 8082."
} else {
    Write-Host "[1/6] Tomcat 10.1.20 already present."
}

if (-not (Test-Path $jdkDir)) {
    Write-Host "[2/6] Copying JDK 17 from GymPulse..."
    Copy-Item -Path "E:\GymPulse\tooling\jdk-17.0.10+7" -Destination $jdkDir -Recurse -Force
} else {
    Write-Host "[2/6] JDK 17 already present."
}

# ── Set Java environment ──────────────────────────────────────────
$env:JAVA_HOME = $jdkDir
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"

# ── Stop any running Tomcat on our port ───────────────────────────
Write-Host "[3/6] Stopping any existing Tomcat..."
try {
    & "$tomcatDir\bin\shutdown.bat" 2>$null | Out-Null
    Start-Sleep -Seconds 3
} catch { }

# ── Compile Java sources ─────────────────────────────────────────
Write-Host "[4/6] Compiling Java sources..."
$classesDir = "E:\SkillForge\WebContent\WEB-INF\classes"
New-Item -ItemType Directory -Force -Path $classesDir | Out-Null

$javaFiles = Get-ChildItem -Path "E:\SkillForge\src" -Filter *.java -Recurse | Select-Object -ExpandProperty FullName
$classpath = "E:\SkillForge\WebContent\WEB-INF\lib\*;$tomcatDir\lib\*"

$argsFile = "$tooling\args.txt"
$javaFiles -join "`n" | Set-Content $argsFile

& javac -cp $classpath -d $classesDir "@$argsFile"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Compilation FAILED!" -ForegroundColor Red
    exit 1
}
Write-Host "       Compilation successful." -ForegroundColor Green

# ── Deploy to Tomcat ──────────────────────────────────────────────
Write-Host "[5/6] Deploying to Tomcat..."
$webappsDest = "$tomcatDir\webapps\SkillForge"
$workDir     = "$tomcatDir\work"
$tempDir     = "$tomcatDir\temp"

# Clear caches
if (Test-Path $workDir)     { Remove-Item -Path $workDir -Recurse -Force }
if (Test-Path $tempDir)     { Remove-Item -Path $tempDir -Recurse -Force }
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

if (Test-Path $webappsDest) {
    Remove-Item -Path $webappsDest -Recurse -Force
}
New-Item -ItemType Directory -Path $webappsDest -Force | Out-Null
Copy-Item -Path "E:\SkillForge\WebContent\*" -Destination $webappsDest -Recurse -Force

# ── Start Tomcat ──────────────────────────────────────────────────
Write-Host "[6/6] Starting Tomcat..."
Start-Process -FilePath "$tomcatDir\bin\startup.bat" -WorkingDirectory "$tomcatDir\bin"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  SkillForge is deploying to:"          -ForegroundColor Cyan
Write-Host "  http://localhost:8082/SkillForge/"     -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Default login:  admin@skillforge.com / Admin@2024" -ForegroundColor Gray
Write-Host "Make sure XAMPP MySQL is running!" -ForegroundColor Gray
