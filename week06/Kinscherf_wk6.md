# Kinscherf Homework 6 2024-10-06

BioProject: PRJNA1152935 
*Agrobacterium tumefaciens* A136 genome sequencing and assembly
**SRR30415233**

Part of a study by **A.L. Montoya *et al.* (1978)**
doi: 10.1128/jb.136.3.909-915.1978

Authors were compairing biotype 2 strains of *Agrobacterium tumefaciens* and *A. radiobacter* to study plasmids associated with virulence and whether different strategies used by bacterial pathogens could be mutually exclusive

Coding followed wk6.sh (https://github.com/nakinscherf/BMMB852/blob/main/week06/wk6.sh)

From the first 10,000 reads of this WGS, I received the following quality checks on the paired-end reads:

### Read 1
![SRR20415233_1FQC.png](https://github.com/nakinscherf/BMMB852/blob/main/week06/SRR20415233_1FQC.png)
### Read 2
![SRR20415233_2FQC.png](https://github.com/nakinscherf/BMMB852/blob/main/week06/SRR20415233_2FQC.png)

I tested both --cut_tail and --cut_right for cleaning the data.

## --cut_tail
### Read 1
![SRR20415233_1FQC.png](https://github.com/nakinscherf/BMMB852/blob/main/week06/SRR20415233_1FQC.png)
### Read 2
![SRR20415233_2FQC.png](https://github.com/nakinscherf/BMMB852/blob/main/week06/SRR20415233_2FQC.png)
## --cut_right
### Read 1
![SRR20415233_1TrFQC.png](https://github.com/nakinscherf/BMMB852/blob/main/week06/SRR20415233_1TrFQC.png)
### Read 2
![SRR20415233_2TrFQC.png](https://github.com/nakinscherf/BMMB852/blob/main/week06/SRR20415233_2TrFQC.png)

I decided to keep --cut_right in my script, because it resulted in a much greater shift into the positive base quality. However, I also noticed the following for total base counts in each report:

| Read  | Orig. | Tail    | Right   |
|-------|-------|---------|---------|
|Read 1 | 3 Mbp | 2.8 Mbp | 2.1 Mbp |
|Read 2 | 3 Mbp | 2.6 Mbp | 1.8 Mbp |

So, although cut_right gives higher quality per-base sequence results than cut_tail, there's a huge trade-off in the number of base-reads.

The cut-right results also go from a mediocre to bad grade on per-base sequence content in Read 2, but not in Read 1. By eye I can't tell any major differences between those graphs and the ones for the original data and the cut-tail trim results. Per-sequence quality scores look largely the same, although cut-tail gives a wider distribution (and thus more lower-quality bases). 

Another difference I saw was in sequence length distribution. Each of the originals had a sequence distribution of a single spike at 300bp. However, after running cut-tail, the peak is less sharp and is a few base pairs shorter. The cut-right images, on the other hand, now have a seuqnce length distribution with two peaks, for which the majority of sequence fragments have a length between ~180 and ~300bp.

In my script, I have left cut-right as the executable command. However, it can be easily commented out, and the cut-tail equivalent un-commented-out.

Uploaded to repository at https://github.com/nakinscherf/BMMB852/blob/main/week06/Kinscherf_wk6.md
