args <- commandArgs(trailingOnly = TRUE)
site <- args[1]

fam <- read.table(paste0("../data/working/", site, "/tmp_fixed.fam"), stringsAsFactors = F)
fam$ORDER <- seq(1, dim(fam)[1])
swaps <- read.table(paste0("../data/input/", site, "/sample_swaps.txt"), stringsAsFactors = F)
names(swaps) <- c("old_id", "new_id")
merged <- merge(fam, swaps, by.x="V1", by.y="old_id", all.x=T)
merged$V1[!is.na(merged$new_id)] <- merged$new_id[!is.na(merged$new_id)]
merged$V2[!is.na(merged$new_id)] <- merged$new_id[!is.na(merged$new_id)]
write.table(merged[order(merged$ORDER),-c(7,8)], paste0("../data/working/", site, "/new_tmp_fixed.fam"),  sep="\t", quote=F, row.names=F, col.names=F)
