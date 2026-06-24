## combining all metaphlan bugs list .tsv files into one and making the file pretty for downstream analysis
## 09-04-2025
## author: Madi Apgar

#### NOTE! ####
## the amounts in this file are already in relative abundances and broken down per taxa level 
## (i.e. if you add up all relative abundances of found genera per sample, it will equal 100,
## and the same goes for each taxa level)
## if you only want a certain taxa level, filter for everything that isn't NA in that column 
###############

## needed libraries
library(tidyverse)
library(dplyr)
library(magrittr)
library(vroom)

## file not provided due to size
bug_list <- Sys.glob("../data/aggregated/bugs_list/*_metaphlan_bugs_list.tsv")

## column name list used for splitting the full taxonomic string and creating several columns (wide format)
tax_cols <- c('kingdom',
              'phylum',
              'class',
              'order',
              'family',
              'genus',
              'species',
              'speciesLevel_genome_bin')

bug_out <- tibble()
for(bug in unique(unlist(bug_list))){
  ## pulling upper file path off of file name via basename() and replacing the file suffix with nothing
  ## so i can get all sample ids 
  get_sampleName <- gsub(basename(bug), pattern = "_metaphlan_bugs_list.tsv", replacement = "")
  
  ## skip top 4 lines of .tsv file bc it causes formatting problems
  ## and just includes the command run to create the file 
  file <- read_tsv(bug,
                   skip = 4) %>% 
    mutate(sampleid = paste(get_sampleName)) %>% 
    rename(clade_name = `#clade_name`) %>% 
    separate_wider_delim(cols = clade_name,
                         delim = "|",
                         names = tax_cols,
                         too_few = "align_start",
                         cols_remove = FALSE) %>% 
    select(sampleid, relative_abundance, everything()) %>%
    ## iterate across all the taxa columns and replace everything before/including the first two underscores
    ## with nothing 
    mutate(across(all_of(tax_cols), ~gsub(pattern = "^([^_])*_*_", replacement = "", .)))
  
  ## combine all tables for samples 
  bug_out <- bind_rows(bug_out, file)
}

## writing out final combined file for downstream analysis!
## files not provided due to size
write_tsv(bug_out, 
          '../data/aggregated/all_bugs_list.tsv')

