out.file.prefix <- "../data/output/masked/snp_pos_chr"

prop.snps <- 0.15

sites <- c(
  "jhu_abr",
  "ucsf_pr",
  "washington")

adpc.snps <- read.table("../data/output/masked/adpc.bim")[,c(1,4)]

for (chr in 1:22) {
  snp.pos <- read.table(paste0("../data/working/", sites[1], "/merged_chr", chr, ".bim"))[,4]
  for (i in 2:length(sites)) {
    snp.pos <- intersect(snp.pos, 
                         read.table(paste0("../data/working/", sites[i], "/merged_chr", chr, ".bim"))[,4])
    snp.pos <- snp.pos[!(snp.pos %in% adpc.snps$V4[adpc.snps$V1 == chr])]
  }
  nr.snps <- round(prop.snps*length(snp.pos),0)
  snp.pos <- sample(snp.pos, nr.snps)
  frame <- data.frame(CHR=rep(chr, length(snp.pos)), POS=snp.pos)
  write.table(frame, paste0(out.file.prefix, chr, ".txt"),
              sep="\t", quote=F, row.names=F, col.names=F)
} 