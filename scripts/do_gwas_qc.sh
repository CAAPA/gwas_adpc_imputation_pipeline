#!/bin/bash

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site>"
    exit
fi
site=$1
in_file_prefix=../data/working/${site}/gwas_common
out_file_prefix=../data/working/${site}/gwas_qc

#remove SNPs with high missingness (>5%), out of HWE (P<10-4), monomorphic SNPs
plink --noweb --bfile $in_file_prefix \
      --maf 0.0001 --geno 0.05 --hwe 0.0001 \
      --mind 0.05 \
      --make-bed --out $out_file_prefix

#report nrs
n_qc_gwas=`wc -l ${out_file_prefix}.fam | tr -s ' ' | cut -f2 -d' '`
echo "n_qc_gwas $n_qc_gwas" >> ../data/output/${site}/flow/flow_nrs.txt
m_qc_gwas=`wc -l ${out_file_prefix}.bim | tr -s ' ' | cut -f2 -d' '`
echo "m_qc_gwas $m_qc_gwas" >> ../data/output/${site}/flow/flow_nrs.txt
m_gwas_hwe=`grep Hardy-Weinberg ${out_file_prefix}.log | cut -f2 -d' '`
echo "m_gwas_hwe $m_gwas_hwe" >>  ../data/output/${site}/flow/flow_nrs.txt
m_gwas_mono=`grep threshold ${out_file_prefix}.log | cut -f1 -d' '`
echo "m_gwas_mono $m_gwas_mono" >>  ../data/output/${site}/flow/flow_nrs.txt
m_gwas_call_rate=`grep "missing genotype" ${out_file_prefix}.log | cut -f1 -d' '`
echo "m_gwas_call_rate $m_gwas_call_rate" >>  ../data/output/${site}/flow/flow_nrs.txt
m_common=`wc -l ${in_file_prefix}.bim | tr -s ' ' | cut -f2 -d' '`
m_bad_gwas=$(($m_common-$m_qc_gwas))
echo "m_bad_gwas $m_bad_gwas" >>  ../data/output/${site}/flow/flow_nrs.txt
