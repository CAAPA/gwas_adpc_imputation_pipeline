args <- commandArgs(trailingOnly = TRUE)

#Setup
site <- args[1]
out.snp.file.prefix <- paste0("../data/output/", site, "/imputed_qc/snps_deleted_chr")
out.chr.nr.file.name <- paste0("../data/output/", site, "/imputed_qc/chr_snp_count.txt")
maf.threshold <- 0.005
lt.rsq <- 0.5
gt.rsq <- 0.3
cat("chr", "total_lt", "total_gt", "low_rsq_lt", "low_rsq_gt", "total\n", 
    sep="\t", file=out.chr.nr.file.name)

for (chr in 21:22) {
  file.name <- paste0("../data/output/", site, "/imputed/chr", chr, ".info.gz")
  info <- read.table(gzfile(file.name), header=T, stringsAsFactors = F)
  
  #Write statistic for nr of SNPs that failed
  total <- dim(info)[1]
  total.lt <- sum(info$MAF <= maf.threshold)
  total.gt <- sum(info$MAF > maf.threshold)
  low.rsq.lt <- sum(info$Rsq[info$MAF <= maf.threshold] <= lt.rsq)
  low.rsq.gt <- sum(info$Rsq[info$MAF > maf.threshold] <= gt.rsq)
  cat(chr, total.lt, total.gt, low.rsq.lt, low.rsq.gt, paste0(total, "\n"), 
      sep="\t", append=T, file=out.chr.nr.file.name)
  
  #Write the SNPs that should be deleted to file
  out.snp.file.name <- paste0(out.snp.file.prefix, chr, ".txt")
  cat(gsub(":", "\t", info$SNP[(info$MAF <= maf.threshold) & (info$Rsq <= lt.rsq)]),
      sep="\n", file=out.snp.file.name)
  cat(gsub(":", "\t", info$SNP[(info$MAF > maf.threshold) & (info$Rsq <= gt.rsq)]),
      sep="\n", file=out.snp.file.name, append = T)
}