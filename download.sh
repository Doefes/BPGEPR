<<<<<<< HEAD
#!/bin/bash
# Blast version 2.2.25+
# ClustalW version 2.1
=======
#!/bin/sh
# Blast version 2.2.25+
>>>>>>> 89c4acac7c85b8b255b9538a0f76d21206dd61f1

echo -n > E0.txt
echo -n > multi.fa
echo -n > multi2.fa

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

    # -r recursive | -P directory Prefix | -nd no directories | -A accept list
    wget -r -P $orgName/ -nd -A '*all.fa.gz' ftp://ftp.ensembl.org/pub/release-85/fasta/$orgName/pep/
    gunzip $orgName/*.gz
    mv $orgName/*all.fa $orgName/$orgCode.fa

    formatdb -i $orgName/$orgCode.fa -p T
    blastall -i CAA37914.fa -d $orgName/$orgCode.fa -o $orgName/out_$orgCode.txt -p blastp
    blastall -i CAA37914.fa -d $orgName/$orgCode.fa -o $orgName/tab_$orgCode.txt -p blastp -m8

    awk '{if($11 == 0.0){print $2;}}' $orgName/tab_$orgCode.txt >> E0.txt
    awk '{if(substr($1,1,1) == ">") print $1"@"; else print $0}' $orgName/$orgCode.fa | tr -d "\n" | sed 's/>/\n>/g'| egrep -f E0.txt | tr "@" "\n" >> multi.fa

done

awk '{if (substr($1,1,1)==">") print ">"substr($1,15,10)"@"; else print $0}' CAA37914.fa | tr -d "\n" | tr "@" "\n" >> multi.fa


clustalw -align -infile=multi.fa
clustalw -bootstrap=990 -infile=multi.aln

awk '{if (substr($1,1,1) == ">"){if(length($1) > 11) {part1 = substr($1,5,4);part2 = substr($1,14,6);$1 = ">"part1 part2;}print $1;} else {print $1;}}' multi.fa > multi2.fa

clustalw -align -infile=multi2.fa
clustalw -bootstrap=990 -infile=multi2.aln

# Boom bekijken http://www.phylogeny.fr/
# Welk eiwit meest gerelateerd aan sequentie
# http://www.phylogeny.fr/one_task.cgi?task_type=treedyn&workflow_id=7a83f04343d0b7a499ecde716749581d&tab_index=3
