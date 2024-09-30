# 20240930 Kinscherf week 5 homework

### Part 1
using *Agrobacterium tumefaciens* as organism of choice

NCBI accession no. **GCF_013318015.2**

File size: 5.8 MB

Genome size: 6.002464 Mbp

Chromosomes/contigs: 6

Chromosome IDs and lengths:
NZ_CP115841.1, 2804325
NZ_CP115842.1, 2137456

Plasmid IDs and lengths:
NZ_CP115843.1, 632660
NZ_CP115844.1, 164530
NZ_CP115845.1, 57127
NZ_CP115846.1, 206366

### Part 2

For a 10X coverage of 6 Mbp *Agrobacterium tumefaciens*, using reads of 100bp each, and paired end sequencing:
N=300,000

Reads generated: 600,000 (2 x 300,000)
Average read length: 100bp

The -l argument to compare compressed vs uncompressed sizes while unzipping doesn't work for FASTQ file type, presumably to spite me personally.

Original files: 72 MB/file
Compressed files: 13 MB/file

According to ChatGPT, Illumina reads commonly run around 150bp. You could get the same coverage by using 150bp read length and 267,000 reads. For me this requires getting out a calculator rather than quick mental math, so 100bp is a convenient estimate that isn't too far from the capacity of the instrument. However, read number couldn't be reduced by very much while using the same sequencing instrument.

Script committed to repository at https://github.com/nakinscherf/BMMB852/edit/main/week5/week5.sh

### Part 3

The Agrobacterium genome is roughly 6 Mbp, and the file size is 5.8 Mb. Rounding up to 6 Mb for simpler math, there's about a 1bp/1 byte ratio.

From one file with 300,000 reads of 100bp/read, the file size is roughly 72 MB. Assuming a linear relationship, this gives an estimated 240B/read. The compressed file is 13 MB. This would be an estimated 43B/read.

| Genome     | Genome size | Est. file size | 30X reads needed | Est. 30X file size | Est. 30X comp. file size|
|------------|-------------|----------------|------------------|--------------------|-------------------------|
| Yeast      | 12.1 Mbp    | 12.1 MB        | 1,815,000        | 435.6 MB           | 78.0 MB                 |
| Drosophila | 165 Mbp     | 165 MB         | 24,750,000       | 5.9 GB             | 1.1 GB                  |
| Human      | 3.2 Gbp     | 3.2 GB         | 480,000,000      | 115.2 GB           | 20.6 GB                 |

Report committed to repository at https://github.com/nakinscherf/BMMB852/edit/main/week5/Kinscherf_week5.md
