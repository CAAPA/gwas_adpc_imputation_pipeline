#!/bin/bash -x

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site>"
    exit
fi

site=$1
rm -r ../data/output/${site}/imputed_qc
mkdir ../data/output/${site}/imputed_qc

#Get SNPs that should be deleted
cat get_low_qual_imputed_snps.R | R --vanilla --args $site

#Delete those SNPs
total_kept_snps=0
for ((chr=1; chr<=22; chr++)); do
    vcftools --gzvcf ../data/output/${site}/imputed/chr${chr}.dose.vcf.gz \
             --exclude-positions ../data/output/${site}/imputed_qc/snps_deleted_chr${chr}.txt \
             --recode --stdout | gzip -c > ../data/output/${site}/imputed_qc/chr${chr}.dose.vcf.gz
    kept_snps=`grep "After filtering, kept" out.log | grep "Sites" | cut -f4 -d' '`
    total_kept_snps=$(($total_kept_snps+$kept_snps))
    rm out.log
done

n_cols=`zcat < ../data/output/${site}/imputed_qc/chr22.dose.vcf.gz | head -10 | tail -1 | wc -w`
n_imputed=$(($n_cols-9))
echo "n_imputed $n_imputed" >> ../data/output/${site}/flow/flow_nrs.txt
m_imputed=`tail -22 chr_snp_count.txt | cut -f6 | paste -sd+ - | bc`
echo "m_imputed $m_imputed" >> ../data/output/${site}/flow/flow_nrs.txt
echo "m_qc_imputed $total_kept_snps" >> ../data/output/${site}/flow/flow_nrs.txt
m_qc_del_impute=`wc -l ../data/output/${site}/imputed_qc/snps_deleted_chr* | tail -1 | tr -s ' ' | cut -f2 -d' '`
echo "m_qc_del_impute $m_qc_del_impute" >> ../data/output/${site}/flow/flow_nrs.txt
