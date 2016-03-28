#!/bin/bash

bash setup.sh chicago
bash run_qc.sh chicago UChicago
bash merge_files.sh chicago

bash setup.sh detroit
#bash preprocess_detroit.sh
bash run_qc.sh detroit CHPHSR
bash merge_files.sh detroit

#bash preprocess_jackson.sh
bash setup.sh jackson_aric
bash run_qc.sh jackson_aric JHS_Uvermont
bash merge_files.sh jackson_aric

bash setup.sh jackson_jhs
bash run_qc.sh jackson_jhs JHS_Uvermont
bash merge_files.sh jackson_jhs

bash preprocess_jhu_650y.sh
bash setup.sh jhu_650y
bash run_qc.sh jhu_650y JHU
bash merge_files.sh jhu_650y

bash setup.sh jhu_abr
bash run_qc.sh jhu_abr JHU
bash merge_files.sh jhu_abr

bash setup.sh jhu_bdos
bash run_qc.sh jhu_bdos JHU
bash merge_files.sh jhu_bdos

bash setup.sh ucsf_pr
bash run_qc.sh ucsf_pr UCSF
bash merge_files.sh ucsf_pr

bash setup.sh ucsf_sf
bash run_qc.sh ucsf_sf UCSF
bash merge_files.sh ucsf_sf

bash setup.sh washington
bash run_qc.sh washington NIH
bash merge_files.sh washington

bash setup.sh winston_salem
bash run_qc.sh winston_salem WakeForest
bash merge_files.sh winston_salem
