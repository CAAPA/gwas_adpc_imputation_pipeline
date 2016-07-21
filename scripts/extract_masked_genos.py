import sys,os

#Set parameters
site=sys.argv[1]   #e.g. jhu_abr
impute_file_prefix=sys.argv[2]    #e.g. masked_imputed
typed_file_prefix=sys.argv[3]     #e.g. masked_typed
in_imputed_file_name=os.path.join("../data/output/" + site + "/masked/", impute_file_prefix + ".vcf")
in_typed_file_name=os.path.join("../data/output/" + site + "/masked/", typed_file_prefix + ".vcf")
out_imputed_file_name=os.path.join("../data/output/" + site + "/masked/", impute_file_prefix + "_genos.vcf")
out_typed_file_name=os.path.join("../data/output/" + site + "/masked/", typed_file_prefix + "_genos.vcf")

in_impute_file=open(in_imputed_file_name)
out_impute_file=open(out_imputed_file_name, "w")
header_read=False
#Create map file for which SNPs have been imputed successfully, and what the ref+alt alleles are
#key = chr:position, value = ref_allele_alt_allele
geno_map={}
#Also write imputed output
for line in in_impute_file:
    e=line.strip().split()
    if header_read:
        chr=e[0]
        pos=e[1]
        chr_pos = chr + ":" + pos
        ref_alt=e[3] + e[4]
        geno_map[chr_pos] = ref_alt
        out_impute_file.write(chr + "\t" + pos + "\t" + e[3] + "\t" + e[4])
        for i in range(9, len(e)):
            geno = e[i].split(":")[0]
            out_impute_file.write("\t" + geno)
        out_impute_file.write("\n")
    if e[0] == "#CHROM":
        out_impute_file.write("CHROM\tPOS\tREF\tALT")
        for i in range(9, len(e)):
            out_impute_file.write("\t" + e[i])
        out_impute_file.write("\n")
        header_read=True
in_impute_file.close()
out_impute_file.close()

in_typed_file=open(in_typed_file_name)
out_typed_file=open(out_typed_file_name, "w")
header_read=False
for line in in_typed_file:
    e=line.strip().split()
    if header_read:
        chr=e[0]
        pos=e[1]
        chr_pos = chr + ":" + pos
        ref_alt=e[3] + e[4]
        if chr_pos in geno_map.keys():
            out_typed_file.write(chr + "\t" + pos + "\t" + e[3] + "\t" + e[4])
            imp_ref_alt=geno_map[chr_pos]
            if ref_alt == imp_ref_alt:
                for i in range(9, len(e)):
                    out_typed_file.write("\t" + e[i])
                out_typed_file.write("\n")
            elif ref_alt[1] + ref_alt[0] == imp_ref_alt:
                for i in range(9, len(e)):
                    geno = e[i]
                    if geno == "0/0":
                        geno = "1/1"
                    elif geno == "1/1":
                        geno = "0/0"
                    out_typed_file.write("\t" + geno)
                out_typed_file.write("\n")
            else:
                for i in range(9, len(e)):
                    out_typed_file.write("\tNA")
                out_typed_file.write("\n")
    if e[0] == "#CHROM":
        out_typed_file.write("CHROM\tPOS\tREF\tALT")
        for i in range(9, len(e)):
            out_typed_file.write("\t" + e[i])
        out_typed_file.write("\n")
        header_read=True
in_typed_file.close()
out_typed_file.close()
