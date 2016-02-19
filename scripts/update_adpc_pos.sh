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

#Create the output BIM file with position + 1
#Don't do this for SNPs with rs IDs - these are generally correct
cat update_adpc_pos.R | R --vanilla --args $in_bim_name $out_bim_name
