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
	@echo "make vep	# predict variant effects using vep environment"
	@echo "make all	# run genome, download, trim, index, align, vcf, index_vcf, vep targets"
```

To run these, the file requires the following variables to be set: **accession number (ACC), general path to the downloaded genome (GENPATH), the genome file name (GENF), SRR number (SRR), GFF file name (GFF) number (N) of reads to sample,** file names for SRR reads to write to (R1, R2), file names for trimmed SRR reads to write to (T1, T2), names for directories containing SRR reads (RDIR) and reports (PDIR), the name of the BAM file that will be produced (BAM), the name of the compressed VCF file that will be produced, and flags for the variant calling process (PILE_FLAGS, CALL_FLAGS).

The Makefile was uploaded at https://github.com/nakinscherf/BMMB852/blob/main/week11/Makefile

## Predicting varient effects with VEP
For this assignment, I used ACC=GCF_013318015.2 (*Agrobacterium tumefaciens*) and SRR=SRR30415233. This data was used to sequence and assemble a genome for a particular variant of *A. tumefaciens*, identified by the authors as A136.

Notably, I was reminded that the original publication actually dated to 1978, and was simply registered with the NCBI database in 2024. This suggests to me that rather than A136 diverging from the *A. tumefaciens* reference genome, it is highly likely that the reference genome is decades diverged from the strain used in this study. For a bacterial species, this is a very long time to accumulate evolutionary changes. It is much less surprising that the data contains as many variants as it does with this in mind.

I was immediately somewhat concerned when I opened my html summary of my VEP results, given that the species line lists *Homo sapiens* when my reference genome is for *A. tumefaciens*. I'm not entirely clear where VEP used this alleged species indicator. Hopefully this did not interfere with the variant analysis.

![vep_stats_hw11.png](https://github.com/nakinscherf/BMMB852/blob/main/week11/vep_stats_hw11.png)

That being said, variants still appear to have been assigned to specific chromosomes in the reference genome. Curiously, most of the variants are on two of the six chromosomes, with a much smaller minority on a third and comparatively nothing on the remaining three chromosomes. In my previous assignment, I noted that the number of variants suggested evolutionary divergence between the reference genome for *A. tumefaciens* and A136. This summary seems to suggest that most of the divergence happened on chromosomes NZ CP115841.1, NZ CP115842.1, and a minority on NZ CP115843.1.

![distrib_hw11.png](https://github.com/nakinscherf/BMMB852/blob/main/week11/distrib_hw11.png)

Nearly all of the variants observed were identified as single nucleotide variants (SNVs), with a negligible count for insertions and deletions. This agrees with my observations in the previous assignment, where I noted that sections that appeared to my eye to have deletions were not being recognized as variants. 

![classes_hw11.png](https://github.com/nakinscherf/BMMB852/blob/main/week11/classes_hw11.png)

The majority of the variants were associated with intergenic regions, with the next highest count in regions upstream of genes, and the third most in regions downstream of genes. Notably, genes themselves are not on the list at all, although there is a negligible count for variants in non-coding transcripts. Given the SNV distribution I saw when viewing my VCF results in IGV, I suspect this has to do with definitions for bacterial genes. This could also be where I see a potential analysis mishap with VEP trying to process the results as related to the human species rather than a bacteria. 

![conseq_all_hw11.png](https://github.com/nakinscherf/BMMB852/blob/main/week11/conseq_all_hw11.png)

The same held true for the variants assessed as more likely to be severe. Compared to the summary of all variants, there is a reduction in the count for variants in regions upstream and downstream of genes; however, the non-coding transcripts remain the same, and the change in variants associated with intergenic regions is negligible. 

![conseq_sev_hw11.png](https://github.com/nakinscherf/BMMB852/blob/main/week11/conseq_sev.png)

This report was uploaded to https://github.com/nakinscherf/BMMB852/blob/main/week11/README_hw11.md