args <- commandArgs(trailingOnly = TRUE)

#Setup
site <- args[1]
out.snp.file.prefix <- paste0("../data/output/", site, "/imputed_qc/snps_deleted_chr")
out.chr.nr.file.name <- paste0("../data/output/", site, "/imputed_qc/chr_snp_count.txt")
out.rsq.file.name <- paste0("../data/output/", site, "/imputed_qc/rsq_summary.txt")
hist.file.name <-  paste0("../data/output/", site, "/imputed_qc/rsq_hist.pdf")
maf.threshold <- 0.005
lt.rsq <- 0.5
gt.rsq <- 0.3
cat("chr", "total_lt", "total_gt", "low_rsq_lt", "low_rsq_gt", "total\n", 
    sep="\t", file=out.chr.nr.file.name)
cat("chr", "category", "rsq\n",
    sep="\t", file=out.rsq.file.name)
rsq.all <- c()
rsq.all.lt <- c()
rsq.all.gt <- c()
rsq.qual <- c()
rsq.qual.lt <- c()
rsq.qual.gt <- c()

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
  rsq <- info$Rsq
  rsq.lt <- info$Rsq[which(info$MAF <= maf.threshold)]
  rsq.gt <- info$Rsq[which(info$MAF > maf.threshold)]
  rsq.all <- c(rsq.all, rsq)
  rsq.all.lt <- c(rsq.all.lt, rsq.lt)
  rsq.all.gt <- c(rsq.all.gt, rsq.gt)
  cat(chr, "all", paste0(median(rsq, na.rm=T), "\n"), 
      sep="\t", append=T, file=out.rsq.file.name)
  cat(chr, "all_lt", paste0(median(rsq.lt, na.rm=T), "\n"), 
      sep="\t", append=T, file=out.rsq.file.name)
  cat(chr, "all_gt", paste0(median(rsq.gt, na.rm=T), "\n"), 
      sep="\t", append=T, file=out.rsq.file.name)
  
  #Get the reference frequencies
  file.name <- paste0("../data/input/caapa_freq_chr", chr, ".txt")
  ref.freq <- read.table(file.name, head=T, stringsAsFactors = F)
  ref.freq <- ref.freq[!is.na(ref.freq$MAF),]
  
  #Remove redundant columns from info, delete low quality SNPs, and rename to merge
  info <- info[!(info$SNP %in% low.qual.str),]
  info$POS <- as.numeric(unlist(strsplit(info$SNP, split=":"))[seq(2,dim(info)[1]*2,2)])
  info <- info[,c(14,7,2,3,4)]
  
  #Remove redundant columns from reference freq
  ref.freq <- ref.freq[,-c(1,6)]
  
  #Merge the files, rename columns to make sense
  merged <- merge(info, ref.freq)
  names(merged) <- c("POS", "RSQ", "REF_A", "ALT_A", "SITE_F", "REF_ALT_A", "REF_REF_A",  "REF_F")     #REF_A, ALT_A is defined according to the site
  merged <- merged[,c(1:5,7,6,8)]
  merged$REF_F[merged$REF_A != merged$REF_REF_A] <- 1 - merged$REF_F[merged$REF_A != merged$REF_REF_A] 
  
  #Add frequency of original genotyped SNPs
  file.name <- paste0("../data/working/", site, "/orig_freq_chr", chr, ".frq")
  orig.freq <- read.table(file.name, head=T, stringsAsFactors = F)
  file.name <- paste0("../data/working/", site, "/merged_chr", chr, ".bim")
  orig.bim <- read.table(file.name,  stringsAsFactors = F)[,c(2,4)]
  names(orig.bim) <- c("SNP", "POS")
  orig.freq <- merge(orig.freq, orig.bim)
  orig.freq <- orig.freq[,c(4,3,5,7)]
  names(orig.freq) <- c("ORIG_REF_A", "ORIG_ALT_A", "ORIG_F", "POS")
  merged <- merge(merged, orig.freq, all.x=T)
  merged$ORIG_F[which(merged$REF_A != merged$ORIG_REF_A)] <- 1 - merged$ORIG_F[which(merged$REF_A != merged$ORIG_REF_A)] 
  
  #Write the output
  write.table(merged[,-c(6,7,9,10)], paste0("../data/output/", site, "/imputed_qc/freq_chr", chr, ".txt"),  
              sep="\t", quote=F, row.names=F, col.names=T)
  
  #Write the quality rsq output to file
  rsq <- info$Rsq
  rsq.lt <- info$Rsq[which(info$MAF <= maf.threshold)]
  rsq.gt <- info$Rsq[which(info$MAF > maf.threshold)]
  rsq.qual <- c(rsq.qual, rsq)
  rsq.qual.lt <- c(rsq.qual.lt, rsq.lt)
  rsq.qual.gt <- c(rsq.qual.gt, rsq.gt)
  cat(chr, "qc", paste0(median(rsq, na.rm=T), "\n"), 
      sep="\t", append=T, file=out.rsq.file.name)
  cat(chr, "qc_lt", paste0(median(rsq.lt, na.rm=T), "\n"), 
      sep="\t", append=T, file=out.rsq.file.name)
  cat(chr, "qc_gt", paste0(median(rsq.gt, na.rm=T), "\n"), 
      sep="\t", append=T, file=out.rsq.file.name)
  
}

#Create a histogram of Rsq values
pdf(hist.file.name)
hist(rsq.all, main=site, xlab="Rsq", breaks=20)
dev.off()

#Save median across the genome
cat("1-22", "all", paste0(median(rsq.all, na.rm=T), "\n"), 
    sep="\t", append=T, file=out.rsq.file.name)
cat("1-22", "all_lt", paste0(median(rsq.all.lt, na.rm=T), "\n"), 
    sep="\t", append=T, file=out.rsq.file.name)
cat("1-22", "all_gt", paste0(median(rsq.all.gt, na.rm=T), "\n"), 
    sep="\t", append=T, file=out.rsq.file.name)
cat("1-22", "qual", paste0(median(rsq.qual, na.rm=T), "\n"), 
    sep="\t", append=T, file=out.rsq.file.name)
cat("1-22", "qual_lt", paste0(median(rsq.qual.lt, na.rm=T), "\n"), 
    sep="\t", append=T, file=out.rsq.file.name)
cat("1-22", "qual_gt", paste0(median(rsq.qual.gt, na.rm=T), "\n"), 
    sep="\t", append=T, file=out.rsq.file.name)

