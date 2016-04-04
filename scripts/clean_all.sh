#!/bin/bash

bash clean.sh chicago
bash clean.sh detroit
bash clean.sh jackson_aric
bash clean.sh jackson_jhs
bash clean.sh jhu_650y
bash clean.sh jhu_abr
bash clean.sh jhu_bdos
bash clean.sh ucsf_pr
bash clean.sh ucsf_sf
bash clean.sh washington
bash clean.sh winstlon_salem

rm -r ../data/output/bak_400k_jhu_650y
rm -r ../data/working/bak_400k_jhu_650y
