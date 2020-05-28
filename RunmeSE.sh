#!/bin/bash

export search_dir=Trimmed
module use /apps/Compilers/modules-3.2.10/Debug-Build/Modules/3.2.10/modulefiles
module load BioInformatics/HiSat2.2.0
Dependency="--dependency=afterok"
CountInput=""
for entry in "$search_dir"/*
do
  echo "#!/bin/bash">Hsat2Run.sh
  JobName=$(echo $entry|cut -d "/" -f 2| cut -d "." -f 1|cut -d "_" -f 1)
  echo "#SBATCH --job-name=Hisat-"$JobName>>Hsat2Run.sh
  echo "#SBATCH -o /home/users/medwards38/NiV/reanalysis/BatchOut/"$JobName"-%N.%j.stdout">>Hsat2Run.sh
  echo "#SBATCH -e /home/users/medwards38/NiV/reanalysis/BatchErr/"$JobName"-%N.%j.stderr">>Hsat2Run.sh
  while read line; do echo -e "$line" >>Hsat2Run.sh ;  done < JobSubmit.sh
  echo "module use /apps/Compilers/modules-3.2.10/Debug-Build/Modules/3.2.10/modulefiles">>Hsat2Run.sh
  echo "module load BioInformatics/HiSat2.2.0">>Hsat2Run.sh
  echo "hisat2 --min-intronlen 50 --max-intronlen 50000 -p 12 -k 1 -q --rna-strandness R -x HSNipah/HSNipah -U $entry -S aligned/"$JobName".sam" >>Hsat2Run.sh
  Output=$(sbatch <Hsat2Run.sh)
  JobID=$(echo $Output|cut -d " " -f 4)
  Dependency="${Dependency}:${JobID}"
  CountInput="${CountInput} aligned/${JobName}.sam "
done
echo "#!/bin/bash">CountRun.sh
echo "#SBATCH --job-name=Counts">>CountRun.sh
echo "#SBATCH -o /home/users/medwards38/NiV/reanalysis/BatchOut/Counts-%N.%j.stdout">>CountRun.sh
echo "#SBATCH -e /home/users/medwards38/NiV/reanalysis/BatchErr/Counts-%N.%j.stderr">>CountRun.sh
while read line; do echo -e "$line" >>CountRun.sh ;  done < JobSubmit.sh
echo "module use /apps/Compilers/modules-3.2.10/Debug-Build/Modules/3.2.10/modulefiles">>CountRun.sh
echo "module load Compilers/Python3.6">>CountRun.sh
echo "htseq-count -n 12 -f sam -m union -s reverse "$CountInput " HSNipah/HSNipah.gtf > aligned/counts.txt">>CountRun.sh
sbatch $Dependency CountRun.sh


