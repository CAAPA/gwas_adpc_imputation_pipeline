#!/bin/bash -x

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site>"
    echo "This script must be run only AFTER mask_gwas_snp.sh"
    exit
fi

site=$1

rm -r ../data/output/${site}/masked/typed_tgp
rm -r ../data/output/${site}/masked/imputed_tgp
mkdir ../data/output/${site}/masked/typed_tgp
mkdir ../data/output/${site}/masked/imputed_tgp

flip_file=../data/working/${site}/tgp_flip.txt
stats_file=../data/output/${site}/statistics/tgp_imputation_statistics.txt
grep -i strand $stats_file | cut -f5 -d' ' | grep rs > $flip_file
grep -i strand $stats_file | cut -f5 -d' ' | grep RS >> $flip_file
grep -i strand $stats_file | cut -f5 -d' ' | grep KG >> $flip_file
grep -i strand $stats_file | cut -f5 -d' ' | grep GA >> $flip_file
grep -i strand $stats_file | cut -f5 -d' ' | grep JHU >> $flip_file
grep -i strand $stats_file | cut -f5 -d' ' | grep b36 >> $flip_file
grep -i strand $stats_file | cut -f5 -d' ' | grep SNP >> $flip_file
grep -i strand $stats_file | cut -f5 -d' ' | grep UN >> $flip_file
grep -i strand $stats_file | cut -f8 -d' ' | grep rs >> $flip_file
grep -i strand $stats_file | cut -f8 -d' ' | grep RS >> $flip_file
grep -i strand $stats_file | cut -f8 -d' ' | grep KG >> $flip_file
grep -i strand $stats_file | cut -f8 -d' ' | grep GA >> $flip_file
grep -i strand $stats_file | cut -f8 -d' ' | grep JHU >> $flip_file
grep -i strand $stats_file | cut -f8 -d' ' | grep b36 >> $flip_file
grep -i strand $stats_file | cut -f8 -d' ' | grep SNP >> $flip_file
grep -i strand $stats_file | cut -f8 -d' ' | grep UN >> $flip_file


for ((chr=1; chr<=22; chr++)); do
    vcftools --gzvcf ../data/output/${site}/merged/chr${chr}.vcf.gz \
             --exclude-positions ../data/output/masked/snp_pos_chr${chr}.txt \
             --recode --stdout  > ../data/working/${site}/masked_chr${chr}.vcf

    plink --vcf ../data/working/${site}/masked_chr${chr}.vcf \
          --flip ${flip_file} \
          --recode vcf \
          --out ../data/working/${site}/flipped_masked_chr${chr}

    vcf-sort ../data/working/${site}/flipped_masked_chr${chr}.vcf | \
        bgzip -c > \
              ../data/output/${site}/masked/typed_tgp/chr${chr}.vcf.gz
done

rm  ../data/output/${site}/masked/typed_tgp/*.vcf
