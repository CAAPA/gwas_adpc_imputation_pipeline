#!/bin/bash

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site>"
    exit
fi
site=$1
work_dir=../data/working/${site}
adpc_file_prefix=${work_dir}/adpc_flipped
gwas_file_prefix=${work_dir}/gwas_flipped

#Get a file of common SNPs, merged by chromosome and position
cat get_common_snps.R | R --vanilla --args ${adpc_file_prefix}.bim \
                          ${gwas_file_prefix}.bim \
                          ${work_dir}/common_snps.txt

#Extract the common SNPs
cut -f3 ${work_dir}/common_snps.txt > ${work_dir}/common_snps_adpc.txt
plink --noweb --bfile $adpc_file_prefix \
      --extract ${work_dir}/common_snps_adpc.txt \
      --make-bed --out ${work_dir}/adpc_common_snps
cut -f4 ${work_dir}/common_snps.txt > ${work_dir}/common_snps_gwas.txt
plink --noweb --bfile $gwas_file_prefix \
      --extract ${work_dir}/common_snps_gwas.txt \
      --make-bed --out ${work_dir}/gwas_common_snps

#Change file 1 marker names to file 2 marker names
cut -f3-4 ${work_dir}/common_snps.txt > ${work_dir}/common_snps_rename.txt
plink --noweb --bfile ${work_dir}/adpc_common_snps \
      --update-map ${work_dir}/common_snps_rename.txt --update-name \
      --make-bed --out ${work_dir}/adpc_common_snps_renamed

#Have any duplicate SNPs been introduced by the above? If so, delete the SNPs
cut -f2 ${work_dir}/adpc_common_snps_renamed.bim | sort | uniq -d > duplicate_snps.txt
if [ -e "duplicate_snps.txt" ]
then
    plink --noweb --bfile ${work_dir}/adpc_common_snps_renamed \
          --exclude duplicate_snps.txt \
          --make-bed --out ${work_dir}/adpc_common_snps_renamed_no_dupl
    rm duplicate_snps.txt
else
    mv ${work_dir}/adpc_common_snps_renamed.bed ${work_dir}/adpc_common_snps_renamed_no_dupl.bed
    mv ${work_dir}/adpc_common_snps_renamed.bim ${work_dir}/adpc_common_snps_renamed_no_dupl.bim
    mv ${work_dir}/adpc_common_snps_renamed.fam ${work_dir}/adpc_common_snps_renamed_no_dupl.fam
fi


#Flip file 1 markers to file 2 markers
#-First get a list of SNPs to flip
plink --noweb --bfile  ${work_dir}/adpc_common_snps_renamed_no_dupl \
      --bmerge ${work_dir}/gwas_flipped.bed ${work_dir}/gwas_flipped.bim ${work_dir}/gwas_flipped.fam \
      --make-bed --out dummy_merge
#-Then flip the markers
if [ -e "dummy_merge-merge.missnp" ]
then
    plink --noweb --bfile  ${work_dir}/adpc_common_snps_renamed_no_dupl \
          --flip dummy_merge-merge.missnp \
          --make-bed --out  ${work_dir}/adpc_common_snps_flipped
    mv dummy_merge-merge.missnp ${work_dir}/flip_snps.txt
else
    plink --noweb --bfile  ${work_dir}/adpc_common_snps_renamed_no_dupl \
          --make-bed --out  ${work_dir}/adpc_common_snps_flipped
fi
#-Are there any markers that cannot be merged after flip? If so, delete them from both data sets
plink --noweb --bfile  ${work_dir}/adpc_common_snps_flipped \
      --bmerge ${work_dir}/gwas_flipped.bed ${work_dir}/gwas_flipped.bim ${work_dir}/gwas_flipped.fam \
      --make-bed --out dummy_merge
if [ -e "dummy_merge-merge.missnp" ]
then
    plink --noweb --bfile  ${work_dir}/adpc_common_snps_flipped \
          --exclude dummy_merge-merge.missnp \
          --make-bed --out  ${work_dir}/adpc_common_snps_final
    plink --noweb --bfile  ${work_dir}/gwas_common_snps \
          --exclude dummy_merge-merge.missnp \
          --make-bed --out  ${work_dir}/gwas_common_snps_final
    mv dummy_merge-merge.missnp ${work_dir}/allele_mismatches_snps.txt
else
    plink --noweb --bfile  ${work_dir}/adpc_common_snps_flipped \
           --make-bed --out  ${work_dir}/adpc_common_snps_final
    plink --noweb --bfile  ${work_dir}/gwas_common_snps \
          --make-bed --out  ${work_dir}/gwas_common_snps_final
fi

#Run PLINK merge to get a list of SNP discordance
plink --noweb --bfile ${work_dir}/adpc_common_snps_final \
      --bmerge ${work_dir}/gwas_common_snps_final.bed \
      ${work_dir}/gwas_common_snps_final.bim \
      ${work_dir}/gwas_common_snps_final.fam \
      --merge-mode 7 \
      --make-bed --out $work_dir/discordant_snp_check

#Check overall concordance
concordance_prop=`grep 'concordance rate' ${work_dir}/discordant_snp_check.log | cut -f8 -d' ' | sed 's/.$//'`
perc_conc=`python -c "print int($concordance_prop*100)"`
if [ "$perc_conc" -lt 95 ]
then
    echo "ERROR! concordance for site $site is less than 95%"
    read
fi
perc_conc=`python -c "print round($concordance_prop*100,2)"`

#Output nrs for flow diagram
n_common=`wc -l ${work_dir}/gwas_common_snps_final.fam | tr -s ' ' | cut -f2 -d' '`
echo "n_common $n_common" >> ../data/output/${site}/flow/flow_nrs.txt
m_common=`wc -l ${work_dir}/gwas_common_snps_final.bim | tr -s ' ' | cut -f2 -d' '`
echo "m_common $m_common" >> ../data/output/${site}/flow/flow_nrs.txt
echo "perc_conc $perc_conc" >> ../data/output/${site}/flow/flow_nrs.txt
