#!/bin/bash

OPEN_PDF=false
while getopts "o" opt; do
    case $opt in
        o) OPEN_PDF=true ;;
    esac
done

if [[ -z $(docker images -q oep-latex 2>/dev/null) ]]; then
    echo "Building Docker image..."
    docker build -t oep-latex -f docker/Dockerfile .
fi

echo "Image installed."
echo "Compiling tex source files..."
docker run --rm -v "$(pwd):/doc" oep-latex pdflatex -shell-escape -synctex=1 oep1.tex
docker run --rm -v "$(pwd):/doc" oep-latex pdflatex -shell-escape -synctex=1 oep1.tex

echo "Done: oep1.pdf"
if $OPEN_PDF; then
    if command -v xdg-open &> /dev/null; then
        xdg-open oep1.pdf
    elif command -v open &> /dev/null; then
        open oep1.pdf
    fi
fi
