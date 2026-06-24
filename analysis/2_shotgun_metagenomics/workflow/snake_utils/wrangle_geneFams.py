import pandas as pd
import re

def wrangle_geneFams_toSmall(agg_geneFams_fp):
    ##agg_geneFams_raw = pd.read_csv(agg_geneFams_fp, sep="\t")

    ## basic wrangling
    ##agg_geneFams_raw.rename(columns={'# Gene Family': 'gene_family'}, inplace=True)
    ##agg_geneFams_proc = agg_geneFams_raw.melt(id_vars=['gene_family'],
                                              ##var_name='sample',
                                              ##value_name='relative_counts',
                                              ##ignore_index=False).reset_index()
    ##agg_geneFams_proc['sampleid'] = agg_geneFams_proc['sample'].str.replace(r"_(.*)", "", regex=True, flags=re.IGNORECASE)
    ##agg_geneFams_proc['reads_normalized_by'] = 'reads_per_kilobase'
    ##agg_geneFams_proc.drop('sample', axis=1, inplace=True)

    ## pulling all unmapped reads to own df
    ##unmapped_df = agg_geneFams_proc.loc[agg_geneFams_proc['gene_family'] == 'UNMAPPED']
    ##unmapped_df.to_csv('unmapped_genes.tsv', sep="\t")

    ## filtering unmapped reads and uniref ids without taxonomic information out
    ##filt_agg_geneFams = agg_geneFams_proc.loc[agg_geneFams_proc['gene_family'] != 'UNMAPPED']
    ##filt_agg_geneFams = filt_agg_geneFams[filt_agg_geneFams['gene_family'].str.contains(r"[|]", case=False, na=False)]

    filt_agg_geneFams = pd.read_csv(agg_geneFams_fp, sep="\t")
    filt_agg_geneFams[['uniref_id', 'tax_class']] = filt_agg_geneFams['gene_family'].str.split("|", expand=True)
    filt_agg_geneFams.drop('gene_family', axis=1, inplace=True)
    filt_agg_geneFams.to_csv('2taxOnly_genes.tsv', sep="\t")

gene_fams_fp = 'taxOnly_genes.tsv'
wrangle_geneFams_toSmall(agg_geneFams_fp=gene_fams_fp)







    

