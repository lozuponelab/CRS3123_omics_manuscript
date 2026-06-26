# 16S rRNA Sequencing of Fecal Samples
**Purpose of this analysis**

- to measure microbiome changes over time within and between the different treatment groups (characterized via alpha/beta diversity metrics and relative abundances of assigned taxa)

## Manuscript relevance
Manuscript figures generated from the contents of this directory:

- Figure 2a-b
- Figure 3a-c
- Supplemental Figure 5a-c
- Supplemental Figure 6a-d

> [!IMPORTANT]
> Input files to run the scripts noted below are in the `data` subdirectories and the overall metadata file is [located here](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/data_submission/1_16S_rRNA_qiita/CRS3123_fecal_samples/crestone_qiita_sample_information.tsv)

| Figure | Associated Scripts | Plot Names |
|----------|----------|----------|
| Figure 2a-b    | a: [`no_healthyControls/scripts/alpha_div.Rmd`](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/1_16S_rRNA/no_healthyControls/scripts/alpha_div.Rmd) <br/> b: [`with_healthyControls/scripts/dysbiosis_score.Rmd`](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/1_16S_rRNA/with_healthyControls/scripts/dysbiosis_score.Rmd)     | a: `faith_plot_wStats` <br/> b: `wu_dist_plot`    |
| Figure 3a-c    | a-c: [`no_healthyControls/scripts/taxonomy.Rmd`](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/1_16S_rRNA/no_healthyControls/scripts/taxonomy.Rmd) | a: `fig3a_plot` <br/> b: `fig3b_plot` <br/> c: `fig3c_plot` |
| Supplemental Figure 5a-c    | a-b: [`no_healthyControls/scripts/alpha_div_deltas.Rmd`](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/1_16S_rRNA/no_healthyControls/scripts/alpha_div_deltas.Rmd) <br/> c: [`with_healthyControls/scripts/beta_div.Rmd`](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/1_16S_rRNA/with_healthyControls/scripts/beta_div.Rmd)  | a: `d1_toc_deltas_plot` <br/> b: `d40_toc_deltas_plot` <br/> c: `weighted_pcoa_plot`     |
| Supplemental Figure 6a-d    | a-c: [`no_healthyControls/scripts/taxonomy.Rmd`](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/1_16S_rRNA/no_healthyControls/scripts/taxonomy.Rmd) <br/> d: [`no_healthyControls/scripts/tax_biplot_crs.Rmd`](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/1_16S_rRNA/no_healthyControls/scripts/tax_biplot_crs.Rmd) | a: `genusAbun_treatGroup_strat_heatPlot` <br/> b: `buty_abun_plot` <br/> c: `buty_treatGroup_strat_heatPlot` <br/> d: `wu_biplot_facet` |

## Data processing workflow
[Snakemake](https://snakemake.readthedocs.io/en/stable/) was used to streamline and ensure reproducibility of the basic [QIIME2](https://qiime2.org/) 16S rRNA sequencing data processing workflow, producing the files used in the scripts above. The same workflow was used for analyses with/without healthy control samples. 

> [!NOTE]
> **Additional instructions on running the workflow are included in the [tutorial](https://github.com/lozuponelab/CRS3123_omics_manuscript/blob/main/analysis/1_16S_rRNA/workflow/tutorial/tutorial.md).**


