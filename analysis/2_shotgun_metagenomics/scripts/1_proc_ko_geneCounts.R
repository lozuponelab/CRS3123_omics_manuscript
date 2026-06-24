## wrangling the really big gene counts per KO file from humann
## 7-30-2025
## author: Madi Apgar

#### NOTE! ####
## gene counts are in RPK (RPK=reads per kilobase) which normalizes the counts to gene length. 
## RPK reflects relative gene copy number in the community. 
## These can be further sum-normalized to adjust for differences in sequencing depth across samples. 
###############

## needed libraries
library(tidyverse)
library(dplyr)
library(magrittr)
library(vroom)

## functions
make_ko_table_pretty <- function(input_table,
                                 tax_class=NULL){
  pretty_df <- input_table %>% 
    gather(-gene_family, key = 'sample', value = 'relative_counts') %>% 
    ## remove everything after the first underscore and first colon (grabs sampleids and kos)
    mutate(sampleid = gsub(sample, pattern="_(.*)", replacement=""),
           ko = gsub(gene_family, pattern=":(.*)", replacement=""))
  
  if (tax_class == TRUE) {
    pretty_df <- pretty_df %>% 
      ## pull everything between the first colon and first | (pipe)
      ## replace everything before the first | (pipe) with nothing
      mutate(enzyme_name = str_match(gene_family, ":(.*)\\|")[, 2],
             tax_class = gsub(gene_family, pattern="(.*)\\|", replacement="")) %>% 
      dplyr::select(!c('gene_family', 'sample'))
  } else {
    pretty_df <- pretty_df %>% 
      ## pull everything after the first colon 
      mutate(enzyme_name = str_match(gene_family, ":(.*)")[, 2]) %>% 
      dplyr::select(!c('gene_family', 'sample'))
  }
  return(pretty_df)
}

## file paths
## file not provided due to size 
agg_geneFams_namedKO_fp <- '../data/aggregated/all_genefamilies_namedKO.tsv.gz'

## reading in files (this takes a while)
agg_geneFams_namedKO_raw <- read_tsv(agg_geneFams_namedKO_fp)

## pulling out unmapped and ungrouped reads
## MIGHT NEED TO DO SOMETHING WITH THESE LATER!!!
just_kos_df <- agg_geneFams_namedKO_raw %>% 
  rename(gene_family = `# Gene Family`) %>% 
  filter(!grepl("UNMAPPED|UNGROUPED", gene_family))

## removing large objects so i dont run out of memory
rm(agg_geneFams_namedKO_raw)

## separating results out by whether its overall gene counts or gene counts by taxonomic classification
## has taxonomic classification
withTax_kos_df <- just_kos_df %>% 
  ## pull lines that contain the | (pipe) - contains taxonomic info
  filter(str_detect(gene_family, "\\|"))

proc_withTax_kos_df <- make_ko_table_pretty(input_table = withTax_kos_df,
                                            tax_class = TRUE)

## just overall gene counts (no taxonomic information)
noTax_kos_df <- just_kos_df %>% 
  ## pull lines that dont have the | (pipe) - dont have taxonomic info
  filter(!str_detect(gene_family, "\\|"))

proc_noTax_kos_df <- make_ko_table_pretty(input_table = noTax_kos_df,
                                          tax_class = FALSE)

## write out results as gzipped .tsv files for future use
## files not provided due to size
write_tsv(proc_noTax_kos_df,
          '../data/aggregated/noTax_koCounts.tsv.gz')
write_tsv(proc_withTax_kos_df,
          '../data/aggregated/withTax_koCounts.tsv.gz')
