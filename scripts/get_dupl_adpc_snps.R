args <- commandArgs(trailingOnly = TRUE)
work.dir <- args[1]

in.file.name <- paste0(work.dir, "/tmp_chr_start.bim" )
bim <- read.table(in.file.name, stringsAsFactors = F)

dupl.ids <- c()
for (chr in 1:22) {
  chr.bim <- bim[bim$V1 == chr,]
  dupl.pos <- chr.bim$V4[duplicated(chr.bim$V4)]
  dupl.ids <- c(dupl.ids, as.character(chr.bim$V2[chr.bim$V4 %in% dupl.pos]))
}
dupl.ids <- dupl.ids[grep("JHU", dupl.ids)]

write.table(dupl.ids, paste0(work.dir, "/adpc_dupl_snps_del.txt"), sep="\t", quote=F, row.names=F, col.names=F)
