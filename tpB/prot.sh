#!/bin/sh

cd "$(dirname "$0")"

echo -n > blast_resultaat
echo -n > blast_resultaat_gefilterd_protein

wget "ftp://ftp.ncbi.nih.gov/genomes/Sarcophilus_harrisii/protein/protein.fa.gz"
gunzip -f protein.fa.gz

mkdir sequenties

makeblastdb -dbtype prot -in protein.fa
declare $(awk '/>/{file="sequenties/sequentie"(i++)}{print>file}END{print "amountFile="i-1}' sequenties_groep_11.fa)

echo | awk -v amountFile="$amountFile" '{
  for (i=1;i<= amountFile;i++){
    print(">test");
    system("blastx -db protein.fa -query sequenties/sequentie"i" -outfmt 6 ")
  }
}' | egrep -A 1 "test" >> blast_resultaat

awk '{print $2}' blast_resultaat | awk -F "|" '{print $4}' | tr -s "\n"> blast_resultaat_gefilterd_protein
