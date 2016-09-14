#!/bin/sh
# Blast version 2.4.0+

echo -n > E0.txt
echo -n > multi.fa

declare -A organisms
organisms=(["EquCab"]="equus_caballus"
            ["LoxAfr"]="loxodonta_africana"
            ["CavPor"]="cavia_porcellus"
            ["FelCat"]="felis_catus"
            ["MelGal"]="meleagris_gallopavo" )

# wget "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=protein&id=CAA37914&rettype=fasta&retmode=text" -O "CAA37914.fa"

for i in ${!organisms[@]}; do

    orgName=${organisms[${i}]}
    orgCode=${i}

    mkdir $orgName
    touch $orgName/.gitignore

    # -r recursive | -P directory Prefix | -nd no directories | -A accept list
    wget -r -P $orgName/ -nd -A '*all.fa.gz' ftp://ftp.ensembl.org/pub/release-85/fasta/$orgName/pep/
    gunzip $orgName/*.gz
    mv $orgName/*all.fa $orgName/$orgCode.fa

    makeblastdb -in $orgName/$orgCode.fa -dbtype prot
    blastp -query CAA37914.fa -db $orgName/$orgCode.fa -out $orgName/out_$orgCode.txt
    blastp -query CAA37914.fa -db $orgName/$orgCode.fa -out $orgName/tab_$orgCode.txt -outfmt 6

    awk '{if($11 == 0.0){print $2;}}' $orgName/tab_$orgCode.txt >> E0.txt
    awk '{if(substr($1,1,1) == ">") print $1"@"; else print $0}' $orgName/$orgCode.fa | tr -d "\n" | sed 's/>/\n>/g'| egrep -f E0.txt | tr "@" "\n" >> multi.fa

done

awk '{if (substr($1,1,1)==">") print ">"substr($1,15,10)"@"; else print $0}' CAA37914.fa | tr -d "\n" | tr "@" "\n" >> multi.fa
