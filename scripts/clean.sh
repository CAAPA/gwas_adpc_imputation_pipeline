#!/bin/bash

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site>"
    exit
fi

site=$1

cp ../data/working/${site}/discordant_samples.txt ../data/output/${site}
cp ../data/working/${site}/crossmatched_samples.txt ../data/output/${site}

rm -r ../data/working/${site}
