args <- commandArgs(trailingOnly = TRUE)
bim1.filename <-args[1]
bim2.filename <- args[2]
out.filename <- args[3]

bim1 <- read.table(bim1.filename, stringsAsFactors = F)[,c(1,2,4)]
bim2 <- read.table(bim2.filename, stringsAsFactors = F)[,c(1,2,4)]
names(bim1) <- c("chr", "snp_name_1", "pos")
names(bim2) <- c("chr", "snp_name_2", "pos")
bim <- merge(bim1, bim2)

write.table(bim, out.filename,  sep="\t", quote=F, row.names=F, col.names=F)