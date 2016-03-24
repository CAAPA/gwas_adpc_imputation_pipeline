library(stringr)
library(ggplot2)
library(reshape2)

 sites <- c(#"chicago",
            #"detroit",
            #"jackson_aric",
            #"jackson_jhs",
            "jhu_650y") #,
            #"jhu_abr",
            #"jhu_bdos",
            #"ucsf_pr",
            #"ucsf_sf",
            #"washington") #,
            #"winston_salem")
#sites <- c("jhu_650y",
#          "ucsf_sf")

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
 
############################################################################### 
drawMedianRsq <- function() {
  
  draw.frame <- data.frame()
  for (site in sites){
    frame <- read.table(paste0("../data/output/", site, "/imputed_qc/rsq_summary.txt"), head=T, stringsAsFactors = F)
    frame$site <- site
    draw.frame <- rbind(draw.frame, frame)
  }
  draw.frame$category[draw.frame$category == "all"] <- "All SNPs"
  draw.frame$category[draw.frame$category == "all_lt"] <- "All SNPs MAF <= 0.005"
  draw.frame$category[draw.frame$category == "all_gt"] <- "All SNPs MAF > 0.005"
  draw.frame$category[draw.frame$category == "qc"] <- "QC SNPs"
  draw.frame$category[draw.frame$category == "qc_lt"] <- "QC SNPs MAF <= 0.005"
  draw.frame$category[draw.frame$category == "qc_gt"] <- "QC SNPs MAF > 0.005"
  draw.frame <- draw.frame[draw.frame$chr != "1-22",]
  draw.frame$chr <- factor(draw.frame$chr, levels=as.character(1:22))
  
  ggplot(data=draw.frame, aes(x=chr, y=rsq, group=site, colour=site)) +
    facet_wrap(~category) +
    geom_line() +
    geom_point() + 
    theme_bw()
  
}

###############################################################################
getSNPsDeleted <- function() {
  
  out.frame <- data.frame()
  
  for (site in sites){
    count.file <- paste0("../data/output/", site, "/imputed_qc/chr_snp_count.txt")
    counts <- read.table(count.file, head=T, stringsAsFactors = F)
    low_rsq_lt <-  formatC(sum(counts$low_rsq_lt), format="d", big.mark=",")  
    total_lt <- formatC(sum(counts$total_lt), format="d", big.mark=",")  
    prop_lt_deleted <- round(sum(counts$low_rsq_lt)/sum(counts$total_lt), 2)
    low_rsq_gt <- formatC(sum(counts$low_rsq_gt), format="d", big.mark=",")  
    total_gt <- formatC(sum(counts$total_gt), format="d", big.mark=",")  
    prop_gt_deleted <- round(sum(counts$low_rsq_gt)/sum(counts$total_gt), 2)
    total <- formatC(sum(counts$total), format="d", big.mark=",")  
    remain <- formatC(sum(counts$total) - sum(counts$low_rsq_lt) - sum(counts$low_rsq_gt), format="d", big.mark=",")  
    total_prop_deleted <- round((sum(counts$low_rsq_lt) + sum(counts$low_rsq_gt))/sum(counts$total),2)
    out.frame <- rbind(out.frame, 
                       data.frame(site,
                                  low_rsq_lt, total_lt, prop_lt_deleted,
                                  low_rsq_gt, total_gt, prop_gt_deleted,
                                  total, remain, total_prop_deleted))
  }
  
  names(out.frame) <- c("site",
                        "m_rare_low_rsq", "m_rare", "prop_low_maf_del",
                        "m_other_low_rsq", "m_other", "prop_other_del",
                        "m_original", "m_remain", "prop_del")
  
  return(out.frame)
}

