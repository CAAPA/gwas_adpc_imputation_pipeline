#Set parameters
args <- commandArgs(trailingOnly = TRUE)
work.dir <- args[1]
in.file.name <- file.path(work.dir, "discordant_snp_check-merge.diff")
delete.out.file.name <- file.path(work.dir, "discordant_snps_delete.txt")
update.out.file.name <- file.path(work.dir, "discordant_snps_update.txt")
bim.file.name <- file.path(work.dir, "adpc_common_snps_final.bim")
fam.file.name <- file.path(work.dir, "adpc_common_snps_final.fam")
adpc.ids.bim.file.name <- file.path(work.dir, "adpc_common_snps.bim")

#Read input
snp.info <- read.table(bim.file.name, stringsAsFactors = F)[,c(1,2,4)]
names(snp.info) <- c("CHR", "SNP", "POS")
adpc.ids.snp.info <- read.table(adpc.ids.bim.file.name, stringsAsFactors = F)[,c(1,2,4)]
names(adpc.ids.snp.info) <- c("CHR", "ADPC_ID", "POS")
disc.frame <- read.table(in.file.name, head=T, stringsAsFactors = F)

#Create a frame for SNPs to delete
freq.frame <- data.frame(table(disc.frame$SNP))
n <- dim(read.table(fam.file.name))[1]
freq.frame$Prop <- freq.frame$Freq/n
del.frame <- freq.frame[freq.frame$Prop >= 0.05,]
names(del.frame)[1] <- "SNP"
del.frame <- merge(del.frame, snp.info)
del.frame <- merge(del.frame, adpc.ids.snp.info)
write.table(del.frame, delete.out.file.name, sep="\t", quote=F, row.names=F, col.names=T)

#Create a frame for SNPs to update
update.frame <- disc.frame[!(disc.frame$SNP %in% del.frame$SNP),c(1,3)]
update.frame <- merge(update.frame, snp.info)
update.frame <- merge(update.frame, adpc.ids.snp.info)
write.table(update.frame, update.out.file.name, sep="\t", quote=F, row.names=F, col.names=T)
