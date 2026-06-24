## wrangling the really big unnamed gene counts table from humann
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

## file paths
## file not provided due to size
agg_geneFams_fp <- '../data/aggregated/all_genefamilies.tsv.gz'

## reading in file (this takes a loooong time)
agg_geneFams_raw <- read_tsv(agg_geneFams_fp)

## split up data wrangling line by line and overwrote the same variable to decrease memory consumption
## use garbage collection command to reclaim unused memory periodically 
gc()

## renaming gene family column to be r-friendly
agg_geneFams_proc <- rename(agg_geneFams_raw, gene_family = `# Gene Family`) 

## removing large object so I dont take up as much space
rm(agg_geneFams_raw)

## decreasing df size by filterting out unmapped and duplicated reads
agg_geneFams_proc <- filter(agg_geneFams_proc, gene_family != 'UNMAPPED')
agg_geneFams_proc <- filter(agg_geneFams_proc, str_detect(gene_family, "\\|"))

## going from wide to long format
agg_geneFams_proc <- gather(agg_geneFams_proc, -gene_family, key = 'sample', value = 'relative_counts')

## pulling sampleids out and adding info on normalization process
agg_geneFams_proc <- agg_geneFams_proc %>% 
  ## "_(.*)" means replace everything after the first underscore (with nothing)
  mutate(sampleid = gsub(sample, pattern="_(.*)", replacement=""),
         reads_normalized_by = paste('reads_per_kilobase')) %>%
  select(-sample)

## should I filter out the zeros? - filtering out the zero counts to decrease size
agg_geneFams_proc <- filter(agg_geneFams_proc, relative_counts != 0)

## splitting the gene family column into the uniref id and taxonomic info
agg_geneFams_proc <- separate_wider_delim(agg_geneFams_proc, 
                                          cols = 'gene_family',
                                          delim = '|',
                                          names = c('uniref_id', 'tax_class'))

## splitting uniref id column so I can map it back to kegg ids
agg_geneFams_proc <- separate_wider_delim(agg_geneFams_proc,
                                          cols = 'uniref_id',
                                          delim = '_',
                                          names = c('uniref_ver', 'uniref_id'))

## writing file to gzipped format so it doesn't take up as much space 
## file not provided due to size
write_tsv(agg_geneFams_proc,
          '../data/aggregated/all_geneFams_proc.tsv.gz')

## reclaim unused memory from r again 
gc()