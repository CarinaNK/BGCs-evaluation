#!/bin/bash
cd ./sortedfasta
makeblastdb -in ./Apr2022_genomes.fa -dbtype nucl -input_type fasta -out phagDB

rm -r ./blastres
mkdir ./blastres
find ./ -name "*.fa" | parallel -j 12 -a - blastn -task 'dc-megablast' -db phagDB -query {} -max_target_seqs 1 -outfmt 6 -out ./blastres/{.}.txt		

 


ls ./blastres | wc -l

python ./BiG-SCAPE/bigscape.py -i ./anti_out -o ./scapeout  --pfam_dir ./ -c 10 --include_singletons 
