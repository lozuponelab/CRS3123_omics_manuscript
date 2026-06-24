## calculates difference between means for a post-hoc pairwise test 
## 7-8-2025
## author: madi apgar

library(dplyr)
library(magrittr)
library(broom)

##### EXAMPLE USEAGE #####
## input_table = dataframe that you put into the pairwise test
## first_group = right hand side variable
## second_group = stratified variable(s)
## mean_value = left hand side variable
## post_hoc_test = pairwise comparisons post hoc test output (with p-value and significance)

## single stratified pairwise comparisons:
## these comparisons were done single stratified by vendor
## with the formula being: microbe_presence ~ diet 
## new_cfu_dunn <- calc_diff_means(input_table = num_cfu_table,
                               ## first_group = 'diet',
                               ## second_group = 'vendor',
                               ## mean_value = 'microbe_presence',
                               ## post_hoc_test = cfu_dunn)

## double stratified pairwise comparisons:
## these comparisons were done double stratified by Genus and day_post_inf
## with the formula being: log_rel_abund ~ exp_vendor
## procMini_d3_genus_relAbun_dunn <- calc_diff_means(input_table = mini_d3_genusAbun_table,
                                                 ## first_group = 'exp_vendor',
                                                 ## second_group = c('Genus', 'day_post_inf'),
                                                 ## mean_value = 'log_rel_abund',
                                                 ## post_hoc_test = mini_d3_genus_relAbun_dunn)

## preps dunns post hoc results for statistical visualization
calc_diff_means <- function(input_table,
                           first_group,
                           second_group,
                           mean_value,
                           post_hoc_test){
  mean_table <- input_table %>% 
    group_by(input_table[first_group], input_table[second_group]) %>%
    summarise(mean = mean(.data[[mean_value]]))
  
  int_post_hoc <- post_hoc_test %>% 
    merge(mean_table, 
          by.x = c('group1',
                   second_group),
          by.y = c(first_group,
                   second_group)) %>%
    rename_with(~paste0('group1_', mean_value, recycle0 = TRUE), contains('mean')) %>% 
    merge(mean_table,
          by.x = c('group2',
                   second_group),
          by.y = c(first_group,
                   second_group)) %>%
    rename_with(~paste0('group2_', mean_value, recycle0 = TRUE), contains('mean'))
  
  group1_col <- paste0('group1_', mean_value)
  group2_col <- paste0('group2_', mean_value)
  
  new_post_hoc <- int_post_hoc %>% 
    mutate(diff_means = (.data[[group1_col]] - .data[[group2_col]]),
           stat_diff_means = if_else(p.value > 0.05, 0, diff_means))
  
  return(new_post_hoc)
}

