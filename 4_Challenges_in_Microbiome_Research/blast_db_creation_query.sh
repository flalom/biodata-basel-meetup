## This file comes as the third part of the "Challenges in Microbiome Research" tutorial, and contains the code to create a custom BLAST database from the collection isolates fasta file, and to query that database with the ASV fasta file.
## Install BLAST+
#sudo apt install -y ncbi-blast+
## --> User manual there: https://www.animalgenome.org/bioinfo/resources/manuals/blast2.2.24/user_manual.pdf


## Verify the installation
blastn -version
makeblastdb -version

## Change directory
cd 4_Challenges_in_Microbiome_Research/

## Check that the ASV fasta file can be read properly
head -4 data/all_ASV.fasta

## Check that the collection isolates fasta can be read properly
head -4 data/collection_isolates.fasta

## Create directory to contain our BLAST database
mkdir -p custom_blast_db

## Create a BLAST database from the collection isolates fasta file
makeblastdb -in data/collection_isolates.fasta \
-dbtype nucl \
-out custom_blast_db/custom_16S_db \
-title "strain_collection_16S_db"

## Find which strains correspond to differentially abundant ASVs with a BLAST search
## DO NOT RUN IT'S TOO LONG FOR THE PRESENTATION (you can try it on your computer though)
blastn -query data/all_ASV.fasta \
    -db custom_blast_db/custom_16S_db \
    -out data/ASV_isolates_alignment_notitle.csv \
    -outfmt "10 qaccver saccver stitle pident length mismatch gapopen qstart qend sstart send" \
    -perc_identity 99.75 ## With 400bp, this allows for 1 mismatch and no gaps

## Instead run this
cp save_me/ASV_isolates_alignment_notitle.csv data/ASV_isolates_alignment_notitle.csv

# The table does not have a header. We add it.
echo "qaccver,saccver,stitle,pident,length,mismatch,gapopen,qstart,qend,sstart,send" \
  | cat - data/ASV_isolates_alignment_notitle.csv \
  > data/ASV_isolates_alignment.csv
