#!/bin/bash -x

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site> <data_type>"
    echo "E.g. bash extract_masked_snps.sh jhu_abr imputed"
    echo "E.g. bash extract_masked_snps.sh jhu_abr typed"
    exit
fi

site=$1
sub_dir=$2
out_file_name=../data/output/${site}/masked/masked_${sub_dir}.vcf

if [ "$sub_dir" == "imputed" ]; then
    in_file_prefix=../data/output/${site}/masked/${sub_dir}
    in_file_suffix=.dose.vcf.gz
fi
if [ "$sub_dir" == "imputed_tgp" ]; then
    in_file_prefix=../data/output/${site}/masked/${sub_dir}
    in_file_suffix=.dose.vcf.gz
fi
if [ "$sub_dir" == "typed" ]; then
    in_file_prefix=../data/output/${site}/merged
    in_file_suffix=.vcf.gz
fi
if [ "$sub_dir" == "typed_tgp" ]; then
    in_file_prefix=../data/output/${site}/merged
    in_file_suffix=.vcf.gz
fi


for ((chr=1; chr<=22; chr++)); do
    vcftools --gzvcf ${in_file_prefix}/chr${chr}${in_file_suffix} \
             --positions ../data/output/masked/snp_pos_chr${chr}.txt \
             --recode --stdout  > ../data/working/${site}/tmp_ext_chr${chr}.vcf
done

vcf-concat ../data/working/${site}/tmp_ext_chr1.vcf \
           ../data/working/${site}/tmp_ext_chr2.vcf \
           ../data/working/${site}/tmp_ext_chr3.vcf \
           ../data/working/${site}/tmp_ext_chr4.vcf \
           ../data/working/${site}/tmp_ext_chr5.vcf \
           ../data/working/${site}/tmp_ext_chr6.vcf \
           ../data/working/${site}/tmp_ext_chr7.vcf \
           ../data/working/${site}/tmp_ext_chr8.vcf \
           ../data/working/${site}/tmp_ext_chr9.vcf \
           ../data/working/${site}/tmp_ext_chr10.vcf \
           ../data/working/${site}/tmp_ext_chr11.vcf \
           ../data/working/${site}/tmp_ext_chr12.vcf \
           ../data/working/${site}/tmp_ext_chr13.vcf \
           ../data/working/${site}/tmp_ext_chr14.vcf \
           ../data/working/${site}/tmp_ext_chr15.vcf \
           ../data/working/${site}/tmp_ext_chr16.vcf \
           ../data/working/${site}/tmp_ext_chr17.vcf \
           ../data/working/${site}/tmp_ext_chr18.vcf \
           ../data/working/${site}/tmp_ext_chr19.vcf \
           ../data/working/${site}/tmp_ext_chr20.vcf \
           ../data/working/${site}/tmp_ext_chr21.vcf \
           ../data/working/${site}/tmp_ext_chr22.vcf > $out_file_name


rm ../data/working/${site}/tmp_ext_*
