#!/bin/bash

#!/bin/bash

#Set parameters
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <site> <cookie_file_name> <job_nr> <zip_password>"
    echo "The cookies.txt chrome web store application should be installed within chrome"
    echo "Login for the relevant user, and save cookies to <cookie_file_name>"
    echo "Also remember to print the summary report and save it to the statistics folder as imputation.pdf"
    exit
fi

site=$1
cookie_file_name=$2
job_nr=$3
zip_password=$4
url_prefix=https://imputationserver.sph.umich.edu/results

cd ../data/working/${site}

#Get the statistics file
wget --load-cookies $cookie_file_name -p ${url_prefix}/${job_nr}/statistics/statistics.txt

#Get the QC report
wget --load-cookies $cookie_file_name -p ${url_prefix}/${job_nr}/qcreport/qcreport.html

#Download the chromosomes
for ((chr=1; chr<=22; chr++)); do
    wget --load-cookies $cookie_file_name -p ${url_prefix}/${job_nr}/local/chr_${chr}.zip
done

#Unzip the chromosomes
cd imputationserver.sph.umich.edu/results/${job_nr}/local/
for ((chr=1; chr<=22; chr++)); do
    7z e chr_${chr}.zip -y -p$zip_password
done

#Move the files to their correct locations
impute_dir=../../../../../../output/${site}/imputed
rm -r $impute_dir
mkdir $impute_dir
mv *.gz* $impute_dir
cd ../statistics
stats_dir=../../../../../../output/${site}/statistics
mv statistics.txt ${stats_dir}/imputation_statistics.txt
cd ../qcreport
mv qcreport.html ${stats_dir}/imputation_qcreport.html
