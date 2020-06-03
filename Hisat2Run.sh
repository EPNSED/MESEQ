#!/bin/bash
#SBATCH --job-name=Hisat-DdapB_3_d7_MX29_L005
#SBATCH -o /home/users/medwards38/TB/RNAseq/test//BatchOut/DdapB_3_d7_MX29_L005-%N.%j.stdout
#SBATCH -e /home/users/medwards38/TB/RNAseq/test//BatchErr/DdapB_3_d7_MX29_L005-%N.%j.stderr
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
hisat2 -k 1 -q --rna-strandness RF -x  /home/users/medwards38/TB/RNAseq/test//Index/mtb_H37Rv -1 /home/users/medwards38/TB/RNAseq/test//Trimmed/DdapB_3_d7_MX29_L005.R1_val_1.fq.gz -2 /home/users/medwards38/TB/RNAseq/test//Trimmed/DdapB_3_d7_MX29_L005.R2_val_2.fq.gz -S /home/users/medwards38/TB/RNAseq/test//Aligned/DdapB_3_d7_MX29_L005.sam
