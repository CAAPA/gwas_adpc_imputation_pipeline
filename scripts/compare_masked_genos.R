args <- commandArgs(trailingOnly = TRUE)

site <- args[1] #"jhu_abr"
typed.file <- args[2] #"masked_typed_genos.vcf"
imputed.file <- args[3] #"masked_imputed_genos.vcf"
imputed.dir <- args[4] #"imputed"
out.file <- args[5] #accuracies.txt

out.file <- paste0("../data/output/", site, "/masked/", out.file)
typed.file <- paste0("../data/output/", site, "/masked/", typed.file)
imputed.file <- paste0("../data/output/", site, "/masked/", imputed.file)
snp.info.prefix <- paste0("../data/output/", site, "/masked/imputed/chr")

snp.info <- data.frame()
for (chr in 1:22) {
  chr.snp.info <- read.table(gzfile(paste0(snp.info.prefix, chr, ".info.gz")), 
                             head=T, stringsAsFactors = F)[,c(1,5,7)]
  markers <- read.table(paste0("../data/output/masked/snp_pos_chr", chr, ".txt"))
  chr.snp.info <- chr.snp.info[chr.snp.info$SNP %in% paste(markers$V1, markers$V2, sep=":"),]
  snp.info <- rbind(snp.info, chr.snp.info)
}

typed.frame <- read.delim(typed.file, stringsAsFactors = F)
imputed.frame <- read.delim(imputed.file, stringsAsFactors = F)
cat("SNP\tMAF\tRsq\tprop_match\n", file=out.file)
if (identical(typed.frame$POS, imputed.frame$POS)) {
  cols <- 5:dim(typed.frame)[2] 
  n <- dim(typed.frame)[2] - 4
  for (r in 1:dim(typed.frame)[1]) {
    typed.row <- typed.frame[r,cols]
    imputed.row <- imputed.frame[r,cols]
    prop.match <- sum(typed.row == imputed.row)/n
    snp <- paste(typed.frame$CHROM[r], typed.frame$POS[r], sep=":")
    maf <- snp.info$MAF[snp.info$SNP == snp]
    rsq <- snp.info$Rsq[snp.info$SNP == snp]
    cat(snp, maf, rsq, paste0(prop.match, "\n"), sep="\t", file=out.file, append = T)
  }
} else { #Do not process if SNP positions are not identical
  cat("ERROR! SNP positions not identical", file = out.file)
}
