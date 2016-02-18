args <- commandArgs(trailingOnly = TRUE)
in.file.name <- args[1]
out.file.name <- args[2]
institute <- args[3]

#Read the input file and manifest file
in.fam <- read.table(in.file.name, stringsAsFactors = F)
manifest <- read.delim("../data/input/manifest_master.txt", stringsAsFactors = F)

#Reduce the manifest file to only the columns and rows that we need
manifest <- manifest[manifest$Institute == institute,c(4,16)]

#Merge the files - preserve order!
in.fam$ORDER <- seq(1, length(in.fam$V1))
merged <- merge(in.fam, manifest, by.x="V1", by.y="Individual.ID")

#Create the output fam file
ids <- merged$Institute.Sample.Label[order(merged$ORDER)]
zeros <- rep(0, length(ids))
out.fam <- data.frame(V1=ids, V2=ids, V3=zeros, V4=zeros, V5=zeros, V6=zeros)

#Write the output file
write.table(out.fam, out.file.name,  sep="\t", quote=F, row.names=F, col.names=F)
