# BMMB852 Homework 13
### 20241208 Kinscherf

## Using the Makefile
### Required installations:
micromamba bioinfo environment and micromamba vep environment

### Makefile information
This Makefile contains targets to download the reference genome and gff3 files for an organism, index the reference, download RNA-seq data from a project using the organism, align the data to the reference genome to create a BAM file, index the BAM file, merge and index all alignment files, and produce a count matrix from the merged alignment file.

The functions in this Makefile are described in the first target, **usage**:
```bash
usage:
	@echo "Targets in this file include:"
	@echo "make genome	# download and unzip genome and GFF files"
	@echo "make index	# index genome and GFF files"
	@echo "make reads	# download ${SRR} FASTQ files"
	@echo "make align	# align trimmed ${SRR} reads to the reference genome"
	@echo "make counts	# create a count matrix from BAM files currently in the folder"
	@echo "make RNASeq	# run the reads and align targets"
	@echo "make all	# run genome, index, reads, align, and counts targets"
```

To run these, the file requires the following variables to be set: **accession number (ACC),** general path to the downloaded genome (GENPATH), **the genome file name (GENF), SRR number (SRR), GFF file name (GFF), sample name (SAMPLE), number (N) of reads to sample,** the path to the reference genome (REF), file names for SRR reads to write to (R1, R2), name for the directory containing SRR reads (RDIR), and the name of the BAM file that will be produced (BAM).

Variables **bolded** above are those likely to need changing. Remaining variables are generic to the pipeline and in many cases can be left alone.

The Makefile was uploaded at https://github.com/nakinscherf/BMMB852/blob/main/week13/Makefile

### Automating the pipeline
Since the genome and GFF files only needs to be downloaded and the genome indexed once, this should be done first using ```make genome index```.

To automatically process many samples with this pipeline, create a comma separated values file containing matched SRR accessions and sample names (here indicated as automation.csv). Using this CSV file, the following command will run all Makefile targets on the provided samples:
```bash
cat automation.csv | parallel --colsep , --header : make all SRR={Run} SAMPLE={Name}
```
After alignment has run for all samples, the resulting BAM files should be merged and reads counted with ```make count```.
### Default Makefile state
The Makefile variables for the uploaded file are **currently set to align reads to the *Agrobacterium tumefaciens* genome. If aligning to another genome, the variables ACC, GENF, and GFF will need to be corrected** in the Makefile or provided in the automation command.

## Assignment 13

I tested my pipeline using a set of samples from an RNA-seq project looking at the transcriptome of *Agrobacterium fabrum* strain C58, which appears to be another taxonimic name for *A. tumefaciens* strain C58 (PRJNA1155898). Out of 18 accessions, I chose 3 samples indicated to be WT, and 3 samples of the pssA variants. In a folder containing my Makefile design file PRJNA1155898.csv (uploaded at https://github.com/nakinscherf/BMMB852/blob/main/week13/PRJNA1155898.csv), I ran the following commands to produce a count matrix:

```bash
make genome index
cat PRJNA1155898.csv | parallel --colsep , --header : make reads SRR={Run} SAMPLE={Sample}
cat PRJNA1155898.csv | parallel --colsep , --header : make align SRR={Run} SAMPLE={Sample}
make count
```

I initially struggled with producing a parsable count matrix, although I could see reads mapped to genes on IGV and the RNA-seq alignments seemed to be in order. 

![igv.png](https://github.com/nakinscherf/BMMB852/blob/main/week13/igv_hw13.png)
![igv2.png](https://github.com/nakinscherf/BMMB852/blob/main/week13/igv2_hw13.png)
[igv3.png](https://github.com/nakinscherf/BMMB852/blob/main/week13/igv3_hw13.png)

There was an issue with gene identification that was creating non-separated strings of chromosome IDs and numbers. After reading the manual for featureCounts, it became evident that I needed to specify the string associated with the gene ID in gff3 column 9, because the default wasn't finding the appropriate information in the gff3 file for *A. tumefaciens*. On the recommendation of another student in my lab who is more experienced in bioinformatics, I also used a flag to assign counts to features labeled as genes, rather than the default of exons. Changing my command from ```featureCounts -a ${GFF} -o matrix.txt *.bam``` to ```featureCounts -a ${GFF} -t gene -g ID -o matrix.txt *.bam``` gave me a readable count matrix. I suspect there was a similar issue calling for the gene ID in other assignments I've done this semester.

Looking at the count matrix by eye, I found the following genes to have relatively consistent counts across all samples or within either the WT or variant group, or some other consistent pattern: 
| ID | Gene name | WT_55_3 | WT_67_1 | WT_79_1 | pssA_55_2 | pssA_67_1 | pssA_79_2 |
| -- | --------- | ------- | ------- | ------- | --------- | --------- | --------- |
| gene-G6L97_RS00490 | pstB | 14 | 15 | 24 | 15 | 24 | 16 |
| gene-G6L97_RS01790 | Unnamed | 228 | 302 | 433 | 185 | 204 | 204 | 152 |
| gene-G6L97_RS01795 | Unnamed | 123 | 184 | 72 | 76 | 61 | 68 |
| gene-G6L97_RS02400 | Unnamed | 31 | 17 | 26 | 17 | 12 | 23 |
| gene-G6L97_RS02570 | Unnamed | 135 | 121 | 86 | 123 | 139 | 62 |
| gene-G6L97_RS03450 | Unnamed | 49 | 17 | 743 | 27 | 53 | 1412 |
| gene-G6L97_RS04640 | clpX | 297 | 302 | 1451 | 333 | 381 | 1129 |
| gene-G6L97_RS04650 | hupB | 681 | 942 | 1371 | 306 | 1056 | 1162 |
| gene-G6L97_RS04735 | nuoI | 32 | 48 | 25 | 26 | 40 | 31 |

I was intrigued to note that the WT and pssA samples with the same numeral tended to follow roughly the same trend in number of reads compared to the other samples within their group. This was especially prominent with WT_79 and pssA_79. This implies to me that the number indicates batches or groups of samples that were processed at the same time.

At a very rough glance, there didn't appear to be many genes for which all of the WT counts and all of the pssA counts appeared to be consistent. If my hypothesis above that these are different technical replicates is correct, that would be a large contributing factor to the inconsistency. I suspect that if I selected my accessions from the project with more care to the groups, I could have much more consistent outcomes. For example, WT_55_3 and pssA_55_2 are very likely accompanied by WT_55_1, WT_55_2, pssA_55_2, and pssA_55_3, which would be within the same "batch." Running ```bio search PRJNA1155898``` allowed me to confirm the existence of those samples, and the corresponding samples from the other "batches."

This report was uploaded to the repository at https://github.com/nakinscherf/BMMB852/blob/main/week13/README_hw13.md
