#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=variant_calling
#SBATCH --ntasks=1
#SBATCH --time=2:00:00
#SBATCH --mem=2gb
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ec50513@uga.edu


# Script of the summary statistics for e. coli analysis

# Load required modules
module load SAMtools/1.18-GCC-12.3.0

# Creat summary statistics csv file
touch results/summary_stats.csv

# Create header for csv file
echo "sample,read_type,count" > results/summary_stats.csv

# Count the number of reads in the raw
for file in data/raw_fastq/*_1.fastq.gz
do
	sample=$(basename $file _1.fastq.gz) # Extract the sample name
	echo "Counting reads for $sample"
	lines=$(zcat $file | wc -l)
	read_count=$((lines / 4))

	echo "$sample,raw,$read_count" >> results/summary_stats.csv
done


# Count the number of reads in the trimmed data
for file in data/trimmed_fastq/*_1.paired.fastq.gz
do
	sample=$(basename $file _1.paired.fastq.gz) # Extract the sample name
	echo "Counting reads for $sample"
	lines=$(zcat $file | wc -l)
	read_count=$((lines / 4))
	echo "$sample,trimmed,$read_count" >> results/summary_stats.csv
done

# Count the number of reads that aligned to the genome
for file in results/bam/*.sorted.bam
do
	sample=$(basename $file .sorted.bam) # Extract the sample name
	echo "Counting mapped reads for $sample"
	mapped_count=$(samtools view -F 0x4 $file | wc -l)
	echo "$sample,mapped,$mapped_count" >> results/summary_stats.csv
done

# Count the number of variant sites in each sample
for file in results/vcf/*.vcf
do
        sample=$(basename $file .vcf) # Extract the sample name
        echo "Counting variants for $sample"
        variants=$(grep -v '#' $file | wc -l)
        echo "$sample,variants,$variants" >> results/summary_stats.csv
done
