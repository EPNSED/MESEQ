#!/bin/bash
# O. Tange (2011): GNU Parallel - The Command-Line Power Tool, The USENIX Magazine, February 2011:42-47.
export base_dir=$1
export Raw_data=$1/Raw_data
export FastQC_Processed=$1/FastQC
mkdir $base_dir/BatchOut 
mkdir $FastQC_Processed
export search_dir=$base_dir/Trimmed
mkdir $search_dir
module use /apps/Compilers/modules-3.2.10/Debug-Build/Modules/3.2.10/modulefiles
module load BioInformatics/HiSat2.2.0
Dependency="--dependency=afterok"
CountInput=""

#Run FastQC

         echo "#!/bin/bash">FastQCRun.sh
         echo "#SBATCH --job-name=FastQC">>FastQCRun.sh
         echo "#SBATCH -o "$base_dir"/BatchOut/FastQC-%N.%j.stdout">>FastQCRun.sh
         echo "#SBATCH -e "$base_dir"/BatchOut/FastQC-%N.%j.stderr">>FastQCRun.sh
         while read line; do echo -e "$line" >>FastQCRun.sh ;  done < JobSubmit.sh
         echo "module use /apps/Compilers/modules-3.2.10/Debug-Build/Modules/3.2.10/modulefiles">>FastQCRun.sh
         echo "module load BioInformatics/FastQC0.11.5">>FastQCRun.sh
         echo "find " $Raw_data " -name *.fastq.gz | parallel --jobs 12 'fastqc  -o "$FastQC_Processed" -f fastq --extract {}'">>FastQCRun.sh
#sbatch FastQCRun.sh
#Output=$(sbatch <FastQCRun.sh)
JobID=$(echo $Output|cut -d " " -f 4)
Dependency="${Dependency}:${JobID}"


         echo "#!/bin/bash">TrimGaloreRun.sh
         echo "#SBATCH --job-name=FastQC">>TrimGaloreRun.sh
         echo "#SBATCH -o "$base_dir"/BatchOut/FastQC-%N.%j.stdout">>TrimGaloreRun.sh
         echo "#SBATCH -e "$base_dir"/BatchOut/FastQC-%N.%j.stderr">>TrimGaloreRun.sh
         while read line; do echo -e "$line" >>TrimGaloreRun.sh ;  done < JobSubmit.sh
         echo "module use /apps/Compilers/modules-3.2.10/Debug-Build/Modules/3.2.10/modulefiles">>TrimGaloreRun.sh
         echo "module load BioInformatics/TrimGalore">>TrimGaloreRun.sh
         echo "find  " $Raw_data"  -name *R1.fastq.gz | parallel  --jobs 12 trim_galore --clip_R1 15 --clip_R2 15 --three_prime_clip_R1 2 --three_prime_clip_R2 2 -q 30 -length 50 --paired --trim1 --fastqc -o "$search_dir" {} {=s/.R1./.R2./=}">>TrimGaloreRun.sh
#sbatch FastQCRun.sh
Output=$(sbatch <TrimGaloreRun.sh)
JobID=$(echo $Output|cut -d " " -f 4)
Dependency="${Dependency}:${JobID}"
echo $JobID
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
  #Output=$(sbatch <Hsat2Run.sh)
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
#sbatch $Dependency CountRun.sh


