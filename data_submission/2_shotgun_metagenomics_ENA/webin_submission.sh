#!/bin/bash


#SBATCH --partition=amilan
#SBATCH --account=amc-general
#SBATCH --job-name=webin_submission
#SBATCH --output=/scratch/alpine/mapgar@xsede.org/webin/crestone/slurm/%J-%x-%a.out
#SBATCH --error=/scratch/alpine/mapgar@xsede.org/webin/crestone/slurm/%J-%x-%a.err
#SBATCH --nodes=1 # use 1 node 
#SBATCH --ntasks-per-node=1 
#SBATCH --cpus-per-task=32
#SBATCH --time=23:00:00 # Time limit days-hrs:min:sec
#SBATCH --qos=normal
#SBATCH --mem=50GB # Memory limit - start out w 50 and increase if needed?
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=madison.apgar@cuanschutz.edu
#SBATCH --array=1-74 ## i assume the array=num samples

## load in java 18 (webin-cli requires at least java 17)
module load jdk/18.0.1.1

#We pull the slurm array index
index_num=$SLURM_ARRAY_TASK_ID

#Then we pull the sample ID
## need txt file of sampleids for this!!
samp_ID=$(sed -n "${index_num}p" /projects/mapgar@xsede.org/webin_cli_submission/ID.txt)

echo "submitting ${samp_ID}...."

#The samples are submitted, parameters need to be adjusted to your login information
java -jar /projects/mapgar@xsede.org/software/webin-cli-9.0.3.jar \
    -context=reads \
    -manifest="/projects/mapgar@xsede.org/webin_cli_submission/crestone_ebi_perSample_manifests/${samp_ID}_manifest.txt" \
    -userName='Webin-yourNumber' \
    -password='yourPassword' \
    -submit

echo "${samp_ID} submitted successfully!"
