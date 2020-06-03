#!/bin/bash
#SBATCH --job-name=Index
#SBATCH -o /home/users/medwards38/TB/RNAseq/test//BatchOut/Index-%N.%j.stdout
#SBATCH -e /home/users/medwards38/TB/RNAseq/test//BatchErr/Index-%N.%j.stderr
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
hisat2-build -f /home/users/medwards38/TB/RNAseq/test//Reference/Mycobacterium_tuberculosis_h37rv.ASM19595v2.dna.toplevel.fa /home/users/medwards38/TB/RNAseq/test//Index/mtb_H37Rv
