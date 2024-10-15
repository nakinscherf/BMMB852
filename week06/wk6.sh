# 2024 Kinscherf homework6: FASTQ Quality control
# assumes installation of a multiqc environment

# setting error and trace
set -uex

# SRR number
SRR=SRR30415233

# Number of reads to sample
N=10000

# output read names
R1=reads/${SRR}_1.fastq
R2=reads/${SRR}_2.fastq

# trimmed read names
T1=reads/${SRR}_1.trimmed.fastq
T2=reads/${SRR}_2.trimmed.fastq

# reads directory
RDIR=reads
# reports director
PDIR=reports

###NO CHANGES BELOW THIS LINE###

# make necessary directorys for reads and outputs
mkdir -p ${RDIR} ${PDIR}

# download the FASTQ file
fastq-dump -X ${N} --split-files -O ${RDIR} ${SRR}

# run fastqc
fastqc -q -o ${PDIR} ${R1} ${R2}

# run fastp and trim for quality 
# can be swapped for commented-out command below
#fastp --cut_tail -i ${R1} -I ${R2} -o ${T1} -O ${T2}
fastp --cut_right -i ${R1} -I ${R2} -o ${T1} -O ${T2}

# run fastqc
fastqc -q -o ${PDIR} ${T1} ${T2}

# running multiqc out of the menv environment on the reports directory
micromamba run -n menv multiqc -o ${PDIR} ${PDIR}
