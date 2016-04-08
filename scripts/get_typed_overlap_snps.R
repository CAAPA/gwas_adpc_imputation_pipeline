out.file.prefix <- "../working/typed_overlap/overlap_pos_chr"

sites <- c("chicago",
  "detroit",
  "jackson_aric",
  "jackson_jhs",
  "jhu_650y",
  "jhu_abr",
  "jhu_bdos",
  "ucsf_pr",
  "ucsf_sf",
  "washington",
  "winston_salem")


for (chr in 1:22) {
  snp.pos <- read.table(paste0("../data/working/", sites[1], "/merged_chr", chr, ".bim"))[,4]
  for (i in 2:length(sites)) {
    snp.pos <- intersect(snp.pos, 
                         read.table(paste0("../data/working/", sites[i], "/merged_chr", chr, ".bim"))[,4])
  }
  write.table(snp.pos, paste0(out.file.prefix, chr, ".txt"),
              sep="\t", quote=F, row.names=F, col.names=F)
} 