#!/bin/sh

cd "$(dirname "$0")"

blastn -db nr -query sequenties/sequentie1 -remote -out result.bls -outfmt "6 stitle" -max_target_seqs 1
