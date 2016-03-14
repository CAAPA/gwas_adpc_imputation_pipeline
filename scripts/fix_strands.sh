#!/bin/bash -x

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site> <gwas/adpc>"
    exit
fi
site=$1
dataset=$2 #gwas/adpc
fix_at_cg_file_prefix=../data/working/${site}/${dataset}_fixed_AT_CG
out_file_prefix=../data/working/${site}/${dataset}_flipped

#Get the list of SNPs to flip
stats_file=../data/output/${site}/statistics/${dataset}_statistics.txt
flip_file=../data/working/${site}/${dataset}_flip.txt
grep -i strand $stats_file | cut -f5 -d' ' | grep rs > $flip_file
grep -i strand $stats_file | cut -f5 -d' ' | grep RS >> $flip_file
grep -i strand $stats_file | cut -f5 -d' ' | grep KG >> $flip_file
grep -i strand $stats_file | cut -f5 -d' ' | grep GA >> $flip_file
grep -i strand $stats_file | cut -f5 -d' ' | grep JHU >> $flip_file
grep -i strand $stats_file | cut -f8 -d' ' | grep rs >> $flip_file
grep -i strand $stats_file | cut -f8 -d' ' | grep RS >> $flip_file
grep -i strand $stats_file | cut -f8 -d' ' | grep KG >> $flip_file
grep -i strand $stats_file | cut -f8 -d' ' | grep GA >> $flip_file
grep -i strand $stats_file | cut -f8 -d' ' | grep JHU >> $flip_file

#Create the output file
plink --bfile $fix_at_cg_file_prefix \
      --flip $flip_file \
      --make-bed --out $out_file_prefix

#Report the output parameters
snp_flip_file_name=../data/working/${site}/${dataset}_AT_CG_update.txt
#m_at_cg=`wc -l $snp_flip_file_name | tr -s ' ' | cut -f2 -d' '`
m_flip=`wc -l $flip_file | tr -s ' ' | cut -f2 -d' '`
#echo "m_non_at_cg_${dataset} $m_non_at_cg" >> ../data/output/${site}/flow/flow_nrs.txt
#m_flip=$(($m_at_cg+$m_non_at_cg))
echo "m_flip_${dataset} $m_flip" >> ../data/output/${site}/flow/flow_nrs.txt

n_stranded=`wc -l ${out_file_prefix}.fam | tr -s ' ' | cut -f2 -d' '`
echo "n_stranded_${dataset} $n_stranded" >> ../data/output/${site}/flow/flow_nrs.txt
m_stranded=`wc -l ${out_file_prefix}.bim | tr -s ' ' | cut -f2 -d' '`
echo "m_stranded_${dataset} $m_stranded" >> ../data/output/${site}/flow/flow_nrs.txt
