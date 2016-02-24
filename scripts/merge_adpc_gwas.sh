#!/bin/bash

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site>"
    exit
fi
site=$1
work_dir=../data/working/${site}
out_dir=../data/output/${site}/merged

#Create list of SNPs to delete and update
if [ -e "${work_dir}/discordant_snp_check-merge.diff" ];
then
    cat get_discondordant_snps.R | R --vanilla --args $work_dir
else
    #Create empty input files
    echo -e CHR'\t'POS'\t'SNP'\t'Freq'\t'Prop'\t'ADPC_ID > \
         ${work_dir}/discordant_snps_delete.txt
    echo -e CHR'\t'POS '\t'SNP '\t'IID '\t'ADPC_ID > \
         ${work_dir}/discordant_snps_update.txt
fi

#Per chromosome, and per ADPC/GWAS file, create VCF file
#Exclude discordant SNPs marked for deletion
for ((chr=1; chr<=22; chr++)); do
    cut -f6 ${work_dir}/discordant_snps_delete.txt > ${work_dir}/del_snps.txt
    plink --bfile ${work_dir}/adpc_flipped \
          --chr $chr \
          --exclude ${work_dir}/del_snps.txt \
          --recode vcf \
          --out ${work_dir}/adpc_chr${chr}
    cut -f3 ${work_dir}/discordant_snps_delete.txt > ${work_dir}/del_snps.txt
    plink --bfile ${work_dir}/gwas_flipped \
          --chr $chr \
          --exclude ${work_dir}/del_snps.txt \
          --recode vcf \
          --out ${work_dir}/gwas_chr${chr}
done

#Per chromosome, and per ADPC/GWAS file, update discordant SNPs by sample to missing
for ((chr=1; chr<=22; chr++)); do
    python update_discordant_snps.py $work_dir adpc $chr
    python update_discordant_snps.py $work_dir gwas $chr
done


#Merge the files
for ((chr=1; chr<=22; chr++)); do

    plink --vcf ${work_dir}/gwas_fixed_chr${chr}.vcf \
          --make-bed --out ${work_dir}/b_gwas_chr${chr}
    plink --vcf ${work_dir}/adpc_fixed_chr${chr}.vcf \
          --make-bed --out ${work_dir}/b_adpc_chr${chr}

    #for ADPC, also remove the duplicate position SNPs
    cat get_dupl_merged_snps.R | R --vanilla --args $work_dir $chr
    plink --vcf ${work_dir}/adpc_fixed_chr${chr}.vcf \
          --exclude ${work_dir}/merged_snps_del_chr${chr}.txt \
          --make-bed --out ${work_dir}/b_adpc_no_dupls_chr${chr}

    plink --bfile ${work_dir}/b_adpc_no_dupls_chr${chr} \
          --bmerge ${work_dir}/b_gwas_chr${chr}.bed \
          ${work_dir}/b_gwas_chr${chr}.bim \
          ${work_dir}/b_gwas_chr${chr}.fam \
          --make-bed --out  ${work_dir}/merged_chr${chr}


    plink --bfile ${work_dir}/merged_chr${chr} \
          --recode vcf \
          --out ${work_dir}/chr${chr}

    vcf-sort ${work_dir}/chr${chr}.vcf | \
        bgzip -c > \
              ${out_dir}/chr${chr}.vcf.gz
done

#Report nrs for flow diagram
m_disc_miss=`wc -l ${work_dir}/discordant_snps_update.txt | tr -s ' ' | cut -f2 -d' '`
m_disc_miss=$(($m_disc_miss-1))
echo "m_disc_miss $m_disc_miss" >> ../data/output/${site}/flow/flow_nrs.txt
m_disc_del=`wc -l ${work_dir}/discordant_snps_delete.txt | tr -s ' ' | cut -f2 -d' '`
m_disc_del=$(($m_disc_del-1))
echo "m_disc_del $m_disc_del" >> ../data/output/${site}/flow/flow_nrs.txt
n_merged=`wc -l ${work_dir}/merged_chr22.fam | tr -s ' ' | cut -f2 -d' '`
echo "n_merged $n_merged"  >> ../data/output/${site}/flow/flow_nrs.txt
m_merged=`wc -l ${work_dir}/merged_chr*bim | tail -1  | tr -s ' ' | cut -f2 -d' '`
echo "m_merged $m_merged" >> ../data/output/${site}/flow/flow_nrs.txt
