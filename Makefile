TEX = pdflatex
FLAGS = -shell-escape -synctex=1
TARGET = oep1

all: $(TARGET).pdf

$(TARGET).pdf: $(TARGET).tex
	@command -v pygmentize >/dev/null 2>&1 || { echo "Pygments not found. Install with: pip install Pygments"; exit 1; }
	$(TEX) $(FLAGS) $(TARGET).tex
	$(TEX) $(FLAGS) $(TARGET).tex

clean:
	rm -f *.aux *.log *.out *.toc *.listing *.synctex.gz
	rm -rf _minted

.PHONY: all clean
