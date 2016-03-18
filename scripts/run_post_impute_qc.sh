#!/bin/bash -x

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site>"
    exit
fi

site=$1
rm -r ../data/output/${site}/imputed_qc
mkdir ../data/output/${site}/imputed_qc

#Get SNPs that should be deleted
cat get_low_qual_imputed_snps.R | R --vanilla --args $site

#Delete those SNPs
#
