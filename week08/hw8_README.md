# Homework 8: Makefile README
### 20241020 Noah Kinscherf

This report describes the Makefile created for homework 8, using commands from the scripts for homeworks 5 (downloading a genome and simulating reads with wgsim) & 6 (downloading SRR read files, trimming, and quality checking with fastqc and multiqc).

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
	@echo "make index	# index genome"
	@echo "make align_SRA	# align trimmed ${SRR} reads to the reference genome"
	@echo "make align_sim	# align simulated reads to the reference genome"
	@echo "make sim	# run all targets for downloading genome and simulating ${N} reads with wgsim"
	@echo "make SRA	# run all targets for downloading ${SRR} FASTQ files, trimming, and quality checking with fastqc"
	@echo "make ind_al	# run targets for indexing genome and aligning downloaded and simulated reads"
	@echo "make all	# run genome, simulate, download, trim, index, align_SRA, and align_sim targets"
```
To run these, the file requires the following variables to be set: **accession number (ACC), general path to the downloaded genome (GENPATH), SRR number (SRR), number (N) and length (L) of reads to sample,** file names for simulated reads to write to (W1, W2), directory name for simulated reads to write to (WDIR), file names for SRR reads to write to (R1, R2), file names for trimmed SRR reads to write to (T1, T2), and the names for directories containing SRR reads (RDIR) and reports (PDIR).

In the above, bolded variables are likely to be changed out; depending on structure of project/if otherwise well-organized, other variables could be left as-is.

The following dependencies were established:
    **simulate** requires the specified genome file to be downloaded + accessible
    **trim** requires the SRR reads to be downloaded + accessible
    **align_SRA** requires the SRR reads to be downloaded + accessible
    **align_sim** requires the simulated read files to exist

Makefile uploaded to Github repository at https://github.com/nakinscherf/BMMB852/blob/main/week08/Makefile
README uploaded to Github repository at https://github.com/nakinscherf/BMMB852/blob/main/week08/hw8_README.md

Resulting BAM files were visualized with IGV.

The simulated reads appeared as such:
![hw8_sim.png](https://github.com/nakinscherf/BMMB852/blob/main/week08/hw8_sim.png)
These reads, which were simulated with no errors, align very cleanly with the reference genome. The directionality of the reads is clear.

By contrast, the downloaded reads appeared as such:
![hw8_trim.png](https://github.com/nakinscherf/BMMB852/blob/main/week08/hw8_trim.png)
I tested both trimmed and untrimmed data for the alignment; by eye, at this magnification, there was no difference in the quality of the alignment. The scrappy alignment and plethora of mismatches confirm my previous assessment in week 6 that these reads are not very good. I have to wonder if these reads were of use to the researchers who generated them, and if so, how they were processed to become viable.
