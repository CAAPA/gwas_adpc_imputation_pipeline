sites <- c("chicago",
           #"detroit",
           "jackson_aric",
           "jackson_jhs",
           "jhu_650y",
           "jhu_abr",
           "jhu_bdos",
           "ucsf_pr",
           "ucsf_sf",
           "washington",
           "winston_salem")

for (site in sites) {
  plink.file <- paste0("../data/working/", site, "/adpc_qc")
  out.file <- paste0("../data/working/", site, "/adpc_qc_missing")
  miss.file <- paste0(out.file, ".imiss")
  
  system(paste("plink --bfile", plink.file, "--missing --out", out.file))
  miss <- read.table(miss.file, head=T, stringsAsFactors = F)
  cat(site, (max(miss$F_MISS)), "\n", file="../data/output/max_adpc_missingness_per_site.txt",append=T)
}