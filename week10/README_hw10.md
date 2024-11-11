# BMMB852 Homework 10 
### 20241110 Kinscherf

## Makefile information
This assignment generated a Makefile to download and index the reference genome of an organism, download sequence data from a project using the organism, trim and align the data to create a BAM file, index the BAM file, then call variants from the BAM file. 

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
	@echo "make all	# run genome, download, trim, index, align, vcf, index_vcf targets"
```

To run these, the file requires the following variables to be set: **accession number (ACC), general path to the downloaded genome (GENPATH), the genome file name (GENF), SRR number (SRR), number (N) of reads to sample,** file names for SRR reads to write to (R1, R2), file names for trimmed SRR reads to write to (T1, T2), names for directories containing SRR reads (RDIR) and reports (PDIR), the name of the BAM file that will be produced (BAM), the name of the compressed VCF file that will be produced, and flags for the variant calling process (PILE_FLAGS, CALL_FLAGS).

The Makefile was uploaded at https://github.com/nakinscherf/BMMB852/blob/main/week10/Makefile

## Visualizing variant calls
For this assignment, I used ACC=GCF_013318015.2 (*Agrobacterium tumefaciens*) and SRR=SRR30415233.

Looking at the variant calls found in this library, I found that the vast majority of variants were homozygous in the sample. Heterozygous variants were a small minority in comparison.
![hw10_1.png](https://github.com/nakinscherf/BMMB852/blob/main/week10/hw10_1.png)
Using "bio search SRR30415233," I was reminded that this data was used for a study to sequence and assemble a genome for a particular variant of *Agrobacterium tumefaciens*. It appears that this strain (A136) and the reference (which I was unable to check, as the NCBI website refused to load landing pages for any genomes while I was working on this assignment) have evolutionarily diverged. The "bio search" information also indicated that this data was made public at the end of August this year, and I was unable to find a paper with the title "Agrobacterium tumefaciens A136 genome sequencing and assembly" when searching PubMed. This leads me to wonder if the study may not yet be published. I was hoping to see if their study indicated anything about where A136 came from and why it may have variation compared to the reference genome/well-characterized strains of *Agrobacterium tumefaciens*. Without any other evidence, as *A. tumefaciens* is a plant pathogenic bacteria, I hypothesize that the variants may relate to host immunity interactions.

There were many stretches in the library where large (~100-1000bp) deletions didn't seem to be marked in the variant calls, although this may be a misunderstanding on my part of how the deletions would be indicated in IGV. Below is an example of a deletion of almost 1kb.

![hw10_2.png](https://github.com/nakinscherf/BMMB852/blob/main/week10/hw10_2.png)

For the most part, the variant calls seemed to agree with the BAM coverage. Scanning through the alignment by eye, I did not see any false positives. However, there were some false negatives where the VCF did not appear to identify variants marked in the BAM reads (empty space at the top of the screenshot is where variant calls should be indicated; despite all reads carrying what are apparently variations compared to the reference genome, these were not identified as variants):

![hw10_3.png](https://github.com/nakinscherf/BMMB852/blob/main/week10/hw10_3.png)

More common were variants only identified in 1-5 of the reads covering a base, which were not counted as variants. However, this was inconsistent. We can see that the following image identifies two variants with 5-6 reads covering the base:

![hw10_4.png](https://github.com/nakinscherf/BMMB852/blob/main/week10/hw10_4.png)

While another location with two variants covered by 5 reads is not identified by the VCF:

![hw10_5.png](https://github.com/nakinscherf/BMMB852/blob/main/week10/hw10_5.png)

But the most confusing false negative was this variant:

![hw10_6.png](https://github.com/nakinscherf/BMMB852/blob/main/week10/hw10_6.png)

One base in this image is correctly identified as heterozygous for a variant, as at least 10 of the reads covering that base show a variant. However, the adjacent base, which appeared to have the same total number of reads even more of which showed the variant, is not identified as a variant. I am unclear on why one of these bases would be identified as a variant and the other not recognized.

This report was uploaded at https://github.com/nakinscherf/BMMB852/blob/main/week10/README_hw10.md
