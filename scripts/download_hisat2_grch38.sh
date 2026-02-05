#!/usr/bin/env bash

# Download and extract HISAT2 GRCh38 genome index

wget -c https://genome-idx.s3.amazonaws.com/hisat/grch38_genome.tar.gz
tar -xvzf grch38_genome.tar.gz
ls -lh grch38_genome.tar.gz
ls grch38
