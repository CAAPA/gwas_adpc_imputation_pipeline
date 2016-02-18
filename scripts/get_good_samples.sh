#!/bin/bash

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site> <gwas/adpc>"
    exit
fi
site=$1
dataset=$2   #gwas or adpc
work_dir=../data/working/${site}
in_file_prefix=${work_dir}/${dataset}_init
out_file_prefix=${work_dir}/${dataset}_good

#Extract only those samples in the good list
paste ../data/input/manifest_good_sample_list.txt ../data/input/manifest_good_sample_list.txt > \
      ${work_dir}/good_samples_keep.txt
plink --bfile $in_file_prefix --keep  ${work_dir}/good_samples_keep.txt --make-bed --out $out_file_prefix

#Output nrs for flow diagram
n_good=`wc -l ${out_file_prefix}.fam | tr -s ' ' | cut -f2 -d' '`
echo "n_good_${dataset} $n_good" >> ../data/output/${site}/flow/flow_nrs.txt
m_good=`wc -l ${out_file_prefix}.bim | tr -s ' ' | cut -f2 -d' '`
echo "m_good_${dataset} $m_good" >> ../data/output/${site}/flow/flow_nrs.txt
n_init=`wc -l ${in_file_prefix}.fam | tr -s ' ' | cut -f2 -d' '`
n_bad=$(($n_init-$n_good))
echo "n_bad_${dataset} $n_bad" >> ../data/output/${site}/flow/flow_nrs.txt
