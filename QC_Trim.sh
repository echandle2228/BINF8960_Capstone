#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=QC_TrimmingReads
#SBATCH --ntasks=1
#SBATCH --time=2:00:00
#SBATCH --mem=2gb
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ec50513@uga.edu

# Script to run FASTQC and MultiQC on sequencing reads and to trimm adapters based on QC output

# Load all required modules
module load FastQC/0.11.9-Java-11
module load MultiQC/1.14-foss-2022a
module load Trimmomatic/0.39-Java-13

# Make directories required for QC and trimmed reads
mkdir data/raw_fastqc_results
mkdir data/trimmed_fastq
mkdir data/raw_fastqc_trimmed_results

# Run fastqc on all fastq files in raw data
fastqc -o data/raw_fastqc_results/ data/raw_fastq/*.fastq.gz

# Run Multiqc to compile fastqc output
multiqc -o data/raw_fastqc_results/ data/raw_fastqc_results


# Trim raw reads with trimmomatic
TRIMMOMATIC="java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar"

for fwd in data/raw_fastq/*_1.fastq.gz
do
	sample=$(basename ${fwd} _1.fastq.gz)

	echo "Sample ${sample} running"
	$TRIMMOMATIC PE data/raw_fastq/${sample}_1.fastq.gz data/raw_fastq/${sample}_2.fastq.gz  \ # Raw input files
	data/trimmed_fastq/${sample}_1.paired.fastq.gz data/trimmed_fastq/${sample}_1.unpaired.fastq.gz \ # Output files
	data/trimmed_fastq/${sample}_2.paired.fastq.gz data/trimmed_fastq/${sample}_2.unpaired.fastq.gz \ # Output files
	ILLUMINACLIP:data/raw_fastq/NexteraPE-PE.fa:2:30:10:5:True SLIDINGWINDOW:4:20 # Trimming information
done


# Run fastqc on all trimmed fastq files
fastqc -o data/raw_fastqc_trimmed_results/ data/trimmed_fastq/*.fastq.gz

# Run Multiqc to compile fastqc ouput on trimmed files
multiqc -o data/raw_fastqc_trimmed_results/ data/raw_fastqc_trimmed_results/
