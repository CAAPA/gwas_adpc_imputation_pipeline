args <- commandArgs(trailingOnly = TRUE)
in.file.name <- args[1]
out.file.name <- args[2]

in.bim <- read.table(in.file.name)
in.bim$V4[-grep("rs", in.bim$V2)] <- in.bim$V4[-grep("rs", in.bim$V2)] + 1

write.table(in.bim, out.file.name, sep="\t", quote=F, row.names=F, col.names=F)