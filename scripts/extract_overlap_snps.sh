#!/bin/bash

site=$1

for ((chr=1; chr<=22; chr++)); do
    vcftools --gzvcf ../data/output/${site}/merged/chr${chr}.vcf.gz \
             --positions ../data/working/typed_overlap/overlap_pos_chr${chr}.txt \
             --recode --stdout  > ../data/working/typed_overlap/${site}_chr${chr}.vcf
done

vcf-concat  ../data/working/typed_overlap/${site}_chr1.vcf \
            ../data/working/typed_overlap/${site}_chr2.vcf \
            ../data/working/typed_overlap/${site}_chr3.vcf \
            ../data/working/typed_overlap/${site}_chr4.vcf \
            ../data/working/typed_overlap/${site}_chr5.vcf \
            ../data/working/typed_overlap/${site}_chr6.vcf \
            ../data/working/typed_overlap/${site}_chr7.vcf \
            ../data/working/typed_overlap/${site}_chr8.vcf \
            ../data/working/typed_overlap/${site}_chr9.vcf \
            ../data/working/typed_overlap/${site}_chr10.vcf \
            ../data/working/typed_overlap/${site}_chr11.vcf \
            ../data/working/typed_overlap/${site}_chr12.vcf \
            ../data/working/typed_overlap/${site}_chr13.vcf \
            ../data/working/typed_overlap/${site}_chr14.vcf \
            ../data/working/typed_overlap/${site}_chr15.vcf \
            ../data/working/typed_overlap/${site}_chr16.vcf \
            ../data/working/typed_overlap/${site}_chr17.vcf \
            ../data/working/typed_overlap/${site}_chr18.vcf \
            ../data/working/typed_overlap/${site}_chr19.vcf \
            ../data/working/typed_overlap/${site}_chr20.vcf \
            ../data/working/typed_overlap/${site}_chr21.vcf \
            ../data/working/typed_overlap/${site}_chr22.vcf > \
            ../data/working/typed_overlap/${site}.vcf

plink --vcf ../data/working/typed_overlap/${site}.vcf \
      --make-bed --out ../data/working/typed_overlap/${site}
