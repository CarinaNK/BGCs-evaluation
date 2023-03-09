# pBGCs-evaluation
This pipeline takes a viral metagenome and analyses it for pBGCs. It also goes through clustering and predictions of hosts. The following section encompasses an installation guide for the software used in the pipeline. The installation works in any linux terminal and depends on anaconda being installed in the terminal as well. 

# AntiSMASH installation.
conda install parralel
conda create -n antismash  
conda activate antismash  
conda install hmmer2 hmmer diamond fasttree prodigal blast muscle glimmerhmm  
conda install meme==4.11.2  
conda install openjdk  
wget https://dl.secondarymetabolites.org/releases/6.0.0/antismash-6.0.0.tar.gz  
tar -zxf antismash-6.0.0.tar.gz  
pip install ./antismash-6.0.0  
download-antismash-databases  
antismash --check-prereqs  
- update or install any potentially missing prerequisites.   

# vContact2 installation.

conda activate base  
conda install -c conda-forge mamba  
mamba create --name vContact2 python=3  
mamba activate vContact2  
mamba install -y -c conda-forge hdf5 pytables pypandoc biopython networkx numpy pandas scipy scikit-learn psutil pyparsing  
 
mamba install -y -c bioconda mcl blast diamond  
wget https://bitbucket.org/MAVERICLab/vcontact2/get/master.tar.gz  
tar xvf master.tar.gz  
cd MAVERICLab-vcontact2-34ae9c466982/  
pip install .  
wget http://www.paccanarolab.org/static_content/clusterone/cluster_one-1.0.jar --no-check-certificate  
cp cluster_one-1.0.jar ~/miniconda3/envs/vContact2/bin/  
chmod 755 ~/miniconda3/envs/vContact2/bin/cluster_one-1.0.jar  

# Blast
conda install -c bioconda blast  
wget http://inphared.s3.climb.ac.uk/1Apr2022_genomes.fa
# Bigscape
conda create --name bigscape  
conda activate bigscape  
conda install numpy scipy scikit-learn  
conda install -c bioconda hmmer biopython fasttree  
conda install -c anaconda networkx  
- clone the bigscape Github: https://github.com/medema-group/BiG-SCAPE  

# How to utilise this pipeline
first, you run all the installs to ensure that your programs are working and compatible.
after this, it is recommended that you retrieve the files and upload them to your server or machine of choice.
Run the bits of script from the antismash segment first, by copying them into your servers console, 
preferably in small chunks to be able to resolve any potential errors, note that the final stage might take some time.
after this run the vcontact script in the same way
and finally the bash script
after this the results can be downloaded in whichever way you prefer from your server and the plotting code can be utilised.
