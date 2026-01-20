param([switch]$o)

$projectRoot = Split-Path -Parent $PSScriptRoot
$dockerfile = Join-Path $PSScriptRoot "Dockerfile"

Push-Location $projectRoot

$imageExists = docker images -q oep-latex 2>$null
if (-not $imageExists) {
    Write-Host "Building Docker image..."
    docker build -t oep-latex -f "$dockerfile" .
}

if (-not (Test-Path "bin")) {
    New-Item -ItemType Directory -Path "bin" | Out-Null
}

Write-Host "Image installed."
Write-Host "Compiling tex source files..."
docker run --rm -v "${projectRoot}:/doc" oep-latex pdflatex -shell-escape -synctex=1 -output-directory=bin -jobname=oop-handbook main.tex
if ($LASTEXITCODE -ne 0) {
    Write-Error "Compilation failed"
    Pop-Location
    exit 1
}

docker run --rm -v "${projectRoot}:/doc" oep-latex pdflatex -shell-escape -synctex=1 -output-directory=bin -jobname=oop-handbook main.tex

if ($LASTEXITCODE -eq 0) {
    Write-Host "Done: bin/oop-handbook.pdf"
    if ($o) { Start-Process "bin/oop-handbook.pdf" }
}

Pop-Location
