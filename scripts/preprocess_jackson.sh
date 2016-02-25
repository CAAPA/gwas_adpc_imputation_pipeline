#!/bin/bash

mkdir ../data/working/
mkdir ../data/working/jackson
rm ../data/working/jackson/*
mkdir ../data/input/jackson_aric
rm ../data/input/jackson_aric/*
mkdir ../data/input/jackson_jhs
rm ../data/input/jackson_jhs/*

#Create bed file to crossover from hg18 to hg19 (remove chr 0)
grep -v ^0 ../data/input/jackson/gwas.bim | cut -f1 > ../data/working/jackson/init_c1.txt
sed 's/^/chr/'  ../data/working/jackson/init_c1.txt >  ../data/working/jackson/c1.txt
grep -v ^0 ../data/input/jackson/gwas.bim | cut -f4 > ../data/working/jackson/c2.txt
grep -v ^0 ../data/input/jackson/gwas.bim | cut -f4 > ../data/working/jackson/c3.txt
grep -v ^0 ../data/input/jackson/gwas.bim | cut -f2 > ../data/working/jackson/c4.txt
paste  ../data/working/jackson/c1.txt \
       ../data/working/jackson/c2.txt \
       ../data/working/jackson/c3.txt \
       ../data/working/jackson/c4.txt \
       >  ../data/working/jackson/in.bed

#Do crossover
CrossMap.py bed ../data/input/hg18ToHg19.over.chain \
            ../data/working/jackson/in.bed  \
            ../data/working/jackson/out.bed

#Extract only those SNPs that were successfully cross-overed
cut -f4 ../data/working/jackson/out.bed > ../data/working/jackson/snp_keep.txt
plink --bfile ../data/input/jackson/gwas \
      --extract ../data/working/jackson/snp_keep.txt \
      --make-bed --out ../data/working/jackson/gwas

#Update bim file positions
cat update_jackson_pos.R | R --vanilla
mv ../data/working/jackson/new_gwas.bim ../data/working/jackson/gwas.bim

#Split the filies into aric and jhs
grep ARIC ../data/input/jackson/site_map.txt | cut -f1 > ../data/working/jackson/aric_ids.txt
grep JHS ../data/input/jackson/site_map.txt | cut -f1 > ../data/working/jackson/jhs_ids.txt
paste  ../data/working/jackson/aric_ids.txt  ../data/working/jackson/aric_ids.txt > \
        ../data/working/jackson/keep_aric_ids.txt
paste  ../data/working/jackson/jhs_ids.txt  ../data/working/jackson/jhs_ids.txt > \
        ../data/working/jackson/keep_jhs_ids.txt
plink --bfile ../data/working/jackson/gwas \
      --keep  ../data/working/jackson/keep_aric_ids.txt \
      --make-bed --out ../data/input/jackson_aric/gwas
plink --bfile ../data/working/jackson/gwas \
      --keep  ../data/working/jackson/keep_jhs_ids.txt \
      --make-bed --out ../data/input/jackson_jhs/gwas

#Cleanup
rm -r ../data/working/jackson
