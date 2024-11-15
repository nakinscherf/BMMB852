# 20240908 Kinscherf BMMB852 Homework— .md version

```bash
mkdir unixtut
cd unixtut
```

Choosing organism Ursus maritimus, polar bear

```bash
wget https://ftp.ensembl.org/pub/current_gff3/ursus_maritimus/README
wget https://ftp.ensembl.org/pub/current_gff3/ursus_maritimus/Ursus_maritimus.UrsMar_1.0.112.gff3.gz
gunzip Ursus_maritimus.UrsMar_1.0.112.gff3.gz 
```

Polar bear fun facts: aside from being built to stay warm, they're also built to walk on ice! Their paws wide to help distribute weight, and their footpads have papillae to grip and resist slipping.

```bash
cat Ursus_maritimus.UrsMar_1.0.112.gff3 | grep "^##sequence-region" | wc -l
```

Output: There appear to be 23819 sequence regions in this genome assembly, which can't possibly be right if that's a chromosome count. ChatGPT asserts that sequence regions can also be contigs and scaffolds in genomes that aren't yet fully assembled, or annotated non-standard regions such as mitochondrial DNA.

Brief search online suggests polar bears should have 37 chromosomes. Polar bear genome assembly may be in an incomplete state.

```bash
cat Ursus_maritimus.UrsMar_1.0.112.gff3 | grep "^##sequence-region" | sort-uniq-count-rank | wc -l
grep "^##sequence-region" Ursus_maritimus.UrsMar_1.0.112.gff3 | awk '{print $2}' | sort | uniq | wc -l
```
Both first (my attempt) and second (ChatGPT suggestion) commands still returned 23819 separate counts

Removed ##sequence-region lines at the beginning of the file because I couldn't make sure the rest of the gff3 file looked normal with 23000 sequence regions in the way

```bash
cat Ursus_maritimus.UrsMar_1.0.112.gff3 | grep -v "^##sequence-region" > filtered.gff3
filtered.gff3 | cut -f 3 > types.txt
cat types.txt | sort | uniq -c | sort -rn | head
```
Output: The top-ten most annotated feature types are exons, CDS, biological_region, ###, mRNA, region, gene, five_primer_UTR, three_prime, UTR, ncRNA_gene. The type "###" appears to be placeholder text between some entries, so I expanded the "head" count to 11 to get one more actual genomic feature.

```bash
cat types.txt | sort | uniq -c | sort -rn | head -n 11
```
Output: The tenth most annotated feature type, assuming ### is not an actual feature, is lnc_RNA.

This also tells us that there are 18724 features identified as (I assume protein coding) genes in this file.

Note: I ran the same commands for the unfiltered file, and got the same order of features and same count for each feature.

Sequence IDs appear to start with AVOR, so I will retrieve the number of lines with AVOR in them to determine the amount of genomic features contained in the file.

```bash
cat Ursus_maritimus.UrsMar_1.0.112.gff3 | grep AVOR | wc -l
```
Output: 46268. 23819 of those are sequence regions, so there are 22449 lines containing AVOR that aren't sequence regions. I would take 22449 as the count for features, given that I have no biological context for the significance of the sequence regions.

```bash
cat types.txt | sort | uniq -c | sort -rn | wc -l
```
Output: 29. But viewing the sort-uniq-count-rank outputs earlier showed me that 6 "features" in this count are comments with information related to the file. Subtracting those, there are 23 types of features described for this genome.

```bash
cat types.txt | sort | uniq | head -n 25
```
Output: This was an intermediate step while building command to rank the most annotated feature types. For some reason, the cut to isolate column 3 retrieved comments on the genome build, as well. From these lines, it appears that this is the first version of a genome assembly for Ursus maritimus; that the genome is originally dated to 2014/05; and that the genome build was last updated in 2020/03.

Because there are multiple tens of thousands of sequence regions in the genome assembly, I do not think that the genome for Ursus maritimus, polar bears, is complete. I am somewhat surprised that a genome has not been completed with samples from various AZA captive polar bears. However, I have to imagine that even with positive engagement training, it's unpleasant to take a blood sample from a polar bear.

A quick internet search produced a page from the Genome Sciences Centre claiming grizzly bears have roughly 20,000 protein-coding genes, 7,000 non-coding genes, and 4000 pseudo-genes in their genome. Comparatively, the current gff3 for polar bears contains (roughly) 19,000 genes and 5,000 features of the type ncRNA_gene, which I take to be non-coding genes. That the numbers are similar seems reassuring. The vast majority of features in the file are related to protein coding regions; I'm guessing that there's decent annotation of the protein coding portions of the genome, but introns and other untranslated regions have not been annotated thoroughly. This may explain why there are many distinct sequence regions that haven't been resolved into a contiguous, complete genome.

This also appears to be an early version of the "assembled" genome, and fairly recent. That there haven't been updates to the build makes me wonder if there's a very limited number of groups working on this, which would also slow the process of fully assembling the genome.

File Kinscherf_wk2.txt added to GitHub repository nakinscherf/BMMB852
https://github.com/nakinscherf/BMMB852/blob/main/week02/Kinscherf_wk2.txt

File Kinscherf_wk2.md added to GitHub repository nakinscherf/BMMB852
https://github.com/nakinscherf/BMMB852/blob/main/week02/Kinscherf_wk2.md
