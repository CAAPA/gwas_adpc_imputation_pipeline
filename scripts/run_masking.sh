#!/bin/bash

rm -r ../data/output/masked
mkdir ../data/output/masked

bash update_adpc_pos.sh ../data/input/adpc ../data/output/masked/adpc
rm ../data/output/masked/adpc.bed
rm ../data/output/masked/adpc.fam

cat get_snps_to_mask.R | R --vanilla

bash mask_gwas_snps.sh jhu_abr
bash mask_gwas_snps.sh washington
bash mask_gwas_snps.sh ucsf_pr
