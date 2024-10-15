# Homework 7: Makefile README
### 20241014 Noah Kinscherf

This report describes the Makefile created for homework 7, using commands from the scripts for homeworks 5 (downloading a genome and simulating reads with wgsim) & 6 (downloading SRR read files, trimming, and quality checking with fastqc and multiqc).

The functions in this Makefile are described in the first target, **usage**:
```bash
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
```
To run these, the file requires the following variables to be set: **accession number (ACC), general path to the downloaded genome (GENPATH), SRR number (SRR), number (N) and length (L) of reads to sample,** file names for simulated reads to write to (W1, W2), directory name for simulated reads to write to (WDIR), file names for SRR reads to write to (R1, R2), file names for trimmed SRR reads to write to (T1, T2), and the names for directories containing SRR reads (RDIR) and reports (PDIR).

In the above, bolded variables are likely to be changed out; depending on structure of project/if otherwise well-organized, other variables could be left as-is.

The following dependencies were established:
    **simulate** requires the specified genome file to be downloaded + accessible
    **trim** requires the SRR reads to be downloaded + accessible

Makefile uploaded to Github repository at https://github.com/nakinscherf/BMMB852/blob/main/week07/Makefile
Report uploaded to Github repository at https://github.com/nakinscherf/BMMB852/blob/main/week07/hw7_README.md