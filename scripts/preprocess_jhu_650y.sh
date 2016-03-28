#!/bin/bash

mkdir ../data/working/jhu_650y
rm -r ../data/input/jhu_650y
mkdir ../data/input/jhu_650y

cut -f2 ../data/input/jhu_bdos/gwas.bim > ../data/working/jhu_650y/bdos_snps.txt
plink --bfile ../data/raw/jhu_650y/GRAAD_650Y \
      --extract  ../data/working/jhu_650y/bdos_snps.txt \
      --make-bed --out  ../data/working/jhu_650y/bdos_overlap
cat map_graad_bim.R | R --vanilla

plink --bfile ../data/working/jhu_650y/bdos_overlap \
      --exclude ../data/working/jhu_650y/bdos_map_snps_not_found.txt \
      --make-bed --out ../data/input/jhu_650y

rm -r  ../data/working/jhu_650y
