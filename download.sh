#!/bin/sh

declare -A organisms

# organisms=(["EquCab"]="equus_caballus" ["LoxAfr"]="loxodonta_africana" ["CavPor"]="cavia_porcellus" ["FelCat"]="felis_catus" ["MelGal"]="meleagris_gallopavo" )
organisms=(["EquCab"]="equus_caballus")

for i in ${!organisms[@]}; do

    orgName=${organisms[${i}]}
    orgCode=${i}

    mkdir $orgName
    touch $orgName/.gitignore

    # -r recursive | -P directory Prefix | -nd no directories | -A accept list
    wget -r -P $orgName/ -nd -A '*all.fa.gz' ftp://ftp.ensembl.org/pub/release-85/fasta/$orgName/pep/
    gunzip $orgName/*.gz
    mv $orgName/*all.fa $orgName/$orgCode.fa
    

done
