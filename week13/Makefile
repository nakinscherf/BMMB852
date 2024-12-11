# 20241201 Kinscherf BMMB852 Homework 12
#assumes installation of micromamba bioinfo environment, micromamba vep environment, and bio code bioinformatics toolbox

# Shell defaults
SHELL = bash
.ONESHELL:
.SHELLFLAGS = -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# Accession number
ACC=GCF_013318015.2
# Genome file name
GENF=GCF_013318015.2_ASM1331801v2_genomic.fna
# Path to genome file
GENPATH=ncbi_dataset/data/${ACC}
# Reference genome
REF=${GENPATH}/${GENF}
# SRR number
SRR=SRR30539278
# Name of the sample (see bio search SRR10999774)
SAMPLE=pssA_67_1
# Name of GFF file
GFF=refs/agrobacterium_tumefaciens.gff
# Number of reads to sample
N=300000
# File names for SRR reads to write to
R1=reads/${SRR}_1.fastq
R2=reads/${SRR}_2.fastq
# SRR reads directory
RDIR=reads
# Name for BAM file
BAM=${SAMPLE}.bam

# Creating help target
usage:
	@echo "# ACC=${ACC}"
	@echo "# SRR=${SRR}"
	@echo "Targets in this file include:"
	@echo "make genome	# download and unzip genome and GFF files"
	@echo "make index	# index genome and GFF files"
	@echo "make reads	# download ${SRR} FASTQ files and run fastqc"
	@echo "make align	# align trimmed ${SRR} reads to the reference genome"
	@echo "make count	# create a count matrix from BAM files currently in the folder"
	@echo "make all	# run genome, index, reads, align, and counts targets"

genome:
	mkdir -p refs
	@# Downloading genome
	datasets download genome accession ${ACC} --include genome,gff3
	# Unzipping genome file
	unzip ncbi_dataset.zip
	# Moving the GFF file
	mv ncbi_dataset/data/${ACC}/genomic.gff ${GFF}

index: ${REF}
	@# Index the genome
	hisat2-build ${REF} ${REF}-index

reads: 
	@# make necessary directories for reads
	mkdir -p ${RDIR}
	# Downloading SRR files from SRA database
	fastq-dump -X ${N} --split-files -O ${RDIR} ${SRR}

align: ${R1} ${R2}
	@# Align the downloaded reads to the genome, sort the alignment files and convert to BAM format.
	hisat2 -x ${REF}-index -1 ${R1} -2 ${R2} | samtools sort > ${BAM}
	# Index the BAM file from the downloaded reads.
	samtools index ${BAM}

count:
	@# To more easily visualize alignments in IGV, compile all current BAM files in the folder into one file, then index merged file
	#samtools merge -o merged_reads.bam *.bam
	#samtools index merged_reads.bam
	# Create a count matrix from all current BAM files
	featureCounts -a ${GFF} -t gene -g ID -o matrix.txt *.bam

all: genome index reads align count

clean:
	rm -rf ${RDIR} refs md5sum.txt ncbi_dataset.zip ncbi_dataset README.md *.bam.bai

.PHONY: usage clean
