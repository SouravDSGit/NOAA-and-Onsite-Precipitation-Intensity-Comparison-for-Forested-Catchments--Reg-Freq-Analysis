#######################################  data_curation for  - HJ Andrews #####################################
rm(list = ls())
data <- read.csv(paste0("G:/Sourav/USFS/Revised/HJ_Andrews/data_PPTUPL01_15_5154/PPTUPL01_15_5154.csv"))
data=data[-c(640921,711408, 746348, 746365), ]
dates <- as.POSIXct(data$DATE_TIME, format = "%Y-%m-%d %H:%M:%S")
date_f=cbind(as.numeric(format(dates, format="%Y")),as.numeric(format(dates, format="%m")),as.numeric(format(dates, format="%d")),as.numeric(format(dates, format="%H")),as.numeric(format(dates, format="%M")),as.numeric(format(dates, format="%S")))

data_f=as.data.frame(cbind(date_f[,1:4],as.numeric(data$PRECIP_TOT)/10))

dataf2=as.data.frame(cbind(date_f[,1:4],as.numeric(data$PRECIP_TOT)*0.0393701))

write.table(data_f, paste0("G:/Sourav/USFS/Revised/HJ_Andrews/PPTUPL01_15_5154_precip_15min_RG1_1995-2019_cm"),row.names=FALSE, col.names=FALSE,na = "NaN")
#write.table(dataf2, paste0("G:/Sourav/USFS/Revised/HJ_Andrews/PPTUPL01_15_5154_precip_15min_RG1_1995-2019_inches"),row.names=FALSE, col.names=FALSE,na = "NaN")
#ff=data[order(data[,5],decreasing=TRUE),]


