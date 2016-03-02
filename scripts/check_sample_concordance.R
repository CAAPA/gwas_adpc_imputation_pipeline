args <- commandArgs(trailingOnly = TRUE)

ibd.file.name <- args[1]
log.file.name <- args[2]
err.file.name <- args[3]
cross.file.name <- args[4]

ibd <- read.table(ibd.file.name, head=T, stringsAsFactors = F)
dupl.ibd <- ibd[substr(ibd$IID1,6,21) == substr(ibd$IID2,6,21),]
nr.discordant.samples <- sum(dupl.ibd$PI_HAT < 0.9)
cat(paste0("n_discordant_samples ", nr.discordant.samples, "\n"),
    file=log.file.name, append = T)

if (nr.discordant.samples > 0) {
  write.table(dupl.ibd[(dupl.ibd$PI_HAT < 0.9),c(2,4,6:10)],
              err.file.name,  sep="\t", quote=F, row.names=F, col.names=T)
}

non.dupl.ibd <- ibd[substr(ibd$IID1,6,21) != substr(ibd$IID2,6,21),]
nr.crossed.samples <- sum(non.dupl.ibd$PI_HAT > 0.9)
cat(paste0("n_crossed_samples ", nr.crossed.samples, "\n"),
    file=log.file.name, append = T)

if (nr.crossed.samples > 0) {
  write.table(non.dupl.ibd[(non.dupl.ibd$PI_HAT > 0.9),c(2,4,6:10)],
              cross.file.name,  sep="\t", quote=F, row.names=F, col.names=T)
}
