bim.650 <- read.table("../data/working/jhu_650y/bdos_overlap.bim")
bim.bdos <- read.table("../data/input/jhu_bdos/gwas.bim")
bim.bdos <- bim.bdos[,c(1,2,4)]
names(bim.bdos)[3] <- "NEW_V4"
bim.650$ORDER <- 1:dim(bim.650)[1]
bim.merge <- merge(bim.650, bim.bdos, all.x=T)
bim.merge$V4[!is.na(bim.merge$NEW_V4)] <- bim.merge$NEW_V4[!is.na(bim.merge$NEW_V4)]
del.snps <- bim.merge$V2[is.na(bim.merge$NEW_V4)]
bim.merge <- bim.merge[order(bim.merge$ORDER),]
write.table(bim.merge[,1:6], "../data/working/jhu_650y/bdos_overlap.bim",  sep="\t", quote=F, row.names=F, col.names=F)
write.table(del.snps, "../data/working/jhu_650y/bdos_map_snps_not_found.txt",  sep="\t", quote=F, row.names=F, col.names=F)
