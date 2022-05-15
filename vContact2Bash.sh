#bin/bash

# vcontact
# run in vContact environment

prodigal -i combined.fa -o gut_viral_genomes.genes -a gut_viral_genomes.faa -p meta
vcontact2_gene2genome -p gut_viral_genomes.faa -o gut_viral_genomes_g2g.csv -s 'Prodigal-FAA'

vcontact2 --raw-proteins gut_viral_genomes.faa --rel-mode 'Diamond' --proteins-fp gut_viral_genomes_g2g.csv --db 'None' --pcs-mode MCL --vcs-mode ClusterONE  --output-dir ./vout -v

