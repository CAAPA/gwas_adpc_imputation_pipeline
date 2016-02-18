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

cat map_gwas_fam_file_ids.R | R --vanilla --args \
                                ${in_file_prefix}.fam \
                                ${out_file_prefix}.fam \
                                $institute


#Output nrs for flow diagram
n_init_gwas=`wc -l ${out_file_prefix}.fam | tr -s ' ' | cut -f2 -d' '`
echo "n_init_gwas $n_init_gwas" >> ../data/output/${site}/flow/flow_nrs.txt
m_init_gwas=`wc -l ${out_file_prefix}.bim | tr -s ' ' | cut -f2 -d' '`
echo "m_init_gwas $m_init_gwas" >> ../data/output/${site}/flow/flow_nrs.txt>> ../data/output/${site}/flow/flow_nrs.txt
