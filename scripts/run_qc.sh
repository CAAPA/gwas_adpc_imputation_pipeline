#!/bin/bash

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site> <institute>"
    exit
fi
site=$1
institute=$2

#Run through the pipeline
bash get_gwas_samples.sh $site $institute
bash get_adpc_samples.sh $site $institute
bash get_good_samples.sh $site gwas
bash get_good_samples.sh $site adpc
bash get_common_samples.sh $site gwas adpc
bash get_common_samples.sh $site adpc gwas
bash do_gwas_qc.sh $site
bash do_adpc_qc.sh $site
bash fix_at_cg_strands.sh $site gwas
bash fix_at_cg_strands.sh $site adpc
