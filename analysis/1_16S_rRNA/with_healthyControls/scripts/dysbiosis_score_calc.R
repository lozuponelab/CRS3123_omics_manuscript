## 1-22-2026
## written by: madi apgar
## function to calculate average distance between a test sample and all control samples ##

## install rio package if not installed already
if (!requireNamespace("rio", quietly = TRUE)){install.packages("rio")}


#### EXAMPLE USAGE ####
## read in the calc_dysbiosis_score function and all required libraries 
# source("dysbiosis_score_calc.R")

## storing file paths to distance matrix/metadata as variables
# qza_test_fp <- "unweighted_unifrac_distance_matrix.qza"
# meta_fp <- "meta.tsv"

## running the calc_dysbiosis_score() function
## outputs a dataframe similar to below - the `av_dist_to_control` col contains your "score"
# calc_dysbiosis_score(metadata_fp = meta_fp, ## path to metadata file 
#                      sample_col_name = "sampleid", ## name of the column with all your sample ids
#                      control_sample_pattern = "HC", ## a sample id pattern to identify control/comparison samples (mine have "HC" in them)
#                      dist_matrix_fp = qza_test_fp) ## path to your distance matrix (can be a qza, tsv, or csv)
########################

## needed libraries
library(tidyverse)
library(magrittr)
library(broom)
library(rio)
library(qiime2R)

## function
calc_dysbiosis_score <- function(metadata_fp, ## path to your metadata file
                                 sample_col_name, ## the column name for your sample ids 
                                 control_sample_pattern, ## a string pattern to distinguish control sample ids (i.e. "blank" or "HC")
                                 dist_matrix_fp){ ## path to your distance matrix 
  ## metadata 
  metadata_file <- rio::import(metadata_fp)
  
  ## distance matrix
  extension <- tools::file_ext(dist_matrix_fp)
  
  if(extension != "qza"){
    dist <- rio::import(dist_matrix_fp)
    names(dist)[names(dist) == 'V1'] <- sample_col_name
  } else {
    pre_dist <- as.matrix(qiime2R::read_qza(dist_matrix_fp)$data)
    dist <- as.data.frame(pre_dist) %>% 
      rownames_to_column(var = sample_col_name)
  }
  
  proc_dist <- dist %>% 
    ## take dist matrix from wide to long format 
    gather(-all_of(sample_col_name), key = comp_sample_col, value = dist) %>% 
    ## make sure that all sampleids from distance matrix match the metadata
    filter(if_any(c(sample_col_name, 'comp_sample_col'), ~ . %in% metadata_file[[sample_col_name]])) %>% 
    ## filtering to just include control sample distances 
    filter(str_detect(comp_sample_col, control_sample_pattern)) %>% 
    ## grouping by sampleid so average is done on a per-sample basis 
    group_by(.data[[sample_col_name]]) %>% 
    ## calculating average distance of each sample from the controls 
    summarise(av_dist_to_control = mean(dist)) %>% 
    ## combining with metadata to easily create plots/run stats 
    left_join(metadata_file, by = sample_col_name)
  
  return(proc_dist)
}


