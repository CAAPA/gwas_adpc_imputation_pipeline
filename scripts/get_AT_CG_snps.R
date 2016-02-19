args <- commandArgs(trailingOnly = TRUE)

in.file.name <- args[1]
out.file.name <- args[2]

in.bim <- read.table(in.file.name, stringsAsFactors = F)
snp.names <-
  in.bim[ ((in.bim$V5 == "A") & (in.bim$V6 == "T")) | 
          ((in.bim$V5 == "T") & (in.bim$V6 == "A")) |
          ((in.bim$V5 == "C") & (in.bim$V6 == "G")) |
          ((in.bim$V5 == "G") & (in.bim$V6 == "C")),2]

write.table(snp.names, out.file.name, sep="\t", quote=F, row.names=F, col.names=F)