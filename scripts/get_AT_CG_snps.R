args <- commandArgs(trailingOnly = TRUE)

#Set parameters
in.freq.file.name <- args[1]
in.bim.file.name <- args[2]
del.file.name <- args[3]
update.file.name <- args[4]
maf <- 0.3

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
  chr.freq <- freq[freq$CHR == chr,]
  #ref.freq <- read.table(paste0("../data/input/caapa_freq_chr", chr, ".txt"), 
  ref.freq <- read.table(paste0("../data/input/asw_freq_chr", chr, ".txt"), 
                         head=T,
                         stringsAsFactors = F)
  ref.freq <- ref.freq[ ((ref.freq$A1 == "A") & (ref.freq$A2 == "T")) | 
                          ((ref.freq$A1 == "T") & (ref.freq$A2 == "A")) | 
                          ((ref.freq$A1 == "C") & (ref.freq$A2 == "G")) | 
                          ((ref.freq$A1 == "G") & (ref.freq$A2 == "C")),]
  #Get the SNPs to delete - all AT/CG SNPs greater or equal than the specified MAF
  del.frame <- rbind(del.frame,
                     data.frame(SNP=chr.freq$SNP[chr.freq$MAF >= maf]))
  #Get the SNPs to flip - all remaining AT/CG SNPs with differing minor alleles
  chr.freq <- chr.freq[chr.freq$MAF < maf,]
  merged.freq <- merge(chr.freq, ref.freq, by.x=c("POS", "A1"), by.y=c("POS", "A2"))
  update.frame <- rbind(update.frame,
                        data.frame(SNP=merged.freq$SNP.x[merged.freq$MAF.y < maf]))
  del.frame <- rbind(del.frame,
                        data.frame(SNP=merged.freq$SNP.x[merged.freq$MAF.y >= maf]))
}

write.table(del.frame, del.file.name, sep="\t", quote=F, row.names=F, col.names=F)
write.table(update.frame, del.file.name, sep="\t", quote=F, row.names=F, col.names=F)