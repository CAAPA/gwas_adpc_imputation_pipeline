#!/bin/bash

#bash extract_masked_snps.sh jhu_abr typed
#bash extract_masked_snps.sh jhu_abr imputed
#python extract_masked_genos.py jhu_abr masked_imputed masked_typed
#cat compare_masked_genos.R | R --vanilla --args jhu_abr masked_typed_genos.vcf masked_imputed_genos.vcf imputed accuracies.txt
#cat calc_precision_recall.R | R --vanilla --args jhu_abr masked_typed_genos.vcf masked_imputed_genos.vcf imputed precision_recall.txt

#bash extract_masked_snps.sh ucsf_pr typed
#bash extract_masked_snps.sh ucsf_pr imputed
#python extract_masked_genos.py ucsf_pr masked_imputed masked_typed
#cat compare_masked_genos.R | R --vanilla --args ucsf_pr masked_typed_genos.vcf masked_imputed_genos.vcf imputed accuracies.txt
#cat calc_precision_recall.R | R --vanilla --args ucsf_pr masked_typed_genos.vcf masked_imputed_genos.vcf imputed precision_recall.txt

#bash extract_masked_snps.sh washington typed
#bash extract_masked_snps.sh washington imputed
#python extract_masked_genos.py washington masked_imputed masked_typed
#cat compare_masked_genos.R | R --vanilla --args washington masked_typed_genos.vcf masked_imputed_genos.vcf imputed accuracies.txt
#cat calc_precision_recall.R | R --vanilla --args washington masked_typed_genos.vcf masked_imputed_genos.vcf imputed precision_recall.txt

#bash extract_masked_snps.sh washington typed_tgp
#bash extract_masked_snps.sh washington imputed_tgp
#python extract_masked_genos.py washington masked_imputed_tgp masked_typed_tgp
cat compare_masked_genos.R | R --vanilla --args washington masked_typed_tgp_genos.vcf masked_imputed_tgp_genos.vcf imputed_tgp accuracies_tgp.txt
cat calc_precision_recall.R | R --vanilla --args washington masked_typed_tgp_genos.vcf masked_imputed_tgp_genos.vcf imputed_tgp precision_recall_tgp.txt
