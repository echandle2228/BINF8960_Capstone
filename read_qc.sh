#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=QC_TrimmingReads
#SBATCH --ntasks=1
#SBATCH --time=2:00:00
#SBATCH --mem=2gb
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ec50513@uga.edu

# Script to run FASTQC and MultiQC on sequencing reads

# Make directories
mkdir data/raw_fastqc_results
mkdir data/trimmed_fastq
mkdir data/raw_fastqc_trimmed_results

# Load and run fastqc on all fastq files in raw data
module load FastQC/0.11.9-Java-11
fastqc -o data/raw_fastqc_results/ data/raw_fastq/*.fastq.gz

# Load and run Multiqc
module load MultiQC/1.14-foss-2022a
multiqc -o data/raw_fastqc_results/ data/raw_fastqc_results


# Trim raw reads with trimmomatic
module load Trimmomatic/0.39-Java-13
TRIMMOMATIC="java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar"

for fwd in data/raw_fastq/*_1.fastq.gz
do
	sample=$(basename $fwd _1.fastq.gz)
	echo $TRIMMOMATIC PE data/raw_fastq/${sample}_1.fastq.gz \
		data/raw_fastq/${sample}_2.fastq.gz \
		data/trimmed_fastq/${sample}_1.paired.fastq.gz \
		data/trimmed_fastq/${sample}_1.unpaired.fastq.gz \
		data/trimmed_fastq/${sample}_2.paired.fastq.gz \
		data/trimmed_fastq/${sample}_2.unpaired.fastq.gz \
		ILLUMINACLIP:data/raw_fastq/NexteraPE-PE.fa:2:30:10:5:True SLIDINGWINDOW:4:20
done


# Load and run fastqc on all fastq files in raw data
module load FastQC/0.11.9-Java-11
fastqc -o data/raw_fastqc_trimmed_results/ data/trimmed_fastq_small/*.fastq

# Load and run Multiqc
module load MultiQC/1.14-foss-2022a
multiqc -o data/raw_fastqc_trimmed_results/ data/raw_fastqc_trimmed_results/
