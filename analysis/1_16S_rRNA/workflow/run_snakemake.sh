#!/bin/bash

## command (example) to run my snakemake workflow
snakemake \
    -s workflow/snakefile \
    -c 7 \
    --use-conda \
    --keep-going \
    --configfile workflow/config_files/config_crestone_abx.yml