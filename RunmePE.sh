#!/bin/bash
# O. Tange (2011): GNU Parallel - The Command-Line Power Tool, The USENIX Magazine, February 2011:42-47.


printf "\n\nPlease select pipeline stage you like to execute from selections below.
1. Run FastQC
2. Run TrimGalore
3. Run Hisat2

Please make sure raw data is located at the base_path/Raw_data Directory. To execute the pipeline use following syntax. 
RunmePE.sh base_path \n\n\n "

read -p 'Please enter your selection  ' select




export base_dir=$1
export Raw_data=$1/Raw_data
export FastQC_Processed=$1/FastQC
export search_dir=$base_dir/Trimmed
export batchout=$base_dir/BatchOut
[ -d $FastQC_Processed ] && echo "Directory "$FastQC_Processed "exists." || mkdir $FastQC_Processed
[ -d $search_dir ] && echo "Directory "$search_dir "exists." || mkdir $search_dir
[ -d $batchout ] && echo "Directory "$batchout "exists." || mkdir $batchout

module use /apps/Compilers/modules-3.2.10/Debug-Build/Modules/3.2.10/modulefiles
module load BioInformatics/HiSat2.2.0
Dependency="--dependency=afterok"
CountInput=""

if [ $select -eq 1 ] 
then
printf " \n \e[1;33m Running FastQC now \e[0m \n\n "
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
Output=$(sbatch <FastQCRun.sh)
JobID=$(echo $Output|cut -d " " -f 4)
Dependency="${Dependency}:${JobID}"
printf " Job submitted to the cluster. JobID %s assigned to the job. \e[1;32mNote the JobID , there will be corresponding std input/output in the BatchOut directory.\e[0m You can monitor the progress of the current job using \e[1;34msqueue %s \e[0m Output will be stored in the FastQC directory\n\n\n" "$JobID" "$JobID"
exit 0
fi


if [ $select -eq 2 ]
then
printf " \n \e[1;33m Running TrimGalore now \e[0m \n\n "
         echo "#!/bin/bash">TrimGaloreRun.sh
         echo "#SBATCH --job-name=TrimGalore">>TrimGaloreRun.sh
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
printf " Job submitted to the cluster. JobID %s assigned to the job. \e[1;32m Note the JobID , there will be corresponding std input/output in the BatchOut directory. \e[0m You can monitor the progress of the current job using \e[1;34msqueue %s \e[0m Output will be stored in the Trimmed directory\n\n\n" "$JobID" "$JobID"
exit 0
fi

if [ $select -eq 3 ]
then

printf " \n \e[1;33m Running Hisat2 now \e[0m\n\n "
for entry in "$search_dir"/*
do
  echo "#!/bin/bash">Hisat2Run.sh
  JobName=$(echo $entry|cut -d "/" -f 2| cut -d "." -f 1|cut -d "_" -f 1)
  echo "#SBATCH --job-name=Hisat-"$JobName>>Hisat2Run.sh
  echo "#SBATCH -o /home/users/medwards38/NiV/reanalysis/BatchOut/"$JobName"-%N.%j.stdout">>Hisat2Run.sh
  echo "#SBATCH -e /home/users/medwards38/NiV/reanalysis/BatchErr/"$JobName"-%N.%j.stderr">>Hisat2Run.sh
  while read line; do echo -e "$line" >>Hisat2Run.sh ;  done < JobSubmit.sh
  echo "module use /apps/Compilers/modules-3.2.10/Debug-Build/Modules/3.2.10/modulefiles">>Hisat2Run.sh
  echo "module load BioInformatics/HiSat2.2.0">>Hisat2Run.sh
  echo "hisat2 --min-intronlen 50 --max-intronlen 50000 -p 12 -k 1 -q --rna-strandness R -x HSNipah/HSNipah -U $entry -S aligned/"$JobName".sam" >>Hisat2Run.sh
  #Output=$(sbatch <Hsat2Run.sh)
  JobID=$(echo $Output|cut -d " " -f 4)
  Dependency="${Dependency}:${JobID}"
  CountInput="${CountInput} aligned/${JobName}.sam "
printf " Job submitted to the cluster. JobID %s assigned to the job. \e[1;32m Note the JobID , there will be corresponding std input/output in the BatchOut directory.\e[0m You can monitor the progress of the current job using \e[1;34msqueue %s \e[0m\n\n\n" "$JobID" "$JobID"
exit 0
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

exit
fi
