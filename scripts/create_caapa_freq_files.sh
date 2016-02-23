#!/bin/bash

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <chr_start> <chr_end>"
    exit
fi
chr_start=$1
chr_end=$1
mkdir ../data/working


for ((chr=$chr_start; chr<=$chr_end; chr++)); do

    #Apply QC as documented in VCF_DataRelease_README_Oct2015.pdf, and extract only SNPs
    vcftools --gzvcf ../data/raw/caapa/chr${chr}/chr${chr}.CAAPA.vcf.Oct2015.gz \
             --remove-indels \
             --remove-filtered-all \
             --minGQ 20 --minDP 7 --exclude-bed ../data/raw/caapa/hg19_segdup.txt \
             --recode --stdout | bgzip -c > ../data/working/caapa_chr${chr}.vcf.gz

    #Convert the VCF to plink
    plink --vcf ../data/working/caapa_chr${chr}.vcf.gz \
          --double-id \
          --remove ../data/raw/caapa/remove_ids.txt \
          --make-bed --out ../data/working/caapa_chr${chr}_b

    #Update the BIM file to have a SNP name = position
    cut -f1 ../data/working/caapa_chr${chr}_b.bim > ../data/working/caapa_chr${chr}_col1.txt
    cut -f4 ../data/working/caapa_chr${chr}_b.bim > ../data/working/caapa_chr${chr}_col2.txt
    cut -f3-6 ../data/working/caapa_chr${chr}_b.bim >  ../data/working/caapa_chr${chr}_col3-6.txt
    paste ../data/working/caapa_chr${chr}_col1.txt \
          ../data/working/caapa_chr${chr}_col2.txt \
          ../data/working/caapa_chr${chr}_col3-6.txt > ../data/working/caapa_chr${chr}_b.bim

    #Calculate SNP frequencies
    plink --bfile ../data/working/caapa_chr${chr}_b \
          --freq --out  ../data/working/caapa_chr${chr}_freq

    #Create the output file - note that the SNP column actually contains the position, so rename it
    sed 's/SNP/POS/' ../data/working/caapa_chr${chr}_freq.frq > ../data/input/caapa_freq_chr${chr}.txt

    #Cleanup
    rm ../data/working/caapa_chr${chr}*

 done
