#Calculation of pre-imputation SNP nr check
###########################################
#A = gwas_flipped - delete snps
#B = adpc_flipped - delete snps -  snps in common with A
#snps in common with A = common snps - delete snps (excl discordant POS SNPs) + allele mismatches
G <- 946085 #gwas flipped
A <- 397674 #adpc flipped
D <- 82 #delete SNPs
P <- 1 #discordant POS SNPs
C <- 13003 #common SNPs
M <- 5 #allele mismatches
(G - (D + P)) + (A - (D + P) - (C - D + M))


#Check discrepant coommon samples
prev.fam <- read.table("/Volumes/Promise Pegasus/caapa_chip_data_merging/iteration_1/GWAS_files/Washington/GWAS/NIH_keep.fam")
new.fam <- read.table("/Volumes/Promise Pegasus/caapa_imputation_pipeline/data/working/washington/gwas_common.fam")
dim(prev.fam)
dim(new.fam)
sum(prev.fam$V2 %in% new.fam$V2)
new.fam[!(new.fam$V2 %in% prev.fam$V2),2]
