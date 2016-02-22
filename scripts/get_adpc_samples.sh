#!/bin/bash

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site> <institute>"
    exit
fi
site=$1
institute=$2
work_dir=../data/working/${site}
in_file_prefix=../data/input/adpc
out_file_prefix=../data/working/${site}/adpc_init

#Get the list of samples to extract from the ADPC file
cut -f2,4 ../data/input/manifest_master.txt | grep $institute | cut -f2 >  ${work_dir}/samples.txt
paste  ${work_dir}/samples.txt  ${work_dir}/samples.txt >  ${work_dir}/keep_list.txt

#Create intermediate files, with the fam family ID set to the sample ID
#Also set the sex and phenotypes to missing
cut -f2 -d' ' ${in_file_prefix}.fam > ${work_dir}/adpc_ids.txt
cut -f3 -d' ' ${in_file_prefix}.fam > ${work_dir}/zeros.txt
paste ${work_dir}/adpc_ids.txt ${work_dir}/adpc_ids.txt \
      ${work_dir}/zeros.txt  ${work_dir}/zeros.txt  ${work_dir}/zeros.txt  ${work_dir}/zeros.txt \
      > ${work_dir}/tmp.fam
cp ${in_file_prefix}.bed ${work_dir}/tmp.bed
cp ${in_file_prefix}.bim ${work_dir}/tmp.bim

#Create input bim files that matches dbSNP 142 chr start
bash update_adpc_pos.sh ${work_dir}/tmp ${work_dir}/tmp_chr_start
#There may now be SNPs with duplicate positions, remove them!
cat get_dupl_snps.R | R --vanilla --args ${work_dir}/tmp_chr_start.bim ${work_dir}
plink --bfile ${work_dir}/tmp_chr_start \
      --exclude ${work_dir}/dupl_snps_del.txt \
      --make-bed --out ${work_dir}/tmp_fixed

#Extract only the relevant samples and only autosomal SNPs
plink --bfile ${work_dir}/tmp_fixed \
      --keep ${work_dir}/keep_list.txt \
      --chr 1-22 \
      --make-bed --out $out_file_prefix

#Output nrs for flow diagram
n_init_adpc=`wc -l ${out_file_prefix}.fam | tr -s ' ' | cut -f2 -d' '`
echo "n_init_adpc $n_init_adpc" >> ../data/output/${site}/flow/flow_nrs.txt
m_init_adpc=`wc -l ${out_file_prefix}.bim | tr -s ' ' | cut -f2 -d' '`
echo "m_init_adpc $m_init_adpc" >> ../data/output/${site}/flow/flow_nrs.txt>> ../data/output/${site}/flow/flow_nrs.txt
m_dupl_snps=`wc -l ${work_dir}/dupl_snps_del.txt | tr -s ' ' | cut -f2 -d' '`
echo "m_adpc_dupl_snps $m_dupl_snps" >> ../data/output/${site}/flow/flow_nrs.txt>> ../data/output/${site}/flow/flow_nrs.txt
