#!/bin/bash

#Setup
rm -r ../data/working/typed_overlap
rm -r ../data/output/typed_overlap
mkdir ../data/working/typed_overlap
mkdir ../data/output/typed_overlap

#Get per chromosome sets of overlapping SNPs by position
cat get_typed_overlap_snps.R | R --vanilla

#Extract per site those overlapping SNPs from the merged VCF files
#Concatenate the chromosomes
#Create a single PLINK file per site
bash extract_overlap_snps.sh chicago
bash extract_overlap_snps.sh detroit
bash extract_overlap_snps.sh jhu_650y
bash extract_overlap_snps.sh jhu_abr
bash extract_overlap_snps.sh jhu_bdos
bash extract_overlap_snps.sh jackson_aric
bash extract_overlap_snps.sh jackson_jhs
bash extract_overlap_snps.sh ucsf_pr
bash extract_overlap_snps.sh ucsf_sf
bash extract_overlap_snps.sh washington
bash extract_overlap_snps.sh winston_salem

#Merge and produce the final data sets
echo "" > ../data/working/typed_overlap/del_snps.txt
bash merge_overlap_snps.sh chicago detroit c_d
bash merge_overlap_snps.sh c_d jhu_650y c_d_6
bash merge_overlap_snps.sh c_d_6 jhu_abr c_d_6_abr
bash merge_overlap_snps.sh c_d_6_abr jackson_aric c_d_6_abr_aric
bash merge_overlap_snps.sh c_d_6_abr_aric jackson_jhs c_d_6_abr_aric_jhs
bash merge_overlap_snps.sh c_d_6_abr_aric_jhs ucsf_sf c_d_6_abr_aric_jhs_sf
bash merge_overlap_snps.sh c_d_6_abr_aric_jhs_sf washington c_d_6_abr_aric_jhs_sf_wa
bash merge_overlap_snps.sh c_d_6_abr_aric_jhs_sf_wa winston_salem afr_am
mv ../data/working/typed_overlap/afr_am.* ../data/output/typed_overlap
mv ../data/working/typed_overlap/jhu_bdos.* ../data/output/typed_overlap
mv ../data/working/typed_overlap/ucsf_pr.* ../data/output/typed_overlap
rm ../data/output/typed_overlap/*.vcf

#Cleanup
rm -r ../data/working/typed_overlap
