#!/bin/bash -x

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site>"
    exit
fi

site=$1

rm -r ../data/output/${site}/masked
mkdir ../data/output/${site}/masked
mkdir ../data/output/${site}/masked/typed
mkdir ../data/output/${site}/masked/imputed

cat get_snps_to_mask.R | R --vanilla --args $site

for ((chr=1; chr<=22; chr++)); do
    vcftools --gzvcf ../data/output/${site}/merged/chr${chr}.vcf.gz \
             --exclude-positions ../data/output/${site}/masked/snp_pos_chr${chr}.txt \
             --recode --stdout | gzip -c > ../data/output/${site}/masked/typed/chr${chr}.vcf.gz
done
