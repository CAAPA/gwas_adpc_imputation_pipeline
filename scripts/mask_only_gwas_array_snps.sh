#!/bin/bash -x

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site>"
    echo "Script must ONLY be run after mask_gwas_snps.sh"
    exit
fi

site=$1

rm -r ../data/output/${site}/masked/typed_gwas_array_only
rm -r ../data/output/${site}/masked/imputed_gwas_array_only
mkdir ../data/output/${site}/masked/typed_gwas_array_only
mkdir ../data/output/${site}/masked/imputed_gwas_array_only

work_dir=../data/working/${site}

for ((chr=1; chr<=22; chr++)); do
    vcftools --vcf ${work_dir}/gwas_fixed_chr${chr}.vcf \
             --exclude-positions ../data/output/${site}/masked/snp_pos_chr${chr}.txt \
             --recode --stdout  > ../data/output/${site}/masked/typed_gwas_array_only/chr${chr}.vcf

    vcf-sort ../data/output/${site}/masked/typed_gwas_array_only/chr${chr}.vcf | \
        bgzip -c > \
              ../data/output/${site}/masked/typed_gwas_array_only/chr${chr}.vcf.gz
done

rm  ../data/output/${site}/masked/typed_gwas_array_only/*.vcf
