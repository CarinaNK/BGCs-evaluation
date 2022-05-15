#!/bin/bash

#depends on
# run in Antismash environment
# antismash
# ucsc fasplit

# clean up.

rm -r ./subfas
rm -r ./anti_out
rm -r ./resultsgbs
rm -r ./vout
rm -r ./sortedfasta
rm summary.csv
rm combined.fa
		
		
# make directories
mkdir ./subfas
mkdir ./anti_out
mkdir ./resultsgbs
mkdir ./vout
> summary.csv

#split the fasta
faSplit byname GPD_sequences.fa ./subfas/


# run antismash
find subfas/ -name "*.fa" | parallel -j 20 'antismash --minimal -c 1 --genefinding-tool prodigal  --output-dir anti_out/{/.} {}  '

# cleanup
python3 Cleanupt.py

# takes all the relevant sequence files and moves them
python3 genbankoutput.py

# creation of summary file
python3 summaryfile.py

# concatenate fasta
cd sortedfasta
cat *.fa > combined.fa
cd ~

cp /sortedfasta/combined.fa ./

		
