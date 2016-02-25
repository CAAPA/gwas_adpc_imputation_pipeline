args <- commandArgs(trailingOnly = TRUE)
in.file.name <- args[1]
out.file.name <- args[2]
institute <- args[3]

#Read the input file and manifest file
in.fam <- read.table(in.file.name, stringsAsFactors = F)
manifest <- read.delim("../data/input/manifest_master.txt", stringsAsFactors = F)

#Reduce the manifest file to only the columns and rows that we need
#For wakeforest, the mapping field is actually contained in the Family ID column
if (institute == "WakeForest") {
  manifest <- manifest[manifest$Institute == institute,c(4,15)]
  names(manifest)[2] <- "Individual.ID"
} else {
  manifest <- manifest[manifest$Institute == institute,c(4,16)]
}
  
#For the NIH, the individual ID that maps to the manifest is V1->V2
if (institute == "NIH") {
  in.fam$V1 <- paste0(in.fam$V1, "->", in.fam$V2)
}
#For wakeforest, the individual ID that maps to the manifest is V1_V2
if (institute == "WakeForest") {
  in.fam$V1 <- paste0(in.fam$V1, "_", in.fam$V2)
}

#Merge the files - preserve order!
in.fam$ORDER <- seq(1, length(in.fam$V1))
merged <- merge(in.fam, manifest, by.x="V1", by.y="Individual.ID", all.x=T)

#Create the output fam file
ids <- merged$Institute.Sample.Label[order(merged$ORDER)]
ids[is.na(ids)] <- paste0("delete", seq(1, sum(is.na(ids))))
zeros <- rep(0, length(ids))
out.fam <- data.frame(V1=ids, V2=ids, V3=zeros, V4=zeros, V5=zeros, V6=zeros)

#Write the output file
write.table(out.fam, out.file.name,  sep="\t", quote=F, row.names=F, col.names=F)
