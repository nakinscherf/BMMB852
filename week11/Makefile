# 20241117 Kinscherf BMMB852 Homework 11
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
# SRR number
SRR=SRR30415233
# Name of the sample (see bio search SRR30415233)
SAMPLE=EML171
# Name of GFF file
GFF=refs/agrobacterium_tumefaciens.gff
# Number of reads to sample
N=300000
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
# Name for BAM file
BAM=${SAMPLE}.bam
# Resulting compressed variant VCF file
VCF ?= vcf/$(notdir $(basename ${BAM})).vcf.gz
# Additional bcf flags for pileup annotation.
PILE_FLAGS =  -d 100 --annotate 'INFO/AD,FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/SP'
# Additional bcf flags for calling process.
CALL_FLAGS = --ploidy 2 --annotate 'FORMAT/GQ'

# Creating help target
usage:
	@echo "# ACC=${ACC}"
	@echo "# SRR=${SRR}"
	@echo "Targets in this file include:"
	@echo "make genome	# download and unzip genome file then navigate to file location"
	@echo "make index	# index genome"
	@echo "make download	# download ${SRR} FASTQ files and run fastqc"
	@echo "make trim	# trim ${SRR} FASTQ files and run fastqc and multiqc"
	@echo "make align	# align trimmed ${SRR} reads to the reference genome"
	@echo "make vcf	# call variants in ${BAM} compared to the reference genome"
	@echo "make index_vcf	# index variant calling file generated from ${BAM}"
	@echo "make vep	# predict variant effects using vep environment"
	@echo "make all	# run genome, download, trim, index, align, vcf, index_vcf, vep targets"

genome:
	mkdir -p refs
	@# Downloading genome
	@datasets download genome accession ${ACC} --include genome,gff3
	# Unzipping genome file
	@unzip ncbi_dataset.zip
	# Moving the GFF file
	mv ncbi_dataset/data/${ACC}/genomic.gff ${GFF}

index:
	@# Index the genome
	@bwa index ${GENPATH}/${GENF}

download: 
	@# make necessary directories for reads and outputs
	@mkdir -p ${RDIR} ${PDIR}
	# Downloading SRR files from SRA
	@fastq-dump -X ${N} --split-files -O ${RDIR} ${SRR}
	# Running fastqc on downloaded SRR files
	@fastqc -q -o ${PDIR} ${R1} ${R2}

trim: ${R1} ${R2}
	@# Trimming the reads
	@fastp --cut_right -i ${R1} -I ${R2} -o ${T1} -O ${T2}

align: ${T1} ${T2}
	@# Align the downloaded and trimmed reads to the genome, sort the alignment files and convert to BAM format.
	@bwa mem ${GENPATH}/${GENF} ${T1} ${T2} | samtools sort > ${BAM}
	# Index the BAM file from the downloaded reads.
	@samtools index ${BAM}

vcf: ${BAM}
	@# Use bcftools to call variants in ${BAM} and report those in a VCF file
	@mkdir -p vcf
	@bcftools mpileup ${PILE_FLAGS} -O u -f ${GENPATH}/${GENF} ${BAM} | \
		bcftools call ${CALL_FLAGS} -mv -O u | \
		bcftools norm -f ${GENPATH}/${GENF} -d all -O u | \
		bcftools sort -O z > ${VCF}

index_vcf: ${VCF}
	@# Index the VCF file
	@bcftools index -t -f ${VCF}

vep: ${VCF}
	@# Sort and compress the GFF file
	@cat ${GFF} | sort -k1,1 -k4,4n -k5,5n -t$$'\t' | bgzip -c > ${GFF}.gz
	# Index the GFF file
	@tabix -p gff ${GFF}.gz
	# Run variant effect predictions in vep environment
	@mkdir -p results
	@micromamba run -n vep \
		~/src/ensembl-vep/vep \
		-i ${VCF} \
		-o results/vep.txt \
		--gff ${GFF}.gz \
		--fasta ${GENPATH}/${GENF} \
		--force_overwrite
	# Show resulting files
	@ls -lh results*

all: genome index download trim align vcf index_vcf vep

clean:
	@rm -rf ${RDIR} ${PDIR} ncbi_dataset.zip ${GENPATH}/${GENF} fastp.json fastp.html ncbi_dataset md5sum.txt simulate README.md ${GENPATH}/${GENF}.bwt ${GENPATH}/${GENF}.pac ${GENPATH}/${GENF}.ann ${GENPATH}/${GENF}.sa ${GENPATH}/${GENF}.amb ${GENPATH}/${GENF}.fai ${GENPATH}/${GENF}.dict 