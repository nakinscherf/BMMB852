#20241027 Kinscherf homework 8
#assumes installation of micromamba bioinfo conda environment and multiqc environment

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
	@echo "make index	# index genome"
	@echo "make align_SRA	# align trimmed ${SRR} reads to the reference genome"
	@echo "make align_sim	# align simulated reads to the reference genome"
	@echo "make filter_SRA	# filter ${SRR} BAM file for BMMB852 homework 9 questions"
	@echo "make SRA_mq10	# filter ${SRR} BAM file for properly-paired primary alignments with mapping quality better than 10"
	@echo "make compare	 # compare flagstats for original ${SRR} BAM file and filtered ${SRR} BAM file"
	@echo "make sim	# run all targets for downloading genome, simulating ${N} reads with wgsim, and aligning simulated reads with the reference genome"
	@echo "make SRA	# run all targets for downloading ${SRR} FASTQ files, trimming, quality checking with fastqc, aligning with the reference genome, and filtering BAM file to answer BMMB852 homework 9 questions"
	@echo "make ind_al	# run targets for indexing genome and aligning downloaded and simulated reads""
	@echo "make all	# run genome, simulate, download, trim, index, align_SRA, align_sim, and filter_SRA targets"

genome:
	# Downloading genome
	@datasets download genome accession ${ACC} --include genome
	# Unzipping genome file
	@unzip ncbi_dataset.zip
	# Creating shortcut/simplified file name
	@cd ${GENPATH}
	@ln -sf ./${GENF} ${GENOME}

simulate: ${GENPATH}/*.fna
	# Navigating to file
	@cd ${GENPATH}
	# Create directory for reads
	@mkdir -p ${WDIR}
	# Simulate FASTQ output with wgsim at 10X coverage.
	@wgsim -e 0 -r 0 -R 0 -1 ${L} -2 ${L} -N ${N} ${GENPATH}/*.fna ${W1} ${W2}

download: 
	# make necessary directories for reads and outputs
	@mkdir -p ${RDIR} ${PDIR}
	# Downloading SRR files from SRA
	@fastq-dump -X ${N} --split-files -O ${RDIR} ${SRR}
	# Running fastqc on downloaded SRR files
	@fastqc -q -o ${PDIR} ${R1} ${R2}

trim: ${R1} ${R2}
	# Trimming the reads
	@fastp --cut_right -i ${R1} -I ${R2} -o ${T1} -O ${T2}
	# Running fastqc on trimmed reads
	@fastqc -q -o ${PDIR} ${T1} ${T2}
	# Running multiqc on fastq files
	@micromamba run -n menv multiqc -o ${PDIR} ${PDIR}

index:
	# Index the genome
	@bwa index ${GENPATH}/${GENF}

align_SRA: ${R1} ${R2}
	# Align the downloaded and trimmed reads to the genome, sort the alignment files and convert to BAM format.
	@bwa mem ${GENPATH}/${GENF} ${R1} ${R2} | samtools sort > ${SRR}.bam
	# Index the BAM file from the downloaded reads.
	@samtools index ${SRR}.bam

align_sim: ${W1} ${W2}
	# Align the simulated reads to the genome, sort the alignment files and convert to BAM format.
	@bwa mem ${GENPATH}/${GENF} ${W1} ${W2} | samtools sort > sim_${ACC}.bam
	# Index the BAM file from the simulated reads.
	@samtools index sim_${ACC}.bam

filter_SRA: ${SRR}.bam
	# Filter to count reads that don't align with the reference genome.
	@echo "The number of reads that don't align with the reference genome is $$(samtools view -c -f 4 ${SRR}.bam)"
	# Filter to count primary alignments.
	@echo "The number of primary alignments is $$(samtools view -c -F 256 -F 2048 ${SRR}.bam)"
	# Filter to count secondary alignments.
	@echo "The number of secondary alignments is $$(samtools view -c -f 256 ${SRR}.bam)"
	# Filter to count supplementary alignments.
	@echo "The number of supplementary alignments is $$(samtools view -c -f 2048 ${SRR}.bam)"
	# Filter to count properly-paired alignments on the reverse strand.
	@echo "The number of properly-paired alignments on the reverse strand is $$(samtools view -c -f 2 -f 16 ${SRR}.bam)"

SRA_mq10:
	# Creation of new BAM file that contains only the properly paired primary alignments with a mapping quality of over 10.
	@samtools view -b -f 2 -F 256 -F 2048 -q 10 ${SRR}.bam > qc10.bam
	# Indexing of quality-filtered BAM file.
	@samtools index qc10.bam

compare:
	# Flagstats on original file.
	samtools flagstat ${SRR}.bam
	# Flagstats on quality-filtered file.
	samtools flagstat qc10.bam

# Run only the commands associated with simulating reads
sim: genome index simulate align_sim

# Run only the commands associated with the SRR reads
SRA: genome index download trim align_SRA filter_SRA SRA_mq10 compare

# Run only the index and align steps
ind_al: index align_SRA align_sim

all: genome simulate download trim index align_SRA align_sim filter_SRA SRA_mq10 compare

clean:
	@rm -rf ${RDIR} ${PDIR} ${GENOME} ncbi_dataset.zip ${GENOME} fastp.json fastp.html ncbi_dataset md5sum.txt simulate README.md ${GENOME}.bwt ${GENOME}.pac ${GENOME}.ann ${GENOME}.sa ${GENOME}.amb ${GENOME}.fai ${GENOME}.dict bam