#!/bin/bash
#SBATCH --job-name=SamTools
#SBATCH -o /home/users/medwards38/TB/RNAseq/test//BatchOut/Counts-%N.%j.stdout
#SBATCH -e /home/users/medwards38/TB/RNAseq/test//BatchErr/Counts-%N.%j.stderr
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=1-00:15:00     # 1 day and 15 minutes
#SBATCH --mail-user=medwards38@gsu.edu
#SBATCH --mail-type=ALL
#SBATCH -p qHM

module use /apps/Compilers/modules-3.2.10/Debug-Build/Modules/3.2.10/modulefiles
module load BioInformatics/Samtools1.3.1
samtools view -b /home/users/medwards38/TB/RNAseq/test//Aligned/DdapB_3_d7_MX29_L005.sam > /home/users/medwards38/TB/RNAseq/test//Aligned/DdapB_3_d7_MX29_L005.bam
samtools sort -n -O bam -m 36G -o /home/users/medwards38/TB/RNAseq/test//Aligned/DdapB_3_d7_MX29_L005_sorted.bam -T DdapB_3_d7_MX29_L005 /home/users/medwards38/TB/RNAseq/test//Aligned/DdapB_3_d7_MX29_L005.bam
