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
    stats.file <- paste0("../data/output/", site, "/statistics/", dataset, ".pdf")
    stats.summ.file <- paste0("../data/working/", site, "/", dataset, "_imputation_statistics_1.txt")
    if (file.exists(stats.file)) {
      system(paste("bash get_imputation_qc_stats.sh", site, dataset))
      stats <- read.table(stats.summ.file)[,2]
      nrs <- c(site, as.character(stats))
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
    stats.file <- paste0("../data/output/", site, "/statistics/", dataset, ".pdf")
    stats.summ.file <- paste0("../data/working/", site, "/", dataset, "_imputation_statistics_2.txt")
    if (file.exists(stats.file)) {
      system(paste("bash get_imputation_qc_stats.sh", site, dataset))
      stats <- read.table(stats.summ.file)[,2]
      nrs <- c(site, as.character(stats))
    } else {
      nrs <- c(site, rep("", 7))
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