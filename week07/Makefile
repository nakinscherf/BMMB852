#20241014 Kinscherf homework 7
#Makefile conversion of homework 6
#assumes installation of micromamba bioinfo conda environment and multiqc environment

SHELL := bash
MAKEFLAGS += --warn-undefined-variables

# Accession number
ACC=GCF_013318015.2
# Genome file name
GENPATH=ncbi_dataset/data/${ACC}
# Simplified genome file name
GENOME=agrobact.fa
# SRR number
SRR=SRR30415233
# Number and length of reads to sample
N=300000
L=100
# File names for simulated reads to write to
W1=wreads/wgsim_read1.fq
W2=wreads/wgsim_read2.fq
# Directory name for simulated reads to write to
WDIR=wreads
# File names for SRR reads to write to
R1=reads/${SRR}_1.fastq
R2=reads/${SRR}_2.fastq
# File names for trimmed SRR reads to write to
T1=reads/${SRR}_1.trimmed.fastq
T2=reads/${SRR}_2.trimmed.fastq
# SRR reads directory
RDIR=reads
# reports directory
PDIR=reports

# Creating help target
usage:
	@echo "# ACC=${ACC}"
	@echo "# SRR=${SRR}"
	@echo "Targets in this file include:"
	@echo "make genome	# download and unzip genome file then navigate to file location"
	@echo "make simulate	# simulate reads for ${ACC} with wgsim"
	@echo "make download	# download ${SRR} FASTQ files and run fastqc"
	@echo "make trim	# trim ${SRR} FASTQ files and run fastqc and multiqc"
	@echo "make sim	# run all targets for downloading genome and simulating ${N} reads with wgsim"
	@echo "make SRA	# run all targets for downloading ${SRR} FASTQ files, trimming, and quality checking with fastqc"
	@echo "make all	# run genome, simulate, download, and trim targets"

# Downloading the genome and preparing for analysis by unzipping and navigating to file
genome:
# Downloading
	@datasets download genome accession ${ACC} --include genome
# Unzipping
	@unzip ncbi_dataset.zip
# Creating shortcut/simplified file name
	@ln -sf ./${GENF} ${GENOME}

# Simulate reads with wgsim
simulate: ${GENPATH}/*.fna
# Navigating to file
	@cd ${GENPATH}
# Create directory for reads
	@mkdir -p ${WDIR}
# Simulate FASTQ output with wgsim at 10X coverage.
	@wgsim -e 0 -r 0 -R 0 -1 ${L} -2 ${L} -N ${N} ${GENPATH}/*.fna ${W1} ${W2}

# Downloading the SRR FASTQ files & running fastqc
download: 
# make necessary directories for reads and outputs
	@mkdir -p ${RDIR} ${PDIR}
# Downloading SRR files from SRA
	@fastq-dump -X ${N} --split-files -O ${RDIR} ${SRR}
# Running fastqc on downloaded SRR files
	@fastqc -q -o ${PDIR} ${R1} ${R2}

# Trimming the reads & running fastqc
trim: ${R1} ${R2}
	@fastp --cut_right -i ${R1} -I ${R2} -o ${T1} -O ${T2}
# Running fastqc on trimmed reads
	@fastqc -q -o ${PDIR} ${T1} ${T2}
# Running multiqc on fastq files
	@micromamba run -n menv multiqc -o ${PDIR} ${PDIR}

# Run only the commands associated with simulating reads
sim: genome data simulate simdata

# Run only the commands associated with downloading and trimming existing reads
SRA: download trim

all: genome simulate download trim

