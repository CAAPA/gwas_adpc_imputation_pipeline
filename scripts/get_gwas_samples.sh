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

cat get_dupl_snps.R | R --vanilla --args ${work_dir}/tmp.bim ${work_dir}
grep delete ${work_dir}/tmp.fam | cut -f1,2 > ${work_dir}/tmp_rm_ids.txt
plink --bfile ${work_dir}/tmp \
      --exclude ${work_dir}/dupl_snps_del.txt \
      --remove ${work_dir}/tmp_rm_ids.txt \
      --make-bed --out ${work_dir}/tmp_fixed

plink --bfile ${work_dir}/tmp_fixed --chr 1-22 --make-bed --out $out_file_prefix


#Output nrs for flow diagram
n_init_gwas=`wc -l ${out_file_prefix}.fam | tr -s ' ' | cut -f2 -d' '`
echo "n_init_gwas $n_init_gwas" >> ../data/output/${site}/flow/flow_nrs.txt
m_init_gwas=`wc -l ${out_file_prefix}.bim | tr -s ' ' | cut -f2 -d' '`
echo "m_init_gwas $m_init_gwas" >> ../data/output/${site}/flow/flow_nrs.txt>> ../data/output/${site}/flow/flow_nrs.txt
m_dupl_snps=`wc -l ${work_dir}/dupl_snps_del.txt | tr -s ' ' | cut -f2 -d' '`
echo "m_gwas_dupl_snps $m_dupl_snps" >> ../data/output/${site}/flow/flow_nrs.txt>> ../data/output/${site}/flow/flow_nrs.txt
