args <- commandArgs(trailingOnly = TRUE)

#Setup
site <- args[1]
out.snp.file.prefix <- paste0("../data/output/", site, "/imputed_qc/snps_deleted_chr")
out.chr.nr.file.name <- paste0("../data/output/", site, "/imputed_qc/chr_snp_count.txt")
hist.file.name <-  paste0("../data/output/", site, "/imputed_qc/rsq_hist.pdf")
maf.threshold <- 0.005
lt.rsq <- 0.5
gt.rsq <- 0.3
cat("chr", "total_lt", "total_gt", "low_rsq_lt", "low_rsq_gt", "total\n", 
    sep="\t", file=out.chr.nr.file.name)
rsq.all <- c()

for (chr in 1:22) {
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
  low.qual.str <- c(info$SNP[(info$MAF <= maf.threshold) & (info$Rsq <= lt.rsq)],
                     info$SNP[(info$MAF > maf.threshold) & (info$Rsq <= gt.rsq)])
  cat(gsub(":", "\t", low.qual.str), sep="\n", file=out.snp.file.name)

  #Save the rsq values
  rsq.all <- c(rsq.all, info$Rsq)
  
  #Get the reference frequencies
  file.name <- paste0("../data/input/caapa_freq_chr", chr, ".txt")
  ref.freq <- read.table(file.name, head=T, stringsAsFactors = F)
  ref.freq <- ref.freq[!is.na(ref.freq$MAF),]
  
  #Remove redundant columns from info, delete low quality SNPs, and rename to merge
  info <- info[!(info$SNP %in% low.qual.str),]
  info$POS <- as.numeric(unlist(strsplit(info$SNP, split=":"))[seq(2,dim(info)[1]*2,2)])
  info <- info[,c(14,2,3,4)]
  
  #Remove redundant columns from reference freq
  ref.freq <- ref.freq[,-c(1,6)]
  
  #Merge the files, rename columns to make sense
  merged <- merge(info, ref.freq)
  names(merged) <- c("POS", "REF_A", "ALT_A", "SITE_F", "REF_ALT_A", "REF_REF_A",  "REF_F")     #REF_A, ALT_A is defined according to the site
  merged <- merged[,c(1:4,6,5,7)]
  merged$REF_F[merged$REF_A != merged$REF_ALT_A] <- 1 - merged$REF_F[merged$REF_A != merged$REF_ALT_A] 
  
  #Write the outped
  write.table(merged[,-c(5,6)], paste0("../data/output/", site, "/imputed_qc/freq_chr", chr, ".txt"),  
              sep="\t", quote=F, row.names=F, col.names=T)
  
}
pdf(hist.file.name)
hist(rsq.all, main=site, xlab="Rsq", breaks=20)
dev.off()
