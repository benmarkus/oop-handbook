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

mkdir -p bin

echo "Image installed."
echo "Compiling tex source files..."
docker run --rm -v "$(pwd):/doc" oep-latex pdflatex -shell-escape -synctex=1 -output-directory=bin -jobname=oop-handbook main.tex
if [ $? -ne 0 ]; then
    echo "Compilation failed"
    exit 1
fi

docker run --rm -v "$(pwd):/doc" oep-latex pdflatex -shell-escape -synctex=1 -output-directory=bin -jobname=oop-handbook main.tex

echo "Done: bin/oop-handbook.pdf"
if $OPEN_PDF; then
    if command -v xdg-open &> /dev/null; then
        xdg-open bin/oop-handbook.pdf
    elif command -v open &> /dev/null; then
        open bin/oop-handbook.pdf
    fi
fi