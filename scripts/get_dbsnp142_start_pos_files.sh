#!/bin/bash

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <plink_in_prefix> <plink_out_prefix>"
    exit
fi
plink_in_prefix=$1
plink_out_prefix=$2
in_bim_name=${plink_in_prefix}.bim
out_bim_name=${plink_out_prefix}.bim
cp ${plink_in_prefix}.fam ${plink_out_prefix}.fam
cp ${plink_in_prefix}.bed ${plink_out_prefix}.bed

#Does the BIM file match dbsnp 142 chr end position?
#If so, copy BIM file to output BIM file and exit
cut -f2 ../GWAS_files/uscs.hg19.dbsnp142.chr22 | sort | uniq -u > tmp_pos.txt
grep ^22 $in_bim_name | cut -f4  >> tmp_pos.txt
nr_dupl=`cat tmp_pos.txt | sort | uniq -d | wc -l`
n=`grep ^22 $in_bim_name | wc -l`
prop_matches=`python -c "print int(float($nr_dupl)/$n*100)"`
if [ "$prop_matches" -gt 80 ]
then
    cp $in_bim_name $out_bim_name
    rm tmp_pos.txt
    exit
fi

#Does the BIM file match dbsnp 142 chr start position?
#If so, create the output BIM file with position + 1
#Don't do this for SNPs with rs IDs - these are generally correct
cut -f1 ../GWAS_files/uscs.hg19.dbsnp142.chr22 | sort | uniq -u > tmp_pos.txt
grep ^22 $in_bim_name | cut -f4  >> tmp_pos.txt
nr_dupl=`cat tmp_pos.txt | sort | uniq -d | wc -l`
n=`grep ^22 $in_bim_name | wc -l`
prop_matches=`python -c "print int(float($nr_dupl)/$n*100)"`
if [ "$prop_matches" -gt 80 ]
then
    cat update_pos.R | R --vanilla --args $in_bim_name $out_bim_name
    #cut -f1-3 $in_bim_name > tmp_c1_to_c3.txt
    #cut -f4 $in_bim_name > tmp_end_pos.txt
    #cut -f5-6 $in_bim_name > tmp_c5_to_c6.txt
    #while read line
    #do
    #    echo $(($line+1)) >> tmp_c4.txt
    #done < tmp_end_pos.txt
    #paste tmp_c1_to_c3.txt tmp_c4.txt tmp_c5_to_c6.txt > $out_bim_name
    #rm tmp_*
    #exit
fi
