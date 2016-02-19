#!/bin/bash -x

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site> <gwas/adpc>"
    exit
fi
site=$1
dataset=$2   #gwas or adpc
in_file_prefix=../data/working/${site}/${dataset}_qc
snp_file_name=../data/working/${site}/${dataset}_AC_GT.txt
no_at_cg_file_prefix=../data/working/${site}/${dataset}_no_AT_CG
vcf_file_prefix=../data/working/${site}/${dataset}_chr
out_file_prefix=../data/working/${site}/${dataset}_flipped

#Get a list of SNP names that are AT/TA or CG/GC
cat get_AT_CG_snps.R | R --vanilla --args ${in_file_prefix}.bim $snp_file_name

#Remove those SNPs
plink --bfile $in_file_prefix \
      --exclude $snp_file_name \
      --make-bed --out $no_at_cg_file_prefix

#Create VCF files to upload to server, to identify strand flips
for ((chr=1; chr<=22; chr++)); do
    plink --bfile $no_at_cg_file_prefix \
          --chr $chr \
          --recode vcf \
          --make-bed --out $vcf_file_prefix${chr}
    vcf-sort $vcf_file_prefix${chr}.vcf | \
        bgzip -c > \
              $vcf_file_prefix${chr}.vcf.gz
done

#Prompt for uploading to server
echo "================================================================================="
echo "Upload ${vcf_file_prefix}<chr>.vcf.gz to the imputation server"
echo "Save the output report and statistics file to ../data/output/${site}/statistics/"
echo "(name the files ${dataset}.pdf and ${dataset}_statistics.txt)"
echo "then press ENTER"
echo "================================================================================="
read

#Get the list of SNPs to flip
stats_file=../data/output/${site}/statistics/${dataset}_statistics.txt
flip_file=../data/working/${site}/${dataset}_flip.txt
grep -i strand $stats_file | cut -f5 -d' ' | grep rs > $flip_file
grep -i strand $stats_file | cut -f5 -d' ' | grep JHU >> $flip_file
grep -i strand $stats_file | cut -f8 -d' ' | grep rs >> $flip_file
grep -i strand $stats_file | cut -f8 -d' ' | grep JHU >> $flip_file

#Create the output file
plink --bfile $no_at_cg_file_prefix \
      --flip $flip_file \
      --make-bed --out $out_file_prefix

#Report the output parameters
m_ambig=`wc -l $snp_file_name | tr -s ' ' | cut -f2 -d' '`
echo "m_ambiguous_${dataset} $m_ambig" >> ../data/output/${site}/flow/flow_nrs.txt
m_flip=`wc -l $flip_file | tr -s ' ' | cut -f2 -d' '`
echo "m_flip_${dataset} $m_flip" >> ../data/output/${site}/flow/flow_nrs.txt
n_stranded=`wc -l ${out_file_prefix}.fam | tr -s ' ' | cut -f2 -d' '`
echo "n_stranded_${dataset} $n_stranded" >> ../data/output/${site}/flow/flow_nrs.txt
m_stranded=`wc -l ${out_file_prefix}.bim | tr -s ' ' | cut -f2 -d' '`
echo "m_stranded_${dataset} $m_stranded" >> ../data/output/${site}/flow/flow_nrs.txt
