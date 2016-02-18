#!/bin/bash

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site>"
    exit
fi
site=$1
in_file_prefix=../data/working/${site}/adpc_common
out_file_prefix=../data/working/${site}/adpc_qc

#remove SNPs with high missingness (>5%), out of HWE (P<10-4), monomorphic SNPs
plink --noweb --bfile $in_file_prefix \
      --exclude ../data/input/ADPC_SNPs_flagged_markers.txt \
      --maf 0.0001 --geno 0.05 --hwe 0.0001 \
      --make-bed --out $out_file_prefix

#report nrs
n_qc_adpc=`wc -l ${out_file_prefix}.fam | tr -s ' ' | cut -f2 -d' '`
echo "n_qc_adpc $n_qc_adpc" >> ../data/output/${site}/flow/flow_nrs.txt
m_qc_adpc=`wc -l ${out_file_prefix}.bim | tr -s ' ' | cut -f2 -d' '`
echo "m_qc_adpc $m_qc_adpc" >> ../data/output/${site}/flow/flow_nrs.txt
m_adpc_hwe=`grep Hardy-Weinberg ${out_file_prefix}.log | cut -f2 -d' '`
echo "m_adpc_hwe $m_adpc_hwe" >>  ../data/output/${site}/flow/flow_nrs.txt
m_adpc_mono=`grep threshold ${out_file_prefix}.log | cut -f1 -d' '`
echo "m_adpc_mono $m_adpc_mono" >>  ../data/output/${site}/flow/flow_nrs.txt
m_adpc_call_rate=`grep "missing genotype" ${out_file_prefix}.log | cut -f1 -d' '`
echo "m_adpc_call_rate $m_adpc_call_rate" >>  ../data/output/${site}/flow/flow_nrs.txt
m_common=`wc -l ${in_file_prefix}.bim | tr -s ' ' | cut -f2 -d' '`
m_bad_adpc=$(($m_common-$m_qc_adpc))
echo "m_bad_adpc $m_bad_adpc" >>  ../data/output/${site}/flow/flow_nrs.txt
m_after_excl=`grep "variants remaining"  ${out_file_prefix}.log | cut -f2 -d' '`
m_bad_cluster=$(($m_common-$m_after_excl))
echo "m_bad_cluster $m_bad_cluster" >> ../data/output/${site}/flow/flow_nrs.txt
