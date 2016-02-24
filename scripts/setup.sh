#!/bin/bash

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site>"
    exit
fi
site=$1

#Make output directories
mkdir ../data/output
mkdir ../data/output/${site}
mkdir ../data/output/${site}/flow
mkdir ../data/output/${site}/statistics
mkdir ../data/output/${site}/merged
rm ../data/output/${site}/flow/flow_nrs.txt
mkdir ../data/working/
mkdir ../data/working/${site}
rm ../data/working/${site}/*
