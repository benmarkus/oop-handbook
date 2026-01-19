param([switch]$o)

$projectRoot = Split-Path -Parent $PSScriptRoot
$dockerfile = Join-Path $PSScriptRoot "Dockerfile"

Push-Location $projectRoot

$imageExists = docker images -q oep-latex 2>$null
if (-not $imageExists) {
    Write-Host "Building Docker image..."
    docker build -t oep-latex -f "$dockerfile" .
}

Write-Host "Image installed."
Write-Host "Compiling tex source files..."
docker run --rm -v "${projectRoot}:/doc" oep-latex pdflatex -shell-escape -synctex=1 oep1.tex
docker run --rm -v "${projectRoot}:/doc" oep-latex pdflatex -shell-escape -synctex=1 oep1.tex

if ($LASTEXITCODE -eq 0) {
    Write-Host "Done: oep1.pdf"
    if ($o) { Start-Process oep1.pdf }
}

Pop-Location
