#!/bin/bash

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site>"
    exit
fi
site=$1

#Flip strands and then merge the files
bash fix_strands.sh $site gwas
bash fix_strands.sh $site adpc
bash get_common_snp_files.sh $site
bash merge_adpc_gwas.sh $site

#Create the flow diagram for this site
bash ../doc/build_flow.sh $site
