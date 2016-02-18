#!/bin/bash

#Set the numbers that are determined manually
site=$1
n_orig_gwas=`wc -l ../data/input/${site}/gwas.fam | tr -s ' ' | cut -f2 -d' '`
echo "n_orig_gwas $n_orig_gwas" >> ../data/output/${site}/flow/flow_nrs.txt
m_orig_gwas=`wc -l ../data/input/${site}/gwas.bim | tr -s ' ' | cut -f2 -d' '`
echo "m_orig_gwas $m_orig_gwas" >> ../data/output/${site}/flow/flow_nrs.txt
n_all_adpc=`wc -l ../data/input/adpc.fam | tr -s ' ' | cut -f2 -d' '`
echo "n_all_adpc $n_all_adpc" >> ../data/output/${site}/flow/flow_nrs.txt
m_all_adpc=`wc -l ../data/input/adpc.bim | tr -s ' ' | cut -f2 -d' '`
echo "m_all_adpc $m_all_adpc" >> ../data/output/${site}/flow/flow_nrs.txt

#Build the flow diagrams
bash ../../utility_scripts/build_flow.sh ../doc/flow.dot \
     ../data/output/${site}/flow/flow.png ../data/output/${site}/flow/flow_nrs.txt
