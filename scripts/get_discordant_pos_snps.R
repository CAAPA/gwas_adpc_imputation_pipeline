#Set parameters
args <- commandArgs(trailingOnly = TRUE)
work.dir <- args[1]

a <- read.table(paste0(work.dir, "/adpc_flipped_concordant.bim"), stringsAsFactors = F)
g <- read.table(paste0(work.dir, "/gwas_flipped_concordant.bim"), stringsAsFactors = F)
m <- merge(a, g, by.x="V2", by.y="V2")
write.table(m$V2[(m$V4.x != m$V4.y)], paste0(work.dir, "/discordant_pos_snps_delete.txt"),
            sep="\t", quote=F, row.names=F, col.names=F)
