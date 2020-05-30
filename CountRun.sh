#!/bin/bash
#SBATCH --job-name=Counts
#SBATCH -o /home/users/medwards38/TB/RNAseq/data/NewRun//BatchOut/Counts-%N.%j.stdout
#SBATCH -e /home/users/medwards38/TB/RNAseq/data/NewRun//BatchErr/Counts-%N.%j.stderr
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=1-00:15:00     # 1 day and 15 minutes
#SBATCH --mail-user=medwards38@gsu.edu
#SBATCH --mail-type=ALL
#SBATCH -p qHM

module use /apps/Compilers/modules-3.2.10/Debug-Build/Modules/3.2.10/modulefiles
module load Compilers/Python3.6
htseq-count -n 12 -f sam -m union -s reverse  /home/users/medwards38/TB/RNAseq/data/NewRun//Aligned/.bam /home/users/medwards38/TB/RNAseq/data/NewRun//Aligned/.bam /home/users/medwards38/TB/RNAseq/data/NewRun//Aligned/.bam /home/users/medwards38/TB/RNAseq/data/NewRun//Aligned/.bam  HSNipah/HSNipah.gtf > /home/users/medwards38/TB/RNAseq/data/NewRun//Aligned/counts.txt
