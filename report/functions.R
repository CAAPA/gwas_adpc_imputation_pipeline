library(stringr)

sites <- c("chicago",
           #"detroit",
           "jackson_aric",
           "jackson_jhs",
           "jhu_650y",
           "jhu_abr",
           #"jhu_bdos",
           #"ucsf_pr",
           "ucsf_sf",
           #"washington",
           "winston_salem")

###############################################################################
getPreQCStatistics <- function () {

  out.frame <- data.frame()
  
  for (site in sites){
    flow.file <- paste0("../data/output/", site, "/flow/flow_nrs.txt")
    if (file.exists(flow.file)) {
      flow.nrs <- read.table(flow.file)
      flow.nrs <- flow.nrs[flow.nrs$V1 %in% c("n_init_gwas",
                                              "n_common",
                                              "n_conc_common",
                                              "m_init_gwas",
                                              "m_init_adpc",
                                              "m_qc_gwas",
                                              "m_qc_adpc",
                                              "m_stranded_gwas",
                                              "m_stranded_adpc",
                                              "m_merged"),]
      
      nrs <- c(site, formatC(as.numeric(str_trim(flow.nrs[,2])), format="d", big.mark=","))
    } else {
      nrs <- c(site, rep("", 10))
    }
    out.frame <- rbind(out.frame, data.frame(t(nrs)))
  }
  
  names(out.frame) <- c("",
                        "n initial GWAS",
                        "m initial GWAS",
                        "m initial ADPC",
                        "m QC GWAS",
                        "m QC ADPC",
                        "m no AT/CG GWAS",
                        "m no AT/CG ADPC",
                        "n common samples",
                        "n concordant samples",
                        "m merged")
  out.frame <- out.frame[,c(1,2,9,10,3,5,7,4,6,8,11)]
  
  return(out.frame)
}

###############################################################################
getImputationQCStatistics1 <- function (dataset) {
  
  out.frame <- data.frame()
  
  for (site in sites){
    stats.file <- paste0("../data/output/", site, "/statistcs/", dataset, ".pdf")
    work.file <- paste0("../data/working/", site, "/imputation_stats.txt")
    if (file.exists(stats.file)) {
      #TODO: create a shell script that will write the nrs to file which can just be read in then,
      #similar to flow_nrs; pass stats.file and work.file as arguments
      #system(paste("pdftotext", stats.file, work.file))
      nrs <- c(site, rep("", 7))
    } else {
      nrs <- c(site, rep("", 7))
    }
    out.frame <- rbind(out.frame, data.frame(t(nrs)))
  }
  
  names(out.frame) <- c("",
                        "n",
                        "m excluded",
                        "m remaining",
                        "chunks excluded",
                        "chunks remaining",
                        "m match",
                        "reference overlap")
  
  return (out.frame)
  
}

###############################################################################
getImputationQCStatistics2 <- function (dataset) {
  
  out.frame <- data.frame()
  
  for (site in sites){
    flow.file <- paste0("../data/output/", site, "/flow/flow_nrs.txt")
    if (file.exists(flow.file)) {
      nrs <- c(site, rep("", 6))
    } else {
      nrs <- c(site, rep("", 6))
    }
    out.frame <- rbind(out.frame, data.frame(t(nrs)))
  }
  
  names(out.frame) <- c("",
                        "m allele frequencies > 0.5",
                        "m allele switch",
                        "m strand flip",
                        "m strand flip and allele switch",
                        "m AT/CG",
                        "m allele mismatch")
  
  return (out.frame)
  
}