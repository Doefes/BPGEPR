#!/bin/sh -

organisms="equus_caballus"
# organisms="equus_caballus loxodonta_africana cavia_porcellus felis_catus meleagris_gallopavo"

for i in $organisms; do
    mkdir $i
    touch $i/.gitignore
    # -r recursive
    # -P directory Prefix
    # -nd no directories
    # -A accept list
    wget -r -P $i/ -nd -A '*all.fa.gz' ftp://ftp.ensembl.org/pub/release-85/fasta/$i/pep/
done
