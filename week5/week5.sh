# 20240930 Kinscherf week 5 homework
#Script must be run in micromamba "bioinfo" conda environment. Requires NCBI command-line tools.

# 1- Script to download a genome FASTA file and report:
# Size of file, total size of genome, number of chromosomes, length and ID of each chromosome.

# 2- Generate a simulated FASTQ output with 10X coverage and report:
# Number of reads generated, average read length, size of FASTQ files, compress the files, and find how much space compression saves.

# Setting error handling and trace.
# Trace required to see information fetched.
set -uex

# Defining my variables that will need to be manually changed.
# using Agrobacterium tumefaciens as organism of choice
# NCBI accession no. GCF_013318015.2
GCF=GCF_013318015.2

# Genome file name.
GENF=GCF_013318015.2_ASM1331801v2_genomic.fna

# Simplified name of genome file.
GENOME=agrobact.fa

# Number of reads (paired-end sequencing)
N=300000

# Length of reads
L=100

# Files to write the reads to
R1=reads/wgsim_read1.fq
R2=reads/wgsim_read2.fq

###DO NOT CHANGE SCRIPT BELOW THIS LINE###

# Download genome.
datasets download genome accession ${GCF} --include genome

# Unpack the data.
unzip ncbi_dataset.zip

# Move to the directory with the genome.
cd ./ncbi_dataset/data/${GCF}/

# Find the size of the file.
ls -l

# Link to the genome file with a simpler name.
ln -sf ./${GENF} ${GENOME}

# Find genome length and number of chromosomes/contigs.
seqkit stats ${GENOME}

# Find chromosome ID and length; also double-checks number of chromosomes.
seqkit fx2tab -n -l ${GENOME}

# Make a directory for FASTQ simulation.
mkdir -p $(dirname ${R1})

# Simulate FASTQ output with wgsim at 10X coverage.
wgsim -e 0 -r 0 -R 0 -1 ${L} -2 ${L} -N ${N} ${GENOME} ${R1} ${R2}

# Check stats on simulated FASTQ reads.
seqkit stats ${R1} ${R2}

# List files longhand to check file size of simulated FASTQ reads.
ls -lh $(dirname ${R1})

# Compress simulated FASTQ reads, overwriting existing files of same name.

gzip -f ${R1} ${R2}

# List files longhand to check compressed file sizes.

ls -lh $(dirname ${R1})