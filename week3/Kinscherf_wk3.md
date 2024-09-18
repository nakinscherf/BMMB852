# 20240916 Week 3 Homework

using Agrobacterium tumefaciens as organism of choice
**NCBI accession no. GCF_013318015.2**

```bash
mkdir hw3
cd hw3
datasets summary genome accession GCF_013318015.2
datasets summary genome accession GCF_013318015.2 | jq
datasets download genome accession GCF_013318015.2 --include gff3,cds,protein,rna,genome
unzip ncbi_dataset.zip
```

Output: README.md, md5sum.txt, ncbi_dataset/data/GCF_013318015.2/

Loaded GCF_013318015.2_ASM1331801v2_genomic.fna and genomic.gff into IGV. seems like at least some features in genomic.gff are aligning with start (green) & stop (red) codons in sequence.
See hw3_img1.png
![hw3_img1.png](https://github.com/nakinscherf/BMMB852/blob/main/week3/hw3_img1.png)

```bash
cd ncbi_dataset/data/GCF_013318015.2/
cat genomic.gff | head
cat genomic.gff | awk ' $3=="gene" { print $0 } '
```

Looks like all genes; create file & repeat for CDS.

```bash
cat genomic.gff | awk ' $3=="gene" { print $0 } ' > genes.gff
cat genomic.gff | awk ' $3=="CDS" { print $0 } '
cat genomic.gff | awk ' $3=="CDS" { print $0 } ' > cds.gff
```

Putting genes.gff and cds.gff into IGV.
Removing track genomic.gff.
Seem to be very few items in cds.gff when looking in IGV window?

```bash
cat genes.gff | wc -l
cat cds.gff | wc -l
cat cds.gff | head
```
Output: 5544 lines vs 190 lines. Does appear to be 1 feature/line. Upload's not screwed up, there just isn't CDS annotated for much of the genome. There might be something happening WRT definition of CDS in bacteria.

Not all genes seem to be aligned with start & stop codons. Tried changing translation table to bacterial plastids & saw no change (switched back to standard). Flipping strand seemed to help with some but not all.
See hw3_img2.png and hw3_img2.png
![hw3_img2.png](https://github.com/nakinscherf/BMMB852/blob/main/week3/hw3_img2.png)

![hw3_img3.png] (https://github.com/nakinscherf/BMMB852/blob/main/week3/hw3_img3.png)

(Strand flipped for same region; look @ start/stop codon placement relative to beginning & end of visible genes).

Manually created GFF file & organized in VSC.

```bash
code intervals.gff
```
Created CDS features in two separate chromosomes. File uploaded to repository (https://github.com/nakinscherf/BMMB852/blob/main/week3/intervals.gff).
Loaded intervals.gff into IGV with Agrobacterium tumefaciens reference sequence from NCBI dataset. See hw3_img4.png and hw3_img5.png
![hw3_img4.png](https://github.com/nakinscherf/BMMB852/blob/main/week3/hw3_img4.png)

![hw3_img5.png] (https://github.com/nakinscherf/BMMB852/blob/main/week3/hw3_img5.png)

Creation of GFF file that functions in IGV successful. Assignment uploaded to repository at https://github.com/nakinscherf/BMMB852/blob/main/week3/Kinscherf_wk3.md
