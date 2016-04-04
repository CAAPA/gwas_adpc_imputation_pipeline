#!/bin/bash -x

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site> <gwas/adpc>"
    exit
fi
site=$1
dataset=$2 #gwas/adpc
pdf_file=../data/output/${site}/statistics/${dataset}.pdf
work_file=../data/working/${site}/${dataset}_imputation_statistics_text.txt
out_file_1=../data/working/${site}/${dataset}_imputation_statistics_1.txt
out_file_2=../data/working/${site}/${dataset}_imputation_statistics_2.txt

pdftotext $pdf_file $work_file


n=`grep Samples: $work_file | cut -f2 -d":" | tr -s ' '`
m_excluded=`grep "Excluded sites in total" $work_file | cut -f2 -d":" | tr -s ' '`
m_remaining=`grep "Remaining sites in total" $work_file | cut -f2 -d":" | tr -s ' '`
chunks_excluded=`grep "Chunks excluded" $work_file | head -1 | cut -f2 -d":" | tr -s ' ' | cut -f2 -d' '`
chunks_remaining=`grep "Remaining chunk" $work_file | cut -f2 -d":" | tr -s ' '`
m_match=`grep Match: $work_file | cut -f2 -d":" | tr -s ' '`
ref_overlap=`grep "Reference Overlap:" $work_file | cut -f2 -d":" | tr -s ' '`
echo "n $n" > $out_file_1
echo "m_excluded $m_excluded" >> $out_file_1
echo "m_remaining $m_remaining" >> $out_file_1
echo "chunks_excluded $chunks_excluded" >> $out_file_1
echo "chunks_remaining $chunks_remaining" >> $out_file_1
echo "m_match $m_match" >> $out_file_1
echo "ref_overlap $ref_overlap" >> $out_file_1


m_allele_freq=`grep "Alternative allele" $work_file | cut -f2 -d":" | tr -s ' '`
m_allele_switch=`grep "Allele switch:" $work_file | cut -f2 -d":" | tr -s ' '`
m_strand_flip=`grep "Strand" $work_file | head -1 | cut -f2 -d":" | tr -s ' '`
m_strand_flip_allele_switch=`grep "allele switch:" $work_file | cut -f2 -d":" | tr -s ' '`
m_at_cg=`grep "A/T, C/G genotypes:" $work_file | cut -f2 -d":" | tr -s ' '`
m_allele_mismatch=`grep "Allele mismatch:" $work_file | cut -f2 -d":" | tr -s ' '`
echo "m_allele_freq $m_allele_freq" > $out_file_2
echo "m_allele_switch $m_allele_switch" >>  $out_file_2
echo "m_strand_flip $m_strand_flip" >>  $out_file_2
echo "m_strand_flip_allele_switch $m_strand_flip_allele_switch" >>  $out_file_2
echo "m_at_cg $m_at_cg" >>  $out_file_2
echo "m_allele_mismatch $m_allele_mismatch" >>  $out_file_2
