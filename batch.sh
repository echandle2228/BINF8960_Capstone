
#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=test
#SBATCH --ntasks=1
#SBATCH --time=2:00:00
#SBATCH --mem=2gb

cd /scratch/ec50513/capstone

# Run e coli pipeline
bash setup.sh
bash QC_Trim.sh
bash variant_calling.sh
bash summary_stats.sh
