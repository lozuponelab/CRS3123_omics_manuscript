# Fecal Immune Analysis
***Purpose of this analysis***
  - Fecal soluble immune factors were profiled longitudinally to explore differences over time and between treatment groups

## Scripts
### 1_cp_lf_plotting.Rmd
Performs data wrangling for calprotectin (cp) and lactoferrin (lf) data obtained by ELISA separately from the multiplex assays used for all other immune products. 
Output of wrangled data serves as input for `2_immune_data_processing.Rmd` following wrangling and censoring of all multiplex cytokine data. 
Statistical analysis of cp and lf by ART linear models: effect of treatment on concentration stratified by visit, effect of visit and subject on concentration stratified by treatment.

Inputs: 
  - `../data/calprotectin_results.txt`
  - `../data/lactotransferrin_results.txt`
  - `../data/proc_seq_metadata.tsv`
  - `../data/subject_info.tsv`

Outputs:
  - `../results/processed_cp_lf_data.csv`
<br><br>
### 2_immune_data_processing.Rmd
Performs data wrangling for the two multiplex cytokine panels. Censoring involved using LLOD/2 for all values below the lower limit of detection (LLOD) 
and ULOD (upper limit of detection) for all values above the ULOD. Produces table with total number of samples whose values were censored using this 
scheme (numbers and percentages obove ULOD or below LLOD). ART linear models on all 20 cytokines from multiplex panels (same analyses as cp_lf_plotting script). 

Inputs: 
  - `../data/BCA_total_protein.xlsx`
  - `../data/cytokine_panel_1.xlsx`
  - `../data/proinflamm_cytokine_panel_1.xlsx`
  - `../results/processed_cp_lf_data.csv`
  - `../data/BCA_total_protein.xlsx`
  - `../data/proc_seq_metadata.tsv`
  - `../data/subject_info.tsv`
  - `../data/clinical_metadata.txt`
  - `../data/ULOD_cytokines.xlsx`
  - `../data/LLOD_cytokines.xlsx`
  - `../data/cytokine_subj_plates.xlsx`

Outputs:
  - `../results/merged_censored_immune_markers.csv`
  - `../plots/proinflamm_cytokines_over_time_treatment.png`
  - `../plots/cytokines_over_time_plot.png`
    
<br><br>
### 3_immune_stats.Rmd
ART lmer on all cytokines, cp, and lf. Visualizes visit stratified ART lmer results significant between treatments. 
Calculates differences between means to determine directionality and magnitude of differences and plots as heat map for all cytokines (Fig S9). 
Because IL-1b and calprotectin were significantly different between vancomycin and CRS treatments, these were plotted over time with visit comparisons stratified by treatment group (Fig 7a). 
The Figure S9 heatmap was filtered for only Il-1b and calprotectin (Fig. 7b) 


Input:
  - `../results/merged_censored_immune_markers.csv`

Outputs:
  - `../plots/treatment_group_pairwise_heatmap.png`
  - `../../../figures/ggplots/figS9b_imm_stats.rdat`
  - `../plots/treatment_group_il1b_cp_pairwise_heatmap.png`
  - `../../figures/ggplots/fig7_cp_il1b_stats.rdat`
  - `../plots/il1b_cp_by_treat.png`
  - `../../../figures/ggplots/fig7a_cp_il1b.rdat`
<br><br>

### 4_sIF_pcoa.Rmd
Performs median normalization, computes Canberra distance matrix, PCoA, 
fits cytokines as vectors based on their correlation with PC axes (envfit, 999 permutations, BH correction), 
PERMANOVA on distance matrix via Adonis2 (999 permutations, by = 'margin') with all timepoints and with all during/post-treatment timepoints, 
and pairwise PERMANOVA comparisons between each pair of treatment groups (with and without Screen and D1 samples)

Input: 
  - `../results/merged_censored_immune_markers.csv`

Output: 
  - `../results/sif_norm_median_table.tsv`
  - `../results/sif_sample_metadata.tsv`
  - `../plots/sIF_pcoa.pdf`
  - `../plots/sIF_pcoa.png`
  - `../../../figures/fig7a_sif_pcoa.rdat`
  - `../results/sif_norm_long_w_metadata`


