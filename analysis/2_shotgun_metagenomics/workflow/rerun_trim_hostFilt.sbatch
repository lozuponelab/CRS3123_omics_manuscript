#!/bin/bash

#SBATCH --nodes=1 # use one node
#SBATCH --time=10:00:00 # 10h, madi edit: had to up the time so the job wasn't canceled
#SBATCH --account=amc-general # normal, amc, long, mem (use mem when using the amem partition)
#SBATCH --partition=amilan # amilian, ami100, aa100, amem, amc
#SBATCH --qos=normal 
#SBATCH --ntasks=1 # total processes/threads, 
#SBATCH --job-name=weird_cancel_hostFilt
#SBATCH --output=logs/weird_cancel_hostFilt_%J.log
#SBATCH --mem=5G # suffix K,M,G,T can be used with default to M, madi edit: uses <5G 
#SBATCH --mail-user=MADISON.APGAR@CUANSCHUTZ.EDU
#SBATCH --mail-type=FAIL,END
#SBATCH --error=logs/weird_cancel_hostFilt_%J.err

module load miniforge/24.11.3-0
module load singularity/3.6.4
conda activate snake

## may want to add this command to the sbatch script bc if not you have to submit job from within the test_snake_w_slurm dir
## cd /scratch/alpine/mapgar@xsede.org/crestone_shotgun_reanalysis/

## to use with apptainer/referencing singularity containers
## can add to .bashrc
##export SINGULARITY_CACHEDIR=/scratch/alpine/$USER 
##export SINGULARITY_CACHDIR=/scratch/alpine/$USER
##export SINGULARITY_TMPDIR=/scratch/alpine/$USER
##export TMP=/scratch/alpine/$USER
##export TMPDIR=/scratch/alpine/$USER
##export TEMP=/scratch/alpine/$USER
##export TEMPDIR=/scratch/alpine/$USER

snakemake \
    -s workflow/snakefile \
    --configfile workflow/config_files/batchesComb_config.yml \
    --workflow-profile workflow/profiles/default \
    --until run_posttrimming_multiqc \
    --software-deployment-method apptainer \
    --rerun-incomplete
