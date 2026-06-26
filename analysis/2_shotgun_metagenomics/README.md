# Shotgun Metagenomic Analysis of Fecal Samples
**Purpose of this analysis**

- to measure changes in microbiome functional potential (and taxa contributing to them) between baseline (day 1) and test-of-cure (TOC) for the different treatment groups 

> [!CAUTION]
> The [upstream data processing workflow](#data-processing-workflow) **must be run** before any of the R scripts below! <br/> <br/> The input files for those scripts **are NOT provided** due to size limitations and will need to be regenerated.

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
madi still needs to write a tutorial for this :(

