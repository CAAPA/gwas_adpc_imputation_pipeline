import sys,os

#Set parameters
dir=sys.argv[1]
file_type=sys.argv[2]
chr=sys.argv[3]
in_file_name=os.path.join(dir, file_type + "_chr" + chr + ".vcf")
out_file_name=os.path.join(dir, file_type + "_fixed_chr" + chr + ".vcf")

#Create map file for discordant SNP
#key = SNP position, value = iid1,iid2,iid3,...
snp_map = {}
map_file = open(os.path.join(dir, "discordant_snps_update.txt"))
for line in map_file:
    e = line.strip().split()
    read_chr = e[0]
    pos = e[1]
    iid = e[3]
    if read_chr == chr:
        if pos in snp_map.keys():
            iid_list = snp_map[pos]
            iid_list = iid_list + "," + iid + "_" + iid
            snp_map[pos] = iid_list
        else:
            snp_map[pos] = iid + "_" + iid
map_file.close()


#Process VCF file line by line and write new output file
in_file = open(in_file_name)
out_file = open(out_file_name, "w")
iid_list = []
for line in in_file:
    l = line.strip()
    if l[0:2] == "##":
        out_file.write(l + "\n")
    if l[0:6] == "#CHROM":
        out_file.write(l + "\n")
        e = l.split()
        iid_names_list = e[9:len(e)]
    if l[0:1] != "#":
        e = l.split()
        pos = e[1]
        if pos in snp_map.keys():
            #get the list of iids to  update for this position
            iid_str = snp_map[pos]
            iid_list = iid_str.split(",")
            #write the first 9 columns, which do not have genotype values
            out_file.write(e[0])
            for i in range(1,9):
                out_file.write("\t" + e[i])
            for i in range(9, len(e) ):
                #column names of discordant samples for this SNP are set to missing
                col_name = iid_names_list[i-9]
                if col_name in iid_list:
                    out_file.write("\t./.")
                else:
                    out_file.write("\t" + e[i])
            out_file.write("\n")
        else:
            out_file.write(l + "\n")

out_file.close()
in_file.close()
