#!/bin/bash

#Remove duplicate SNPs
cat get_dupl_snps.R | R --vanilla --args ../data/raw/detroit/sapphire_adpcNDNC.bim ../data/working/detroit
plink --bfile ../data/raw/detroit/sapphire_adpcNDNC \
      --exclude ../data/working/detroit/dupl_snps_del.txt \
      --make-bed --out ../data/working/detroit/tmp
rm ../data/working/detroit/dupl_snps_del.txt

#Merge the annotation and BIM file
cat merge_detroit_bim.R | R --vanilla

#Create the input file - remove SNPs that could not be merged (about 500)
mv ../data/working/detroit/tmp_fixed.bim ../data/working/detroit/tmp.bim
mkdir ../data/input/detroit
rm -r ../data/input/detroit
plink --bfile  ../data/working/detroit/tmp \
      --exclude  ../data/working/detroit/unknown_allele_snps.txt \
      --make-bed --out ../data/input/detroit/gwas
