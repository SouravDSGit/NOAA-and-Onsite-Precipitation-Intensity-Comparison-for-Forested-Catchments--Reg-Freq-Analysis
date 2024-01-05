#######################################  data_curation for  - HJ Andrews #####################################
rm(list = ls())
data <- read.csv(paste0("D:/Sourav/USFS/Revised/Hubbard Brook/HB_precip_15_min_RG1.csv"))
dates <- as.POSIXct(data$date_time, format = "%Y-%m-%d %H:%M:%S")
date_f=cbind(as.numeric(format(dates, format="%Y")),as.numeric(format(dates, format="%m")),as.numeric(format(dates, format="%d")),as.numeric(format(dates, format="%H")),as.numeric(format(dates, format="%M")),as.numeric(format(dates, format="%S")))
data_f=as.data.frame(cbind(date_f[,1:4],as.numeric(data$ppt_mm)/10))

#write.table(data_f, paste0("G:/Sourav/USFS/Revised/Hubbard Brook/L4/L4_precip_15min_RG1_1975-2021_cm"),row.names=FALSE, col.names=FALSE,na = "NaN")

#######################################  data_curation for  - HJ Andrews #####################################

data1 <- read.csv(paste0("D:/Sourav/USFS/Revised/Hubbard Brook/L4_precip_15min_RG1_1956-2011.csv"))
dates1 <- as.POSIXct(data1$DATETIME, format = "%m/%d/%Y %H:%M")
date_f1=cbind(as.numeric(format(dates1, format="%Y")),as.numeric(format(dates1, format="%m")),as.numeric(format(dates1, format="%d")),as.numeric(format(dates1, format="%H")),as.numeric(format(dates1, format="%M")))
data_f1=as.data.frame(cbind(date_f1[,1:4],as.numeric(data1$ppt_adj)/10))
final=rbind(data_f1,data_f[384633:length(data_f[,1]),])
write.table(final, paste0("D:/Sourav/USFS/Revised/Hubbard Brook/L4_precip_15min_RG1_1956_2021_cm"),row.names=FALSE, col.names=FALSE,na = "NaN")





