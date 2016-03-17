args <- commandArgs(trailingOnly = TRUE)

#Set parameters
in.freq.file.name <- args[1]
in.bim.file.name <- args[2]
del.file.name <- args[3]
update.file.name <- args[4]
site <- args[5]
dataset <- args[6]
maf.diff <- 0.01
maf.thresh <- 0.4

#Create initial empty output data frame
del.frame <- data.frame()
update.frame <- data.frame()

#Only retain AT/CG genotypes, and append position information, as you need to merge on position
freq <- read.table(in.freq.file.name, head=T, stringsAsFactors = F)
freq <- freq[ ((freq$A1 == "A") & (freq$A2 == "T")) | 
                        ((freq$A1 == "T") & (freq$A2 == "A")) | 
                        ((freq$A1 == "C") & (freq$A2 == "G")) | 
                        ((freq$A1 == "G") & (freq$A2 == "C")),]
bim <- read.table(in.bim.file.name, stringsAsFactors = F)[,c(1,2,4)]
names(bim) <- c("CHR", "SNP", "POS")
freq <- merge(freq, bim)

for (chr in 1:22) {
  print(chr)
  chr.freq <- freq[freq$CHR == chr,]
  ref.freq <- read.table(paste0("../data/input/caapa_freq_chr", chr, ".txt"), head=T, stringsAsFactors = F)
  #ref.freq <- read.table(paste0("../data/input/asw_freq_chr", chr, ".txt"), head=T, stringsAsFactors = F)[,-2]
  ref.freq <- ref.freq[ref.freq$CHR == chr,]
  ref.freq <- ref.freq[ ((ref.freq$A1 == "A") & (ref.freq$A2 == "T")) | 
                          ((ref.freq$A1 == "T") & (ref.freq$A2 == "A")) | 
                          ((ref.freq$A1 == "C") & (ref.freq$A2 == "G")) | 
                          ((ref.freq$A1 == "G") & (ref.freq$A2 == "C")),]
  
  #merge the data sets and calculate MAF diff
  merged.freq <- merge(chr.freq, ref.freq, by.x=c("POS"), by.y=c("POS"), all.x=T)
  merged.freq$MAF.DIFF <- abs(merged.freq$MAF.x - merged.freq$MAF.y)
  
  #Get SNPs to delete - all SNPs not in the reference genome
  ind <- is.na(merged.freq$MAF.y)
  del.frame <- rbind(del.frame,
                     data.frame(SNP=merged.freq$SNP[ind],
                                reason=rep("not_in_ref", sum(ind))))
  #Get SNPs to delete - either site or refernce genome MAF > maf.thresh 
  ind <- !is.na(merged.freq$MAF.y) & ((merged.freq$MAF.x > maf.thresh ) | (merged.freq$MAF.y > maf.thresh))
  del.frame <- rbind(del.frame,
                     data.frame(SNP=merged.freq$SNP[ind],
                                reason=rep("large_maf", sum(ind))))
  #Get SNPs to delete - all SNPs with large MAF difference
  ind <- !is.na(merged.freq$MAF.DIFF) & (merged.freq$MAF.DIFF > maf.diff) & 
    (merged.freq$MAF.x <= maf.thresh ) & (merged.freq$MAF.y <= maf.thresh )
  del.frame <- rbind(del.frame,
                     data.frame(SNP=merged.freq$SNP[ind],
                                reason=rep("maf_diff", sum(ind))))
  #Remaining SNPs with differing minor alleles need to be flipped
  ind <- !is.na(merged.freq$MAF.DIFF) & (merged.freq$MAF.DIFF <= maf.diff) &
    (merged.freq$MAF.x <= maf.thresh ) & (merged.freq$MAF.y <= maf.thresh) &
    (merged.freq$A1.x != merged.freq$A1.y)
  update.frame <- rbind(update.frame,
                        data.frame(SNP=merged.freq$SNP[ind]))

}

write.table(del.frame, del.file.name, sep="\t", quote=F, row.names=F, col.names=F)
write.table(update.frame, update.file.name, sep="\t", quote=F, row.names=F, col.names=F)

#Workout how many SNPs remain
snps.remain <- dim(freq)[1] - dim(del.frame)[1]
str <- paste0("m_remain_atcg_", dataset, " ", snps.remain, "\n")
file <- paste0("../data/output/", site, "/flow/flow_nrs.txt")
cat(str, file=file, append=T)
