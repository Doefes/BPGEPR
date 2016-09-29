#!/bin/sh

cd "$(dirname "$0")"

echo -n > tsl

while read CODE
do
    CODE=${CODE%.*}
    wget -O- http://rest.kegg.jp/conv/shr/ncbi-proteinid:$CODE >> tsl

done < prot.bls
