#jhu_650y - OK
#new.bim.file <- "../data/input/jhu_650y/gwas.bim"
#old.bim.file <- "../../caapa_chip_data_merging/iteration_1/GWAS_files/JHU/GRAAD_650Y/GRAAD_650Y_keep.bim"

#jhu_abr - OK (although there are MORE SNPs in the merged bim - possibly duplicate positions)
#new.bim.file <- "../data/input/jhu_abr/gwas.bim"
#old.bim.file <- "../../caapa_chip_data_merging/iteration_1/GWAS_files/JHU/GRAAD_ABR/GRAAD_ABR_keep.bim"

#jhu_bdos - OK
#new.bim.file <- "../data/input/jhu_bdos/gwas.bim"
#old.bim.file <- "../../caapa_chip_data_merging/iteration_1/GWAS_files/JHU/Barbados/Bdos_keep.bim"

#ucsf_pr -  OK
#new.bim.file <- "../data/input/ucsf_pr/gwas.bim"
#old.bim.file <- "../../caapa_chip_data_merging/iteration_1/GWAS_files/UCSF/PuertoRico/PR_keep.bim"

#ucsf_sf -  OK
#new.bim.file <- "../data/input/ucsf_sf/gwas.bim"
#old.bim.file <- "../../caapa_chip_data_merging/iteration_1/GWAS_files/UCSF/SanFrancisco/UCSF_ADPC.bim"

#washington -  OK
#new.bim.file <- "../data/input/washington/gwas.bim"
#old.bim.file <- "../../caapa_chip_data_merging/iteration_1/GWAS_files/Washington/GWAS/NIH_keep.bim"

#winston_salem -  NOT OK
new.bim.file <- "../data/input/winston_salem/gwas.bim"
old.bim.file <- "../../caapa_chip_data_merging/iteration_1/GWAS_files/Washington/GWAS/NIH_keep.bim"

new.bim <- read.table(new.bim.file)
old.bim <- read.table(old.bim.file)
merged.bim <- merge(old.bim, new.bim, by.x=c("V1", "V4"), by.y=c("V1", "V4"))
(dim(old.bim))
(dim(merged.bim))
