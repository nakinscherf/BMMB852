# 20240922 Kinscherf Week 4 homework

### Part 1: Writing a script

Rewrote Kinscherf_wk2.md as a bash script titled **week4.sh**. Uploaded to GitHub repository at the following link: https://github.com/nakinscherf/BMMB852/blob/main/week4/week4.sh

**Notes on script:** I found in the process of writing the script that one of my original commands did not retrieve the correct information (total number of genomic features in the file), so that value is different when the script is used to retrieve the information. (46268 originally, now finding 1108663, which does make more sense.)

I also saw the list of total unique feature types again while assembling the script, and since I originally counted manually, I think I must have miscounted the number of feature types that were actually comments. I believe 22 rather than 23 to be accurate.

I elected not to include -e in the error-handling for the script, because I was worried it would cause issues with the grep commands (none of which should return 0, but nonetheless).

Based on my original assignment, looking at the organism Ursus maritimus (polar bear), the first set of variables were:
```bash
GROUP="hw4"
URL="https://ftp.ensembl.org/pub/current_gff3/ursus_maritimus/Ursus_maritimus.UrsMar_1.0.112.gff3.gz"
GENOME="Ursus_maritimus.UrsMar_1.0.112.gff3"
```

**Output:** The script was able to replicate my original findings, aside from the total genomic features and unique feature types, which I believe were originally incorrect.

Sequence regions: 23819

Top 10 feature types: exon, CDS, biological_region, mRNA, region, gene, five_prime_UTR, three_prime_UTR, ncRNA_gene, lnc_RNA

Unique genomic feature types: 22

Genes: 18724

Total features: 1108663

I was previously assigned to peer-review Stephanie Won and Niral Shah's week 3 assignments. I checked their week 2 assignments to test my script.

**Stephanie Won:**

Organism: Coturnix japonica (Japanese quail)
```bash
GROUP="hw4t1"
URL="https://ftp.ensembl.org/pub/current_gff3/coturnix_japonica/Coturnix_japonica.Coturnix_japonica_2.0.112.gff3.gz"
GENOME="Coturnix_japonica.Coturnix_japonica_2.0.112.gff3"
```
**Report:** My script replicated all values originally reported.

Sequence regions: 2012

Top 10 feature types: exon, CDS, biological_region, mRNA, gene, five_prime_UTR, lnc_RNA, three_prime_UTR, ncRNA_gene, region

Unique genomic feature types: 19

Genes: 15732

Total features: 921141

**Niral Shah:**

Organism: Saccharomyces cerevisiae
```bash
GROUP="hw4t2"
URL="http://ftp.ensembl.org/pub/current_gff3/saccharomyces_cerevisiae/Saccharomyces_cerevisiae.R64-1-1.112.gff3.gz"
GENOME="Saccharomyces_cerevisiae.R64-1-1.112.gff3"
```
**Report:** My script replicated all results except for the total number of features, which was originally found to be 8. Unfortunately I don't understand the command/code for this in the original report, so I can't compare it to mine and see what they were looking at. Given that there are 16 unique feature types, I feel pretty confident that there should be more than 8 features, unless I'm misunderstanding terminology very badly.

Sequence regions: 17

Top 10 feature types: exon, CDS, gene, mRNA, ncRNA_gene, tRNA, transposable_element, transposable_element_gene, snoRNA, rRNA

Unique genomic feature types: 16

Genes: 6600

Total features: 28695

### Part 2: Sequence ontology

I decided to look up what snoRNA was after seeing the term in Shah's results. I discovered while trying to use this tool that the case used to search terms is critical. The command
```bash
bio explain snoRNA
```
only produces an ungrouped list of GO and SO terms that contain the string "snorna". To get a definition and categorized parent and child terms, I needed to give the term in lowercase in my command.
```bash
bio explain snorna
```
**snoRNA (SO:0000275)** is defined as:

"...any one of a class of **small RNAs that are associated with the eukaryotic nucleus as components of small nucleolar ribonucleoproteins. They participate in the processing or modifications of many RNAs, mostly ribosomal RNAs (rRNAs) though snoRNAs are also known to target other classes of RNA,** including spliceosomal RNAs,tRNAs, and mRNAs via a stretch of sequence that is complementary to a sequence in the targeted RNA."

Its **parent terms** are sncRNA (SO:0002247) and snoRNA_primary_transcript (SO:0000232). I was unfamiliar with both of these terms, although the snoRNA primary transcript seems self-explanatory. I used the "bio explain" command to find a definition for sncRNA; it's a small (<200nt) non-coding RNA. This makes sense as a parent term for snoRNA, as a larger group that the term would fit within.

Its **child terms** are c_d_box_snoRNA (SO:0002095), h_aca_box_snoRNA (SO:0000593), and scaRNA (SO:0000594). These all appear to be increasingly specific snoRNA types.

While troubleshooting the "bio explain" command, I looked at the definition of snoRNA as it's given on the Sequence Ontology website, and later had that page up to compare with the results from "bio explain snorna." I found that the definition given by the "bio explain" command was easier to understand at a glance than the definition given on the web page. This was largely because the command gave a more general picture of function for the entire group, rather than digging into specific modifications.

Report uploaded to repository at https://github.com/nakinscherf/BMMB852/blob/main/week4/Kinscherf_wk4rep.md