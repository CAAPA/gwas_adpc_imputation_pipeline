#!/bin/bash -x

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site> <gwas/adpc>"
    exit
fi
site=$1
dataset=$2 #gwas/adpc
in_file_prefix=../data/working/${site}/${dataset}_qc
snp_del_file_name=../data/working/${site}/${dataset}_AT_CG_delete.txt
snp_flip_file_name=../data/working/${site}/${dataset}_AT_CG_update.txt
fix_at_cg_file_prefix=../data/working/${site}/${dataset}_fixed_AT_CG
vcf_file_prefix=../data/working/${site}/${dataset}_chr
out_file_prefix=../data/working/${site}/${dataset}_flipped


#Calculate the MAF of the ${DATASET} SNPs
plink --bfile $in_file_prefix --freq --out ../data/working/${site}/${dataset}_freq

#Get a list of SNP names to delete and those to flip
cat get_AT_CG_snps.R | R --vanilla --args ../data/working/${site}/${dataset}_freq.frq \
                              ${in_file_prefix}.bim \
                              $snp_del_file_name \
                              $snp_flip_file_name \
                              $site \
                              $dataset


cut -f1  $snp_del_file_name >  ../data/working/${site}/snps_plink_delete.txt

#Remove and flip those SNPs
plink --bfile $in_file_prefix \
      --exclude  ../data/working/${site}/snps_plink_delete.txt \
      --make-bed --out $fix_at_cg_file_prefix \
      --flip $snp_flip_file_name \

#Create VCF files to upload to server, to identify strand flips
for ((chr=1; chr<=22; chr++)); do
    plink --bfile $fix_at_cg_file_prefix \
          --chr $chr \
          --recode vcf \
          --make-bed --out $vcf_file_prefix${chr}
    vcf-sort $vcf_file_prefix${chr}.vcf | \
        bgzip -c > \
              $vcf_file_prefix${chr}.vcf.gz
done

#Report the output parameters
m_maf=`grep large_maf $snp_del_file_name | wc -l | tr -s ' ' | cut -f2 -d' '`
echo "m_maf_${dataset}_large $m_maf" >> ../data/output/${site}/flow/flow_nrs.txt
m_maf=`grep maf_diff $snp_del_file_name | wc -l | tr -s ' ' | cut -f2 -d' '`
echo "m_maf_${dataset}_diff $m_maf" >> ../data/output/${site}/flow/flow_nrs.txt
m_not_in_ref=`grep not_in_ref $snp_del_file_name | wc -l | tr -s ' ' | cut -f2 -d' '`
echo "m_not_in_ref_${dataset} $m_not_in_ref" >> ../data/output/${site}/flow/flow_nrs.txt
m_ambig=`wc -l $snp_del_file_name | tr -s ' ' | cut -f2 -d' '`
echo "m_ambiguous_${dataset} $m_ambig" >> ../data/output/${site}/flow/flow_nrs.txt
m_at_cg=`wc -l $snp_flip_file_name | tr -s ' ' | cut -f2 -d' '`
echo "m_atcg_flip_${dataset} $m_at_cg" >> ../data/output/${site}/flow/flow_nrs.txt
