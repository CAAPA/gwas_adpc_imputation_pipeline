#!/bin/bash

bash setup.sh chicago
bash run_qc.sh chicago UChicago
bash merge_files.sh chicago
bash download_results.sh chicago ~/Desktop/cookies_mdaya.txt job-20160323-081813 kzIjLloPsw
bash run_post_impute_qc.sh chicago
bash ../doc/build_flow.sh chicago

bash setup.sh detroit
#bash preprocess_detroit.sh
bash run_qc.sh detroit CHPHSR
bash merge_files.sh detroit
bash download_results.sh detroit ~/Desktop/cookies_mdaya.txt  job-20160325-124426 twjeYLdVxo
bash run_post_impute_qc.sh detroit
bash ../doc/build_flow.sh detroit

#bash preprocess_jackson.sh
bash setup.sh jackson_aric
bash run_qc.sh jackson_aric JHS_Uvermont
bash merge_files.sh jackson_aric
bash download_results.sh jackson_aric ~/Desktop/cookies_dayam.txt job-20160323-082115 GOuHRIBodL
bash run_post_impute_qc.sh jackson_aric
bash ../doc/build_flow.sh jackson_aric

bash setup.sh jackson_jhs
bash run_qc.sh jackson_jhs JHS_Uvermont
bash merge_files.sh jackson_jhs
bash download_results.sh jackson_jhs ~/Desktop/cookies_nrafaels.txt job-20160323-074933 UVtTztudTC
bash run_post_impute_qc.sh jackson_jhs
bash ../doc/build_flow.sh jackson_jhs

bash preprocess_jhu_650y.sh
bash setup.sh jhu_650y
bash run_qc.sh jhu_650y JHU
bash merge_files.sh jhu_650y

bash setup.sh jhu_abr
bash run_qc.sh jhu_abr JHU
bash merge_files.sh jhu_abr
bash download_results.sh jhu_abr ~/Desktop/cookies_nrafaels.txt job-20160323-082509 MxDyhXMvZW
bash run_post_impute_qc.sh jhu_abr
bash ../doc/build_flow.sh jhu_abr

bash setup.sh jhu_bdos
bash run_qc.sh jhu_bdos JHU
bash merge_files.sh jhu_bdos
bash download_results.sh jhu_bdos ~/Desktop/cookies_dayam.txt job-20160323-074412 LKadMXmyWI
bash run_post_impute_qc.sh jhu_bdos
bash ../doc/build_flow.sh jhu_bdos

bash setup.sh ucsf_pr
bash run_qc.sh ucsf_pr UCSF
bash merge_files.sh ucsf_pr

bash setup.sh ucsf_sf
bash run_qc.sh ucsf_sf UCSF
bash merge_files.sh ucsf_sf
bash extract_results.sh ucsf_sf ~/Desktop/cookies_mboorgula.txt job-20160323-082724 OzgHradXme
bash run_post_impute_qc.sh ucsf_sf
bash ../doc/build_flow.sh ucsf_sf

bash setup.sh washington
bash run_qc.sh washington NIH
bash merge_files.sh washington
bash download_results.sh washington ~/Desktop/cookies_sameerchavan.txt job-20160323-080617 FmVCuwkIHk
bash run_post_impute_qc.sh washington
bash ../doc/build_flow.sh washington

bash setup.sh winston_salem
bash run_qc.sh winston_salem WakeForest
bash merge_files.sh winston_salem
bash download_results.sh winston_salem ~/Desktop/cookies_sameerchavan.txt job-20160323-083702 UZgoveXNcI
bash run_post_impute_qc.sh winston_salem
bash ../doc/build_flow.sh winston_salem
