#!/bin/bash

export search_dir=Trimmed
module use /apps/Compilers/modules-3.2.10/Debug-Build/Modules/3.2.10/modulefiles
module load BioInformatics/Hisat2.2.0
for entry in "$search_dir"/*
do
  echo "#!/bin/bash">Hsat2Run.sh
  JobName=$(echo $entry|cut -d "/" -f 2| cut -d "." -f 1|cut -d "_" -f 1)
  echo "#SBATCH --job-name=Hisat-"$JobName>>Hsat2Run.sh
  echo "#SBATCH -o /home/users/medwards38/NiV/data/RNASeq-Pipeline/BatchOut/"$JobName"-$SLURM_JOBID.stdout">>Hsat2Run.sh
  echo "#SBATCH -e /home/users/medwards38/NiV/data/RNASeq-Pipeline/BatchErr/"$JobName"-$SLURM_JOBID.stderr">>Hsat2Run.sh
  while read line; do echo -e "$line" >>Hsat2Run.sh ;  done < JobSubmit.sh
  echo "module use /apps/Compilers/modules-3.2.10/Debug-Build/Modules/3.2.10/modulefiles">>Hsat2Run.sh
  echo "module load BioInformatics/HiSat2.2.0">>Hsat2Run.sh
  echo "hisat2 --min-intronlen 50 --max-intronlen 50000 -p 12 -k 1 -q -x HSNipah/HSNipah -U $entry -S bam/"$JobName".sam" >>Hsat2Run.sh
  Output=$(sbatch <Hsat2Run.sh)
  JobID=$(echo $Output|cut -d " " -f 4)
  echo "$JobID"
  echo "$entry"
done
