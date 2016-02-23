#!/bin/bash

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site> <institute>"
    exit
fi
site=$1
institute=$2

#Make output directories
mkdir ../data/output
mkdir ../data/output/${site}
mkdir ../data/output/${site}/flow
mkdir ../data/output/${site}/statistics
mkdir ../data/output/${site}/merged
rm ../data/output/${site}/flow/flow_nrs.txt
mkdir ../data/working/
mkdir ../data/working/${site}

#Run through the pipeline
bash get_gwas_samples.sh $site $institute
bash get_adpc_samples.sh $site $institute
bash get_good_samples.sh $site gwas
bash get_good_samples.sh $site adpc
bash get_common_samples.sh $site gwas adpc
bash get_common_samples.sh $site adpc gwas
bash do_gwas_qc.sh $site
bash do_adpc_qc.sh $site
bash fix_strands_gwas.sh $site
bash fix_strands_adpc.sh $site
bash get_common_snp_files.sh $site
bash merge_adpc_gwas.sh $site

#Create the flow diagram for this site
bash ../doc/build_flow.sh $site

#Cleanup
#rm -r ../data/working/${site}
