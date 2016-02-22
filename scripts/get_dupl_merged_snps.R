args <- commandArgs(trailingOnly = TRUE)
work.dir <- args[1]
chr <- args[2]

gwas.pos <- read.table(paste0(work.dir, "/b_gwas_chr", chr, ".bim"))[,4]
adpc.frame <- read.table(paste0(work.dir, "/b_adpc_chr", chr, ".bim"))[,c(2,4)] 
snps.excl <- adpc.frame$V2[adpc.frame$V4 %in% gwas.pos]

write.table(snps.excl, paste0(work.dir, "/merged_snps_del_chr", chr, ".txt"),
            sep="\t", quote=F, row.names=F, col.names=F)