# BMMB852 Homework 12
### 20241201 Kinscherf

## Using the Makefile
### Required installations:
micromamba bioinfo environment and micromamba vep environment

### Makefile information
This Makefile contains targets to download and index the reference genome of an organism, download sequence data from a project using the organism, trim and align the data to create a BAM file, index the BAM file, then call variants from the BAM file. 

The functions in this Makefile are described in the first target, **usage**:
```bash
usage:
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
```

To run these, the file requires the following variables to be set: **accession number (ACC), general path to the downloaded genome (GENPATH), the genome file name (GENF), SRR number (SRR), GFF file name (GFF) number (N) of reads to sample,** file names for SRR reads to write to (R1, R2), file names for trimmed SRR reads to write to (T1, T2), names for directories containing SRR reads (RDIR) and reports (PDIR), the name of the BAM file that will be produced (BAM), the name of the compressed VCF file that will be produced, and flags for the variant calling process (PILE_FLAGS, CALL_FLAGS).

The Makefile was uploaded at https://github.com/nakinscherf/BMMB852/blob/main/week12/Makefile

### Automating the pipeline
To automatically process many samples with this pipeline, create a comma separated values file containing matched SRR accessions and sample names (here indicated as automation.csv). Using this CSV file, the following command will run all Makefile targets on the provided samples:
```bash
cat automation.csv | parallel --colsep , --header : make all SRR={Run} SAMPLE={Name}
```
### Default Makefile state
The Makefile variables for the uploaded file are currently set to align reads to the *Agrobacterium tumefaciens* genome. If aligning to another genome, the variables ACC, GENPATH, GENF, and GFF will need to be corrected in the Makefile or provided in the automation command.

## Assignment 12

The CSV file automation.csv used for this assignment was uploaded to https://github.com/nakinscherf/BMMB852/blob/main/week12/automation.csv

This report was uploaded to https://github.com/nakinscherf/BMMB852/blob/main/week12/README_hw12.md