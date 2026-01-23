FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-latex-recommended \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-pictures \
    lmodern \
    python3-pygments \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /doc
