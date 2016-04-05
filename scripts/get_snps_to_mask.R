args <- commandArgs(trailingOnly = TRUE)

site <- args[1]
prop.snps <- 0.02
in.file.prefix <- paste0("../data/output/", site, "/merged/chr")
out.file.prefix <- paste0("../data/output/", site, "/masked/snp_pos_chr")

for (chr in 1:22) {
  file.name <- paste0(in.file.prefix, chr, ".vcf.gz")
  pos <- read.table(gzfile(file.name), header=T, stringsAsFactors = F, skip=7)[,2]
  nr.snps <- round(prop.snps*length(pos),0)
  masked.pos <- sample(pos, nr.snps)
  masked.pos <- masked.pos[order(masked.pos)]
  masked.frame <- data.frame(chr=rep(chr, length(masked.pos)), masked.pos)
  write.table(masked.frame, 
              paste0(out.file.prefix, chr, ".txt"), 
              sep="\t", quote=F, row.names=F, col.names=F)
}