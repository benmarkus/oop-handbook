#!/bin/bash

OPEN_PDF=false
ONCE=false
while getopts "o1" opt; do
    case $opt in
        o) OPEN_PDF=true ;;
        1) ONCE=true ;;
    esac
done

if [[ -z $(docker images -q oep-latex 2>/dev/null) ]]; then
    echo "Building Docker image..."
    docker build -t oep-latex -f docker/Dockerfile .
fi

mkdir -p bin

echo "Image installed."
echo "Compiling tex source files..."
docker run --rm -v "$(pwd):/doc" oep-latex pdflatex -shell-escape -synctex=1 -output-directory=bin -jobname=oop-handbook main.tex
if [ $? -ne 0 ]; then
    echo "Compilation failed"
    exit 1
fi

if [ "$ONCE" = false ]; then
    docker run --rm -v "$(pwd):/doc" oep-latex pdflatex -shell-escape -synctex=1 -output-directory=bin -jobname=oop-handbook main.tex
fi

echo "Done: bin/oop-handbook.pdf"
if $OPEN_PDF; then
    if command -v xdg-open &> /dev/null; then
        xdg-open bin/oop-handbook.pdf
    elif command -v open &> /dev/null; then
        open bin/oop-handbook.pdf
    fi
fi