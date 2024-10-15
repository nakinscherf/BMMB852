#20240921 Homework 4 Kinscherf
#Shell script to pull a .gff3 file-type genome from Ensembl and count feature types.
#Counts sequence regions; top 10 most-annotated feature types; unique feature types; annotated genes; total features.

#Setting error handling and trace.
set -ux

#Defining my variables that will need to be manually changed.
#Variables are to make directory and associate files with each other;
GROUP="hw4"

#Pull the genome from Ensembl (for this script, URL must fetch a .gff3 file);
URL="https://ftp.ensembl.org/pub/current_gff3/ursus_maritimus/Ursus_maritimus.UrsMar_1.0.112.gff3.gz"

#And manipulate the file fetched and unzipped from Ensembl.
GENOME="Ursus_maritimus.UrsMar_1.0.112.gff3"

###DO NOT EDIT BELOW THIS LINE###

#Creating a directory for the analysis.
mkdir ${GROUP}
cd ${GROUP}

#Fetching emsembl .gff3 file if it doesn't already exist.
if [ ! -f ${GENOME} ]; then
    wget ${URL} -O ${GENOME}.gz
fi

#Unzipping the file and keeping the original.
gunzip -k ${GENOME}.gz

#Calculating number of sequence regions; theoretically, number of chromosomes.
#Could also be scaffolds and contigs.
SEQREG=$(cat ${GENOME} | grep "^##sequence-region" | sort-uniq-count-rank | wc -l)

#Making output more visible.
echo "The number of sequence regions is ${SEQREG}"

#Identifying the top 10 most annotated genome feature types for this genome assembly.
#First, creating a file with only genome feature types from the genome being analyzed.
cat ${GENOME} | cut -f 3 > types_${GROUP}.txt

#Removing all non-feature items extracted with column 3 by filtering out any "features" that start with "#"
cat types_${GROUP}.txt | grep -v "^#" > filtered_${GROUP}.txt

#Using the genome feature types file to identify each unique feature type, get a count for occurrences for each feature type, and then rank the features by those counts.
#Command should print top 10 feature types.
cat filtered_${GROUP}.txt | sort-uniq-count-rank | head

#Counting total number of unique genomic feature types in this assembly.
GENF=$(cat filtered_${GROUP}.txt | sort | uniq -c | sort -rn | wc -l)

#Making output more visible.
echo "The number of unique genomic feature types in is ${GENF}" 

#Singling out the gene count specifically.
GENE=$(cat filtered_${GROUP}.txt | awk '$1 == "gene"' | wc -l)

#Making output more visible.
echo "The number of features of type gene in this assembly is ${GENE}"

#Adding up the feature counts to find the total number of described features.
FEATURES=$(cat filtered_${GROUP}.txt | wc -l)

#Making output more visible.
echo "The number of features in the document is ${FEATURES}"
