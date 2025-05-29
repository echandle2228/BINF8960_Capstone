# Script to set up analysis of E coli variation for BINF 8960

# Starting in the project folder
# create the appropriate directory structure
mkdir -r data/raw_fastq docs results

# Copy over the raw data files and make them read-only
cp -r /work/binf8960/instructor_data/raw_fastq ./data/

# Make it read only
chmod -w data/raw_fastq/*.fastq
