#!/bin/bash

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site> <in_dataset=gwas/adpc> <other_dataset=adpc/gwas>"
    exit
fi
site=$1
in_dataset=$2  #gwas/adpc
other_dataset=$3 #adpc/gwas
work_dir=../data/working/${site}
in_file_prefix=${work_dir}/${in_dataset}_good
out_file_prefix=${work_dir}/${in_dataset}_common

#Extract only those samples in common
cut -f1,2 -d' ' ${work_dir}/${other_dataset}_good.fam > ${work_dir}/overlap_keep.txt
plink --bfile $in_file_prefix \
      --keep  ${work_dir}/overlap_keep.txt \
      --make-bed --out $out_file_prefix

#Output nrs for flow diagram
n_common=`wc -l ${out_file_prefix}.fam | tr -s ' ' | cut -f2 -d' '`
echo "n_common_${dataset} $n_common" >> ../data/output/${site}/flow/flow_nrs.txt
m_common=`wc -l ${out_file_prefix}.bim | tr -s ' ' | cut -f2 -d' '`
echo "m_common_${dataset} $m_common" >> ../data/output/${site}/flow/flow_nrs.txt>> ../data/output/${site}/flow/flow_nrs.txt
