#!/bin/bash

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site> <gwas/adpc>"
    exit
fi
site=$1
dataset=$2

flow_file=../data/output/${site}/flow_flow_nrs.txt

grep n_qc_${dataset} $flow_file
grep m_qc_${dataset} $flow_file
grep m_maf_${dataset} $flow_file
grep m_not_in_ref_${dataset} $flow_file
grep m_at_cg_${dataset} $flow_file
