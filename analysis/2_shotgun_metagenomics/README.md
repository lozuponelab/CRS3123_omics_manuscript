# Shotgun Metagenomic Analysis of Fecal Samples
**Purpose of this analysis**

- to measure changes in microbiome functional potential (and taxa contributing to them) between baseline (day 1) and test-of-cure (TOC) for the different treatment groups 

> [!CAUTION]
> **Please pay attention to the following caveats:** <br/> <br/> **1. The [upstream data processing workflow](#data-processing-workflow) *MUST BE RUN* before any of the R scripts below! The input files for those scripts *are NOT provided* due to size limitations and will need to be regenerated.** <br/> <br/> **2. [Analysis script](https://github.com/lozuponelab/CRS3123_omics_manuscript/tree/main/analysis/2_shotgun_metagenomics/scripts) numbering *MUST BE FOLLOWED* to produce the input files required!** 

## Manuscript relevance
Manuscript figures generated from the contents of this directory:

- Figure 4a-c 
- Supplemental Figure 7a-b

> [!IMPORTANT]
> The overall metadata file is [located here](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/data_submission/1_16S_rRNA_qiita/CRS3123_fecal_samples/crestone_qiita_sample_information.tsv)

| Figure | Associated Scripts | Plot Names |
|----------|----------|----------|
| Figure 4a-c   | a-c: [`scripts/3b_ko_gsea_analysis.Rmd`](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/2_shotgun_metagenomics/scripts/3b_ko_gsea_analysis.Rmd)  | a: `toc_gsea_plot` <br/> b: `bile_acid_path_plot`  <br/> c: `bile_acid_path_wTax`  |
| Supplemental Figure 7a-b   | a: [`scripts/3a_generate_tax_biplot.Rmd`](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/2_shotgun_metagenomics/scripts/3a_generate_tax_biplot.Rmd) <br/> b: [`scripts/3b_ko_gsea_analysis.Rmd`](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/2_shotgun_metagenomics/scripts/3b_ko_gsea_analysis.Rmd) | a: `shotgun_wu_biplot_1to2` <br/> b: `d1_gsea_plot` |

## Data processing workflow
Similar to the 16S rRNA data analysis, a separate [Snakemake](https://snakemake.readthedocs.io/en/stable/) workflow was built to process the shotgun metagenomics sequencing data which can be found [here](https://github.com/lozuponelab/CRS3123_omics_manuscript/tree/main/analysis/2_shotgun_metagenomics/workflow). 

> [!WARNING]
> I wrote this workflow solely to process the shotgun metagenomics FASTQ files and I am the only one who has ever run it. That being said, it's a bit less put together than the 16S rRNA workflow and I would **_highly recommend_** that anyone who tries to run this exact workflow be **_extremely familiar and comfortable_** with the following: <br/> <br/> - snakemake (v8+) <br/> - running jobs in HPCs with slurm <br/> - docker/singularity <br/> - working with large output files <br/> <br/> On that note, I would **_also highly recommend_** that this entire workflow be run in an HPC setting due to space and computational requirements!!

### Table of Contents

[Workflow steps](#workflow-steps)

[Workflow directory auxillary files](#workflow-directory-auxillary-files)

[How it runs](#how-it-runs)

[Relevant outputs](#relevant-outputs)


### Workflow steps
The following is a high-level overview of the workflow including the software tools used, why, and if they have any required reference files/databases. 

| Step | Tools Used | Purpose | References |
|----------|----------|----------|----------|
| 1    | [FastQC](https://github.com/s-andrews/fastqc)/[MultiQC](https://github.com/multiqc/multiqc)     | pretrimming sequence quality control      | none |
| 2    | [BBDuk](https://archive.jgi.doe.gov/data-and-tools/software-tools/bbtools/bb-tools-user-guide/bbduk-guide/)     | sequence adapter trimming     | none (BBDuk has prebuilt adapters file) |
| 3    | [BBSplit](https://archive.jgi.doe.gov/data-and-tools/software-tools/bbtools/bb-tools-user-guide/bbmap-guide/)     | align sequences to host genome (human) to filter out host reads (splice-aware aligner)     | Hg38-p14.fasta | 
| 4    | [FastQC](https://github.com/s-andrews/fastqc)/[MultiQC](https://github.com/multiqc/multiqc)     | sequence quality control post adapter trimming and host-read filtering     | none |
| 5    | [HUMAnN/MetaPhlAn](https://github.com/biobakery/humann#humann-user-manual)     | calculate gene counts (HUMAnN) and perform taxonomic assignment (MetaPhlAn)     | **requires the following HUMAnN databases to be [installed](https://github.com/biobakery/humann#5-download-the-databases):** <br/> - MetaPhlAn <br/> - ChocoPhlAn <br/> - UniRef90 (diamond) <br/> - Utility Mapping |


### Workflow directory auxillary files
You'll notice that the `workflow` directory contains several additional subdirectories/files besides the main `snakefile`. 

- `config_files`: gives snakemake required input filepaths - must be filled out/updated by the user!
- `envs`: conda environment .yml files to install the needed software tools (NOTE: can use docker images instead)
- `profiles`: contains the slurm profile for the workflow - can be adapted by user
- `snake_utils`: python functions used by the workflow
- `run_shotgunMeta_workflow.sbatch`: example slurm script for how to run the workflow 
- `shotgun_metaG_metadata.csv`: metadata file used as an input for the workflow

### How it runs 
Since I don't have this workflow wrapped up nearly as well as the 16S rRNA workflow, fully running it on your own is a bit more involved. I have written out a step-by-step guide below in hopes that it will clarify the process. 

> [!NOTE]
> The following instructions are compatible with Linux and Mac OS and have not been tested on Windows!

#### **1. If you haven't already, start with [cloning this GitHub repository](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/1_16S_rRNA/workflow/tutorial/tutorial.md#cloning-the-github-repository). Then, navigate to this directory:**

```bash
cd ~/CRS3123_omics_manuscript/analysis/2_shotgun_metagenomics
```

#### **2. Install the Snakemake conda environment:**

```bash
conda env create -f workflow/envs/snake_env.yml
```

> [!WARNING]
> This workflow can be run using conda environment `.yaml` files or Docker images (prebuilt [here](https://hub.docker.com/repository/docker/madiapgar/shotgun_meta/general)). Running using Docker images is a great choice if you're using Linux OS (HPCs included) but **_is not supported_** in Mac/Windows OS since Snakemake requires `apptainer`/`singularity` to be installed! <br/> <br/> If you're planning to run this workflow with the Docker images, you'll also need to install `apptainer` into your Snakemake conda environment (`snake`). _Caveat: If you're running this workflow in an HPC, `apptainer`/`singularity` may already be installed._ 


#### **3. Install the HUMAnN conda environment and associated reference databases:**

> [!IMPORTANT]
> These reference databases are large and take a good amount of computational power to download/install. It is recommended that these steps are performed in an HPC setting. 

- Install and activate the `humann` conda environment

```bash
## install humann from prebuilt conda env yaml file - this is recommended to keep versioning consistent
conda env create -f workflow/envs/humann_env.yaml

## activate the environment once its created
conda activate humann

## create humann_refs directory
mkdir humann_refs
``` 

**Reference databases:**

- MetaPhlAn `mpa_vJun23_CHOCOPhlAnSGB_202307` database

```bash
## make directory for metaphlan refs  they have any required reference files/databases. 
mkdir -p humann_refs/metaphlan_jun23

## install metphlan refs - MUST match the version of humann/metaphlan installed
metaphlan --install --bowtie2db humann_refs/metaphlan_jun23 --index mpa_vJun23_CHOCOPhlAnSGB_202307
```

- ChocoPhlAn database

```bash
## make directory for chocophlan refs 
mkdir -p humann_refs/chocophlan

## download chocophlan refs 
humann_databases --download chocophlan full humann_refs/chocophlan --update-config yes 
```

- Uniref90 database

```bash
## make a directory for uniref refs 
mkdir -p humann_refs/uniref90_diamond

## download uniref90 diamond refs
humann_databases --download uniref uniref90_diamond humann_refs/uniref90_diamond --update-config yes 
```

- Utility Mapping database

```bash
## make a directory for utility mapping refs
mkdir -p humann_refs/utility_mapping

## download utility mapping refs 
humann_databases --download utility_mapping full humann_refs/utility_mapping --update-config yes 
```

#### **4. Update the config file (located at [`workflow/config_files/shotgun_meta_config.yml`](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/2_shotgun_metagenomics/workflow/config_files/shotgun_meta_config.yml)) to reflect the locations of reference databases and raw FASTQs:**

> [!NOTE]
> I've included the metadata file I used on the samples for this analysis [here](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/2_shotgun_metagenomics/workflow/shotgun_metaG_metadata.csv)! If you are pulling the FASTQs from EBI-ENA, **_you will need to update_** the FASTQ file names under the `forward_reads` and `reverse_reads` columns. <br/> <br/> **TAKE NOTE:** The metadata file can also be edited in any way that will help your analysis of these samples and will work with this workflow **_as long as the column names are not changed_**!

```yaml
raw_seq_in: 'crs3123_shotgunMeta_raw_seqs' ## directory where raw sequencing FASTQs are located - MUST be a subdirectory of 2_shotgun_metagenomics/
metadata_file: 'workflow/shotgun_metaG_metadata.csv' ## has to be a .csv or it will break
filter_to_fasta: 'hg38.p14.fa' ## USERS: this will need to be downloaded 

## preinstalled database file paths:
metaphlan_db: 'humann_refs/metaphlan_jun23/'
metaphlan_index_name: 'mpa_vJun23_CHOCOPhlAnSGB_202307' ## the name of the metaphlan index installed
chocophlan_db: 'humann_refs/chocophlan/'
uniref_db: 'humann_refs/uniref90_diamond/'
utility_mapping_db: 'humann_refs/utility_mapping/'
```

#### **5. Verify that the [slurm profile](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/2_shotgun_metagenomics/workflow/profiles/default/config.yaml) and [sbatch script](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/2_shotgun_metagenomics/workflow/run_shotgunMeta_workflow.sbatch) are compatible with your HPC:**

I have already (mostly) optimized the slurm resource requests for this workflow and they are included in the slurm profile on this repository. These resource requests can also be easily edited directly in the slurm profile if needed for specific jobs. Since I used CURC's Alpine HPC to run this workflow, the `slurm_partition` and `slurm_account` fields (lines 7-9) of this profile may need to be changed to be compatible with the HPC you are using to run this analysis. 

```yaml
default-resources:
    slurm_partition: "amilan" ## CHANGE ME!!!!
    slurm_account: "amc-general" ## CHANGE ME!!!!
```

I also included an example slurm sbatch script on this repository that includes the commands to actually run the entire workflow once you have everything set up. Additional information on what may need to be changed in this sbatch script is featured below. 

> [!NOTE]
> Since this workflow can run its associated software tools with conda or `apptainer`/`singularity`, you will need to update the Snakemake `--software-deployment-method` flag to either conda (for conda execution) or apptainer (for `apptainer`/`singularity` execution of Docker images).

```bash
#!/bin/bash

#SBATCH --nodes=1 # use one node
#SBATCH --time=10:00:00 # 10h - note: if you're running the full workflow, I'd set this to 23h
#SBATCH --account=amc-general # normal, amc, long, mem (use mem when using the amem partition) - ALPINE HPC SPECIFIC
#SBATCH --partition=amilan # amilian, ami100, aa100, amem, amc - ALPINE HPC SPECIFIC    
#SBATCH --qos=normal 
#SBATCH --ntasks=1 # total processes/threads, 
#SBATCH --job-name=crs3123_shotgun_metaG
#SBATCH --output=crs3123_shotgun_metaG_%J.log
#SBATCH --mem=5G # suffix K,M,G,T can be used with default to M, madi edit: uses <5G 
#SBATCH --mail-user=YOUREMAIL@CUANSCHUTZ.EDU
#SBATCH --mail-type=FAIL,END
#SBATCH --error=crs3123_shotgun_metaG_%J.err

## loading modules is specific to Alpine HPC - check your HPCs documentation 
module load miniforge/24.11.3-0
module load singularity/3.6.4

## activate the snakemake conda environment that we created earlier 
conda activate snake

## move into CRS3123_omics_manuscript/analysis/2_shotgun_metagenomics - edit based on where you cloned the repository
cd ~/CRS3123_omics_manuscript/analysis/2_shotgun_metagenomics

## to use with apptainer/referencing singularity containers - THIS IS ALPINE SPECIFIC
## uncomment the following lines if you desire to run the workflow in Alpine HPC with docker images instead of conda 
#export SINGULARITY_CACHEDIR=/scratch/alpine/$USER 
#export SINGULARITY_CACHDIR=/scratch/alpine/$USER
#export SINGULARITY_TMPDIR=/scratch/alpine/$USER
#export TMP=/scratch/alpine/$USER
#export TMPDIR=/scratch/alpine/$USER
#export TEMP=/scratch/alpine/$USER
#export TEMPDIR=/scratch/alpine/$USER

snakemake \
    -s workflow/snakefile \ ## location of the snakefile (this should stay the same)
    --configfile workflow/config_files/shotgun_meta_config.yml \ ## location and name of the config file
    --workflow-profile workflow/profiles/default \ ## path to the slurm profile (this should stay the same)
    --software-deployment-method apptainer \ ## do you want to run this workflow with conda or docker images (apptainer)?
    --rerun-incomplete \ ## reruns jobs that error out prematurely 
    --keep-going ## tells other jobs to keep going if others fail 
    ##--dry-run ## include this line to dry run the workflow 
```

#### **6. Run the workflow!**

Once the conda environments and reference databases are installed and the information in the the config, metadata CSV, slurm profile, and sbatch scripts is updated, the workflow can be run! I would recommend performing some initial dry runs to verify that all inputs are formatted correctly prior to fully running the workflow. 

### Relevant outputs 
The workflow gives you several important output files but only a few of them were used for the downstream R analysis featured in the manuscript. These relevant output files fall in two categories: **1.** KEGG Orthology gene counts (for all samples) and **2.** MetaPhlAn per-sample taxonomic assignment.

**1. KEGG Orthology gene counts:**

Located at `shotgun_meta_out/humann/aggregated/all_genefamilies_namedKO.tsv` after workflow completion, this file of KO gene counts for all samples is the input for [`scripts/1_proc_ko_geneCounts.R`](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/2_shotgun_metagenomics/scripts/1_proc_ko_geneCounts.R), an overall data wrangling script that breaks the results into two different files (mainly to decrease file size so your R doesn't crash): `noTax_koCounts.tsv.gz` and `withTax_koCounts.tsv.gz`.

**2. Per-sample taxonomic assignment:** 

Located at `shotgun_meta_out/humann/sampleID/sampleID_humann_temp/sampleID_metaphlan_bugs_list.tsv` after workflow completion, these per-sample bug lists are an input for [`scripts/2_proc_metaphlan_bugsList.R`](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/2_shotgun_metagenomics/scripts/2_proc_metaphlan_bugsList.R) that concatenates them all together into one file named `all_bugs_list.tsv`.

