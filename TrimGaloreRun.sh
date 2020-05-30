#!/bin/bash
#SBATCH --job-name=TrimGalore
#SBATCH -o /home/users/medwards38/TB/RNAseq/data/NewRun//BatchOut/FastQC-%N.%j.stdout
#SBATCH -e /home/users/medwards38/TB/RNAseq/data/NewRun//BatchOut/FastQC-%N.%j.stderr
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=1-00:15:00     # 1 day and 15 minutes
#SBATCH --mail-user=medwards38@gsu.edu
#SBATCH --mail-type=ALL
#SBATCH -p qHM

module use /apps/Compilers/modules-3.2.10/Debug-Build/Modules/3.2.10/modulefiles
module load BioInformatics/TrimGalore
find   /home/users/medwards38/TB/RNAseq/data/NewRun//Raw_data  -name *R1.fastq.gz | parallel  --jobs 12 trim_galore --clip_R1 15 --clip_R2 15 --three_prime_clip_R1 2 --three_prime_clip_R2 2 -q 30 -length 50 --paired --trim1 --fastqc -o /home/users/medwards38/TB/RNAseq/data/NewRun//Trimmed {} {=s/.R1./.R2./=}