###############################################################################
#del.cat=lt/gt
drawSNPsDeletedHeatMap <- function(del.cat) {
   
  frame <- data.frame(rep(0,22))
  for (site in sites){
    count.file <- paste0("../data/output/", site, "/imputed_qc/chr_snp_count.txt")
    counts <- read.table(count.file, head=T, stringsAsFactors = F)
    counts <- counts[,names(counts) %in% c("chr", paste0("total_", del.cat), paste0("low_rsq_", del.cat))]
    prop <- counts[,3]/counts[,2]
    frame <- cbind(frame, data.frame(prop))
  }
  
  frame <- frame[,-1]
  names(frame) <- sites
  chr.names <- rownames(frame)
  frame <- suppressMessages(melt(frame))
  frame$chr <- chr.names
  names(frame)[2] <- "proportion_deleted"
  frame$chr <- factor(frame$chr, levels=as.character(1:22))

  p <- ggplot(frame, aes(variable, chr)) + 
        geom_tile(aes(fill = proportion_deleted), colour = "white") + 
        scale_fill_gradient(low = "white", high = "steelblue") + 
        labs(x="")  + 
        theme_bw()
  
  return(p)
}

###############################################################################
#All these calculations are done once off and written to file so as to save
#compuation time
getSNPsDiffStats <- function() {
  ref.diff.05.frame <- data.frame()
  ref.diff.10.frame <- data.frame()
  geno.diff.10.frame <- data.frame()
  t.frame <- data.frame()
  for (site in sites){
    file.prefix <- paste0("../data/output/", site, "/imputed_qc/freq_chr")
    for (chr in 1:22) {
      freq.file <- paste0(file.prefix, chr, ".txt")
      freq <- read.table(freq.file, head=T, stringsAsFactors = F)
      
      threshold <- 0.05
      freq$delta <- abs(freq$SITE_F - freq$REF_F)
      total_exceed <- sum(freq$delta > threshold)
      total <- dim(freq)[1]
      proportion <- total_exceed/total
      ref.diff.05.frame <- rbind(ref.diff.05.frame , data.frame(site, total_exceed, total, proportion, chr))
      
      threshold <- 0.1
      freq$delta <- abs(freq$SITE_F - freq$REF_F)
      total_exceed <- sum(freq$delta > threshold)
      total <- dim(freq)[1]
      proportion <- total_exceed/total
      ref.diff.10.frame <- rbind(ref.diff.10.frame , data.frame(site, total_exceed, total, proportion, chr))
      
      freq$delta <- abs(freq$SITE_F - freq$ORIG_F)
      total_exceed <- sum(freq$delta > threshold, na.rm=T)
      total <- sum(!is.na(freq$delta))
      proportion <- total_exceed/total
      geno.diff.10.frame <- rbind(geno.diff.10.frame , data.frame(site, total_exceed, total, proportion, chr))
    }
  }
  
  #Write the output files
  write.table(ref.diff.05.frame, "../data/output/ref_diff_05.txt",  sep="\t", quote=F, row.names=F, col.names=T)
  write.table(ref.diff.10.frame, "../data/output/ref_diff_10.txt",  sep="\t", quote=F, row.names=F, col.names=T)
  write.table(geno.diff.10.frame, "../data/output/geno_diff_10.txt",  sep="\t", quote=F, row.names=F, col.names=T)
}

###############################################################################
getGenomeFreqDiff <- function(frame) {
  
  out.frame <- data.frame()
  
  for (site in unique(frame$site)){
    m_exceed <- sum(frame$total_exceed[frame$site == site])
    m <- sum(frame$total[frame$site == site])
    proportion_exceed <- round(m_exceed/m,4)
    m_exceed <- formatC(m_exceed, format="d", big.mark=",") 
    m <- formatC(m, format="d", big.mark=",") 
    out.frame <- rbind(out.frame, 
                       data.frame(site, m_exceed, m, proportion_exceed))
  }
  
  return(out.frame)
}

###############################################################################
drawFreqDiffHeatMap <- function(frame) {
  
  p <- ggplot(frame, aes(site, chr)) + 
    geom_tile(aes(fill = proportion), colour = "white") + 
    scale_fill_gradient(low = "white", high = "steelblue") + 
    labs(x="")  + 
    theme_bw()
  
  return(p)
}
