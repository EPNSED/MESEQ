#!/bin/bash
#SBATCH --job-name=FastQC
#SBATCH -o /home/users/medwards38/TB/RNAseq/data/BatchOut/FastQC-%N.%j.stdout
#SBATCH -e /home/users/medwards38/TB/RNAseq/data/BatchOut/FastQC-%N.%j.stderr
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=1-00:15:00     # 1 day and 15 minutes
#SBATCH --mail-user=medwards38@gsu.edu
#SBATCH --mail-type=ALL
#SBATCH -p qHM

module use /apps/Compilers/modules-3.2.10/Debug-Build/Modules/3.2.10/modulefiles
module load BioInformatics/FastQC0.11.5
find  /home/users/medwards38/TB/RNAseq/data/Raw_data  -name *.fastq.gz | parallel --jobs 12 'fastqc  -o /home/users/medwards38/TB/RNAseq/data/FastQC -f fastq --extract {}'
