args <- commandArgs(trailingOnly = TRUE)
work.dir <- args[1]
chr <- args[2]

in.file.name <- paste0(work.dir, "/merged_chr", chr, ".bim" )
bim <- read.table(in.file.name)

dupl.pos <- bim$V4[duplicated(bim$V4)]
dupl.ids <- bim$V2[bim$V4 %in% dupl.pos]
dupl.ids <- dupl.ids[grep("JHU", dupl.ids)]

write.table(dupl.ids, paste0(work.dir, "/merged_snps_del.txt"), sep="\t", quote=F, row.names=F, col.names=F)
