#######################################  data_curation for  - HJ Andrews #####################################
rm(list = ls())
data1 <- read.csv(paste0("G:/Sourav/USFS/Revised/Fraser/allmet_hourly_ppt_HQTRS_2004-2007.csv"))
data2= read.csv(paste0("G:/Sourav/USFS/Revised/Fraser/allmet_hourly_ppt_HQTRS_2008-2021.csv"))
data=rbind(data1[,2:6],data2[,2:6]);
data[,5]=data[,5]/10; ## mm to cm

write.table(data, paste0("G:/Sourav/USFS/Revised/Fraser/allmet_hourly_ppt_HQTRS_2004-2021_cm"),row.names=FALSE, col.names=FALSE,na = "NaN")


