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

if [ "$site" == "jhu_bdos" ] || [ "$site" == "jhu_abr" ]
then
    plink --bfile  ${in_file_prefix} --remove ../data/input/${site}/sample_delete.txt \
          --mind 0.05 \
          --make-bed --out ${work_dir}/tmp_del
    cat map_gwas_fam_file_ids.R | R --vanilla --args \
                                ${work_dir}/tmp_del.fam \
                                ${work_dir}/tmp.fam \
                                $institute
    cp ${work_dir}/tmp_del.bed ${work_dir}/tmp.bed
    cp ${work_dir}/tmp_del.bim ${work_dir}/tmp.bim
elif [ "$site" == "jhu_650y" ]
then
    plink --bfile  ${in_file_prefix} \
          --mind 0.05 \
          --make-bed --out ${work_dir}/tmp_del
    cat map_gwas_fam_file_ids.R | R --vanilla --args \
                                ${work_dir}/tmp_del.fam \
                                ${work_dir}/tmp.fam \
                                $institute
    cp ${work_dir}/tmp_del.bed ${work_dir}/tmp.bed
    cp ${work_dir}/tmp_del.bim ${work_dir}/tmp.bim
elif [ "$site" == "washington" ]
then
     plink --bfile  ${in_file_prefix} --remove ../data/input/${site}/sample_delete.txt \
          --make-bed --out ${work_dir}/tmp_del
    cat map_gwas_fam_file_ids.R | R --vanilla --args \
                                ${work_dir}/tmp_del.fam \
                                ${work_dir}/tmp.fam \
                                $institute
    cp ${work_dir}/tmp_del.bed ${work_dir}/tmp.bed
    cp ${work_dir}/tmp_del.bim ${work_dir}/tmp.bim
else
    cat map_gwas_fam_file_ids.R | R --vanilla --args \
                                ${in_file_prefix}.fam \
                                ${work_dir}/tmp.fam \
                                $institute
    cp ${in_file_prefix}.bed ${work_dir}/tmp.bed
    cp ${in_file_prefix}.bim ${work_dir}/tmp.bim
fi

cat get_dupl_snps.R | R --vanilla --args ${work_dir}/tmp.bim ${work_dir}
grep delete ${work_dir}/tmp.fam | cut -f1,2 > ${work_dir}/tmp_rm_ids.txt
plink --bfile ${work_dir}/tmp \
      --exclude ${work_dir}/dupl_snps_del.txt \
      --remove ${work_dir}/tmp_rm_ids.txt \
      --make-bed --out ${work_dir}/tmp_fixed

if [ "site" == "jhu_abr" ]
then
    cat swap_samples.R | R --vanilla --args $site
    mv ../data/working/${site}/new_tmp_fixed.fam ../data/working/${site}/tmp_fixed.fam
fi
plink --bfile ${work_dir}/tmp_fixed --chr 1-22 --make-bed --out $out_file_prefix


#Output nrs for flow diagram
n_init_gwas=`wc -l ${out_file_prefix}.fam | tr -s ' ' | cut -f2 -d' '`
echo "n_init_gwas $n_init_gwas" >> ../data/output/${site}/flow/flow_nrs.txt
m_init_gwas=`wc -l ${out_file_prefix}.bim | tr -s ' ' | cut -f2 -d' '`
echo "m_init_gwas $m_init_gwas" >> ../data/output/${site}/flow/flow_nrs.txt>> ../data/output/${site}/flow/flow_nrs.txt
m_dupl_snps=`wc -l ${work_dir}/dupl_snps_del.txt | tr -s ' ' | cut -f2 -d' '`
echo "m_gwas_dupl_snps $m_dupl_snps" >> ../data/output/${site}/flow/flow_nrs.txt>> ../data/output/${site}/flow/flow_nrs.txt
