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

# Create output file
touch raw_stats.csv
touch trimmed_stats.csv
touch mapped_stats.csv
touch variant_stats.csv

# Create headers for each csv file
echo "sample,raw_reads" > raw_stats.csv
echo "sample,trimmed_reads" > trimmed_stats.csv
echo "sample,mapped_reads" > mapped_stats.csv
echo "sample,variants" > variant_stats.csv

# Count the number of reads in the raw
for file in data/raw_fastq/*_1.fastq.gz
do
	sample=$(basename $file _1.fastq.gz) # Extract the sample name
	echo "Counting reads for $sample"
	lines=$(zcat $file | wc -l)
	read_count=$((lines / 4))

	echo "$sample,$read_count" >> raw_stats.csv
done


# Count the number of reads in the trimmed data
for file in data/trimmed_fastq/*_1.paired.fastq.gz
do
	sample=$(basename $file _1.paired.fastq.gz) # Extract the sample name
	echo "Counting reads for $sample"
	lines=$(zcat $file | wc -l)
	read_count=$((lines / 4))
	echo "$sample,$read_count" >> trimmed_stats.csv
done

# Count the number of reads that aligned to the genome
for file in results/bam/*.sorted.bam
do
	sample=$(basename $file .sorted.bam) # Extract the sample name
	echo "Counting mapped reads for $sample"
	mapped_count=$(samtools view -F 0x4 $file | wc -l)
	echo "$sample,$mapped_count" >> mapped_stats.csv
done

# Count the number of variant sites in each sample
for file in results/vcf/*.vcf
do
        sample=$(basename $file .vcf) # Extract the sample name
        echo "Counting variants for $sample"
        variants=$(grep -v '#' $file | wc -l)
        echo "$sample,$variants" >> variant_stats.csv
done

# Merging separate csv files into one tidy csv file
join -t, raw_stats.csv trimmed_stats.csv > merge1.csv
join -t, mapped_stats.csv variant_stats.csv > merge2.csv
join -t, merge1.csv merge2.csv > results/summary_stats.csv

# Clean up folder by deleting intermediate csv
rm raw_stats.csv trimmed_stats.csv mapped_stats.csv variant_stats.csv merge1.csv merge2.csv
