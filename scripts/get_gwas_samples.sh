#!/bin/bash

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site> <institute>"
    exit
fi
site=$1
institute=$2
in_file_prefix=../data/input/${site}/gwas
out_file_prefix=../data/working/${site}/gwas_init
work_dir=../data/working/${site}

cat map_gwas_fam_file_ids.R | R --vanilla --args \
                                ${in_file_prefix}.fam \
                                ${work_dir}/tmp.fam \
                                $institute

cp ${in_file_prefix}.bed ${work_dir}/tmp.bed
cp ${in_file_prefix}.bim ${work_dir}/tmp.bim

plink --bfile ${work_dir}/tmp --chr 1-22 --make-bed --out $out_file_prefix


#Output nrs for flow diagram
n_init_gwas=`wc -l ${out_file_prefix}.fam | tr -s ' ' | cut -f2 -d' '`
echo "n_init_gwas $n_init_gwas" >> ../data/output/${site}/flow/flow_nrs.txt
m_init_gwas=`wc -l ${out_file_prefix}.bim | tr -s ' ' | cut -f2 -d' '`
echo "m_init_gwas $m_init_gwas" >> ../data/output/${site}/flow/flow_nrs.txt>> ../data/output/${site}/flow/flow_nrs.txt
