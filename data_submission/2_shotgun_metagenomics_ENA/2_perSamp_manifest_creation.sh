#!/bin/bash

input="for_all_sample_manifest.tsv"
outdir="crestone_ebi_perSample_manifests"

## make output directory (if not exists already)
mkdir -p "$outdir"

## reads the header, splits columns by tabs and stores them in an array named "cols"
IFS=$'\t' read -r -a cols < "$input"
## pull end of line return character off of col names
for i in "${!cols[@]}"; do
  cols[i]="${cols[i]//$'\r'/}"
done

## finds which column index matches NAME (sampleids)
name_index=-1
## first line in for-loop expands all column indices in array so can loop through them 
## then finds the exact index for the sampleid (to use later)
for i in "${!cols[@]}"; do
  if [[ "${cols[i]}" == "NAME" ]]; then
    name_index=$i
    break
  fi
done

## throw an error if the NAME column doesnt exist
if [[ $name_index -lt 0 ]]; then
  echo "ERROR: NAME column not found" >&2
  exit 1
fi

## skip the header and start reading in row data and place into an array named "values"
## [[ "${#values[@]}" -gt 0 ]] :makes sure the last line of the file is still read correctly even if it doesnt end in a \n 
## store outfile name with correct sampleid 
tail -n +2 "$input" | while IFS=$'\t' read -r -a values || [[ "${#values[@]}" -gt 0 ]]; do
  ## pull return character off of values 
  for i in "${!values[@]}"; do
    values[i]="${values[i]//$'\r'/}"
  done

  name="${values[name_index]}"
  safe_name=$(printf '%s' "$name" | tr '/\\' '__')
  out_file="$outdir/${safe_name}_manifest.txt"

  {
    ## once again expand all column indices in the array 
    for i in "${!cols[@]}"; do
      ## pull the col name from the array as "label"
      label="${cols[i]}"
      ## change both FASTQ cols to just say "FASTQ" but retain their order
      if [[ "$label" == "FASTQ1" || "$label" == "FASTQ2" ]]; then
        label="FASTQ"
      fi
      ## print the first string, a tab, then a second string, and a newline so next entry goes to a new line
      printf '%s\t%s\n' "$label" "${values[i]}"
    done
  } > "$out_file"
done
