#!/bin/bash

#depends on
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
conda activate antismash
faSplit byname GPD_sequences.fa ./subfas/


# run antismash
find subfas/ -name "*.fa" | parallel -j 20 'antismash --minimal -c 1 --genefinding-tool prodigal  --output-dir anti_out/{/.} {}  '

# cleanup
python3 pythonattempt.py

# takes all the relevant sequence files and moves them
python3 genbankoutput.py

# creation of summary file
python3 summaryfile.py

# concatenate fasta
cd sortedfasta
cat *.fa > combined.fa
cd ~

cp /sortedfasta/combined.fa ./
conda deactivate

# vcontact
conda activate vContact2
prodigal -i combined.fa -o gut_viral_genomes.genes -a gut_viral_genomes.faa -p meta
vcontact2_gene2genome -p gut_viral_genomes.faa -o gut_viral_genomes_g2g.csv -s 'Prodigal-FAA'

vcontact2 --raw-proteins gut_viral_genomes.faa --rel-mode 'Diamond' --proteins-fp gut_viral_genomes_g2g.csv --db 'None' --pcs-mode MCL --vcs-mode ClusterONE  --output-dir ./vout -v
conda deactivate

		