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
	@echo "make genome	# download and unzip genome and GFF files"
	@echo "make index	# index genome and GFF files"
	@echo "make download	# download ${SRR} FASTQ files and run fastqc"
	@echo "make trim	# trim ${SRR} FASTQ files and run fastqc"
	@echo "make align	# align trimmed ${SRR} reads to the reference genome"
	@echo "make vcf	# call variants in ${BAM} compared to the reference genome"
	@echo "make index_vcf	# merge all currently existing VCF files into one file, then index merged file"
	@echo "make vep	# predict variant effects of merged VCF file using vep environment"
	@echo "make all	# run download, trim, index, align, vcf targets"
```

To run these, the file requires the following variables to be set: **accession number (ACC), general path to the downloaded genome (GENPATH), the genome file name (GENF), SRR number (SRR), GFF file name (GFF), sample name (SAMPLE), number (N) of reads to sample,** the path to the reference genome (REF), file names for SRR reads to write to (R1, R2), file names for trimmed SRR reads to write to (T1, T2), names for directories containing SRR reads (RDIR) and reports (PDIR), the name of the BAM file that will be produced (BAM), the name of the compressed VCF file that will be produced, and **flags for the variant calling process (PILE_FLAGS, CALL_FLAGS).**

Variables **bolded** above are those likely to need changing. Remaining variables are generic to the pipeline and in many cases can be left alone.

The Makefile was uploaded at https://github.com/nakinscherf/BMMB852/blob/main/week12/Makefile

### Automating the pipeline
Since the genome and GFF files only needs to be downloaded and indexed once, this should be done first using ```make genome index```.

To automatically process many samples with this pipeline, create a comma separated values file containing matched SRR accessions and sample names (here indicated as automation.csv). Using this CSV file, the following command will run all Makefile targets on the provided samples:
```bash
cat automation.csv | parallel --colsep , --header : make all SRR={Run} SAMPLE={Name}
```
After variant calling has run for all samples, the resulting files should be merged with ```make index_vcf```, then run variant effect predictions with ```make vep```. The resulting html file can then be view in one's browser.
### Default Makefile state
The Makefile variables for the uploaded file are **currently set to align reads to the *Agrobacterium tumefaciens* genome. If aligning to another genome, the variables ACC, GENPATH, GENF, and GFF will need to be corrected** in the Makefile or provided in the automation command.

## Assignment 12

To test my automated pipeline, I found a project that looked at many different strains of Agrobacterium to compare their genomes (PRJNA607555). I named the metadata CSV file PRJNA607555.csv. Because they looked at 209 strains and that seemed like a bit much to manage while troubleshooting my code, I focused on the first 10 strains and deleted the rest of the rows in the file. The automation command was as follows:
```bash
cat PRJNA607555.csv | parallel --colsep , --header : make all SRR={Run} SAMPLE={BioSample}
```
Although it would be more informative than the BioSample ID, the strain column could not be used for sample naming because many of the strain IDs contained characters unsuitable for the command line, and individually correcting all of those would defeat the purpose of automation.

For reasons that are unclear to me, my original attempt to run this code had two accessions fail immediately at the download target, and another five fail at the vcf target. I deleted all files produced by the first attempt and re-ran the pipeline to identify the relevant error messages. Although I don't recall changing the design file or the Makefile at all between attempts, all accessions ran perfectly the second time. It shouldn't be a difference of starting from a (mostly) empty folder, because I believe I cleared everything but the source files from the folder before running the pipeline the first time, as well.

Once again, my html summary of the VEP results lists *Homo sapiens* in the species line, although the reference genome was *A. tumefaciens*. However, variants still appear to have been assigned to the appropriate chromosomes in the reference genome. 

![vep_stats_hw12.png](https://github.com/nakinscherf/BMMB852/blob/main/week12/vep_stats_hw12.png)

The variant classes observed in this assignment strongly resemble those seen in assignment 11, where I compared another strain to the reference genome. There, 99.9% of variants were SNVs. In this set of strains, 99.8% of variants are SNVs, with a slightly higher proportion of deletion and insertions. This set of strains includes a very small number of sequence alterations, as well. I'm not entirely sure what "sequence alteration" indicates here, although it's interesting to me that there are the same counts of sequence alteration as different strains analyzed.

![classes_hw12.png](https://github.com/nakinscherf/BMMB852/blob/main/week12/classes_hw12.png)

The vast majority of variants were once again associated with intergenic regions, with genes failing to appear on the list. Upstream and downstream gene variants occurred in roughly the same proportions as previously observed. There was a small increase in the observed non-coding transcript exon variants, although the proportion of these is still miniscule compared to the other three groups observed.

![conseq_all_hw12.png](https://github.com/nakinscherf/BMMB852/blob/main/week12/conseq_all_hw12.png)

The same held true for variants assessed as more severe.

![conseq_sev_hw12.png](https://github.com/nakinscherf/BMMB852/blob/main/week12/conseq_sev_hw12.png)

I was intrigued by the extent to which my VEP summary for this assignment resembled the VEP summary from my assignment in week 11, which looked at a strain from a completely different project. The accession I analyzed in that assignment, SRR30415233, contained data from a 1978 study. I attributed the large degree of variation to the temporal distance (~45 years) between strain A136 and the current *A. tumefaciens* reference genome. The study PRJNA607555, by contrast, is associated with a publication from 2020 that looked at *A. tumefaciens* strains in collections. The collection date of most of the first ten samples in the PRJNA607555 metadata file are listed as 1993-1995 (with one outlier from 1964). This puts the temporal distance from the reference genome at ~30 years, but the proportions of variants classes are almost identical. Without reading the publications in detail, I observed from the abstracts that both the 2020 study and the 1978 study were interested in characteristics of the virulence plasmids. Note that chromosomal distribution of variants was also (by eye) very similar between studies. The majority of variants are on NZ_CP115841.1, with the second-most on NZ_CP115842.1 and a slim third-most on NZ_CP115843.1.

![distrib_hw12.png](https://github.com/nakinscherf/BMMB852/blob/main/week12/distrib_hw12.png)

That being said, the 2020 study observed proportionately far more variants in NZ_CP115844.1, NZ_CP115845.1, and NZ_CP115846.1 than the 1978 study. To interpret the information about distribution, I considered the results of my week 5 assignment, which contained information on the chromosomes and plasmids of *A. tumefaciens*, and their respective lengths. NZ_CP115841.1 and NZ_CP115842.1 are chromosomes, and contain many more bases to begin with than the other four "chromosomes," which are actually plasmids. To assess whether there were proportionately more variants in each chromosome/plasmid, I took the variant count per chromosome/plasmid given by this VEP summary and divided it by the respective chromosome/plasmid lengths I found in my week 5 assignment. The resulting value was multiplied by 100 to get the percentage variants called per chromosomes/plasmid. Results were as follows:
> NZ_CP115841.1: 17.62% \
> NZ_CP115842.1: 14.09% \
> NZ_CP115843.1: 04.82% \
> NZ_CP115844.1: 01.62% \
> NZ_CP115845.1: 01.04% \
> NZ_CP115841.1: 06.60%
> 
This determined that although the chromosomes are much longer than the plasmids, proportionately more variants were occurring on the chromosomes than the plasmids. Although I did not make the same comparison for the variants called in the accession from the 1978 study, this would refute my hypothesis in assignment 10, where I speculated that many variants between A136 and the reference genome could be related to virulence. As all four plasmids contain less variation than the chromosomes, the virulence plasmid cannot be the source of most of the variants. This also suggests that the greater proportion of variants on particular chromosomes is not related to an author focus on sequencing those regions, since the authors were more interested in the virulence plasmids.

Although one interpretation of the differences in plasmid variant counts between the 1978 study and the 2020 study could be greater variation in the plasmids from strains collected in the 1990s, compared to A136, I suspect that what actually happened was an improvement in the technology for sequencing plasmids.

The CSV file automation.csv used for this assignment was uploaded to https://github.com/nakinscherf/BMMB852/blob/main/week12/PRJNA607555.csv

This report was uploaded to https://github.com/nakinscherf/BMMB852/blob/main/week12/README_hw12.md
