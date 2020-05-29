#!/bin/bash
#SBATCH --job-name=Hisat-home
#SBATCH -o /home/users/medwards38/NiV/reanalysis/BatchOut/home-%N.%j.stdout
#SBATCH -e /home/users/medwards38/NiV/reanalysis/BatchErr/home-%N.%j.stderr
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=1-00:15:00     # 1 day and 15 minutes
#SBATCH --mail-user=medwards38@gsu.edu
#SBATCH --mail-type=ALL
#SBATCH -p qHM

module use /apps/Compilers/modules-3.2.10/Debug-Build/Modules/3.2.10/modulefiles
module load BioInformatics/HiSat2.2.0
hisat2 --min-intronlen 50 --max-intronlen 50000 -p 12 -k 1 -q --rna-strandness R -x HSNipah/HSNipah -U /home/users/medwards38/TB/RNAseq/data/Trimmed/DdapB_1_d0_MX24_L005.R1.fastq.gz_trimming_report.txt -S aligned/home.sam
