TEX = pdflatex
FLAGS = -shell-escape -synctex=1 -output-directory=bin
SOURCE = main
OUTPUT = oop-handbook
OUTDIR = bin

all: $(OUTDIR)/$(OUTPUT).pdf

$(OUTDIR)/$(OUTPUT).pdf: $(SOURCE).tex | $(OUTDIR)
	@command -v pygmentize >/dev/null 2>&1 || { echo "Pygments not found. Install with: pip install Pygments"; exit 1; }
	$(TEX) $(FLAGS) -jobname=$(OUTPUT) $(SOURCE).tex && $(TEX) $(FLAGS) -jobname=$(OUTPUT) $(SOURCE).tex

$(OUTDIR):
	mkdir -p $(OUTDIR)

clean:
	rm -rf $(OUTDIR)

.PHONY: all clean
