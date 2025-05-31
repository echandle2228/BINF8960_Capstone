# Capstone Project for BINF8960

### Genomics Pipeline
- Project setup
  - setup.sh - script to set up a project folder and copy sequences from shared class folder
- Run Quality Control
  - QC_Trim.sh - script with commands to trim the sequences and run quality control before and after trimming
- Trim Adapters off the sequences
  - QC_Trim.sh - script with commands to trim the sequences and run quality control before and after trimming
- Align reads to the reference genome
  - variant_calling.sh - script with commands to download the reference genome, index the genome, align reads, and call variants
- Call variants in the aligned reads
  - variant_calling.sh - script with commands to download the reference genome, index the genome, align reads, and call variants
- Get the read counts and number of variants
  - summary_stats.sh - script to save read counts and variants for each sample in a csv file
- batch.sh - script to run the full pipeline

### Files
- data - quality control output files for raw and trimmed reads
- results - csv file with the summary_statistics

### Analysis
- Capstone_Project.pdf - Project Report with write-up and analyses
- Capstone_Project.Rmd - R mark down file of Project Report
