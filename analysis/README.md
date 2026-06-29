# Analysis

Documents the different types of analysis done for the manuscript and why. See the individual READMEs for further information. 

## General pointers

- Scripts without numbers are not reliant on outputs from other scripts and can be run in whatever order 
- The upstream data processing workflow needs to be run prior to any R scripts for 16S rRNA and shotgun metagenomcis analysis
- Script input files are not provided for shotgun metagenomics since they're too large to commit to this repository (see it's [README](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/2_shotgun_metagenomics/README.md) for further information)

## Scripts
The following R scripts contain statistical functions commonly used in the overall analysis. See below for more detailed information on their contents. 

- [`art_lmer_functions.R`](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/art_lmer_functions.R): performs aligned rank transformed non-parametric pairwise testing and contrasts 
- [`diff_between_means_calc.R`](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/diff_between_means_calc.R): calculates the difference between means for two given variables 
- [`normality_function.R`](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/normality_function.R): tests normality of the data 
- [`test_lmer_vars_function.R`](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/test_lmer_vars_function.R): tests effects of fixed variables on a linear mixed effects model