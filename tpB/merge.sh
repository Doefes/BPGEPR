#!/bin/sh

cd "$(dirname "$0")"

echo -n > blast_rna
echo -n > blast_prot
echo -n > nucl.bls
echo -n > prot.bls

wget "ftp://ftp.ncbi.nih.gov/genomes/Sarcophilus_harrisii/RNA/rna.fa.gz"
wget "ftp://ftp.ncbi.nih.gov/genomes/Sarcophilus_harrisii/protein/protein.fa.gz"

gunzip -f rna.fa.gz
gunzip -f protein.fa.gz

makeblastdb -dbtype nucl -in rna.fa
makeblastdb -dbtype prot -in protein.fa

awk 'BEGIN{RS=">"}{
    system("echo -e \">\""$1 $2"|blastn -db rna.fa -outfmt \"6 sacc stitle\" -max_target_seqs 1 >> nucl.bls");
    system("echo -e \">\""$1 $2"|blastx -db protein.fa -outfmt \"6 sacc stitle\" -max_target_seqs 1 >> prot.bls");
}' sequenties_groep_11.fa
