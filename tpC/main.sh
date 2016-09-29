#!/bin/sh

cd "$(dirname "$0")"

echo -n > _KeggIDs
echo -n > _PWs

while read CODE
do
  CODE=${CODE%.*}
  wget -O- http://rest.kegg.jp/conv/shr/ncbi-proteinid:$CODE >> _KeggIDs

done < prot.bls

while read KeggID
do
  KeggID=$(echo $KeggID | awk '{print $2}')
  wget -O- http://rest.kegg.jp/link/pathway/$KeggID >> _PWs

done < _KeggIDs

sort -k2 -o _PWs _PWs
