#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=capstone_setup
#SBATCH --ntasks=1
#SBATCH --time=2:00:00
#SBATCH --mem=2gb
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ec50513@uga.edu


# Script to set up analysis of E coli variation for BINF 8960

# Starting in the project folder
# create the appropriate directory structure
mkdir data docs results

# Copy over the raw data files and make them read-only
cp -r /work/binf8960/instructor_data/raw_fastq ./data/

# Make it read only
chmod -w data/raw_fastq/*.fastq.gz
