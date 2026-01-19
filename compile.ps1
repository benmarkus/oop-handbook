$pygmentize = Get-Command pygmentize -ErrorAction SilentlyContinue
if (-not $pygmentize) {
    Write-Error "Pygments not found. Install with: pip install Pygments"
    exit 1
}

pdflatex -shell-escape -synctex=1 oep1.tex
pdflatex -shell-escape -synctex=1 oep1.tex

if ($LASTEXITCODE -eq 0) {
    Start-Process oep1.pdf
}