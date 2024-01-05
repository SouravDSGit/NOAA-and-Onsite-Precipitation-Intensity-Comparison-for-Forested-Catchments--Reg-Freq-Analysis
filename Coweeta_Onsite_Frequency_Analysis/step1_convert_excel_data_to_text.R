#######################################  data_curation for  - HJ Andrews #####################################
rm(list = ls())
data1 <- read.csv(paste0("G:/Sourav/USFS/Revised/Coweeta/Coweeta_hourly_precip_data_in_inches.csv"))
data1=cbind(data1[,1:4],data1[,6])
colnames(data1)=c('a','b','c','d','e')
data1=data1[which(data1[,1]>=1977),]
#dates <- as.POSIXct(data$DATE_TIME, format = "%Y-%m-%d %H:%M:%S")
#date_f=cbind(as.numeric(format(dates, format="%Y")),as.numeric(format(dates, format="%m")),as.numeric(format(dates, format="%d")),as.numeric(format(dates, format="%H")),as.numeric(format(dates, format="%M")),as.numeric(format(dates, format="%S")))
#data_f=as.data.frame(cbind(date_f[,1:4],as.numeric(data$PRECIP_TOT)/10))
#dataf2=as.data.frame(cbind(date_f[,1:4],as.numeric(data$PRECIP_TOT)*0.0393701))

#write.table(data_f, paste0("G:/Sourav/USFS/Revised/HJ_Andrews/PPTUPL01_15_5154_precip_15min_RG1_1995-2019_cm"),row.names=FALSE, col.names=FALSE,na = "NaN")
#write.table(dataf2, paste0("G:/Sourav/USFS/Revised/HJ_Andrews/PPTUPL01_15_5154_precip_15min_RG1_1995-2019_inches"),row.names=FALSE, col.names=FALSE,na = "NaN")
#######################################  data_curation for  - HJ Andrews #####################################
santee= read.table(paste0("G:/Sourav/USFS/Revised/Santee/Full_hourly_cm_per_hr_1977_2021"))
santee=santee[which(santee[,1]>=2016),];
data2 <- read.csv(paste0("G:/Sourav/USFS/Revised/Coweeta/Hourly_RRG6_2016_2021.csv"))
data2f=data2[1:(length(data2[,1])-3),];
data2f=cbind(santee[,1:4],data2f[,4]);
colnames(data2f)=c('a','b','c','d','e')
final=rbind(data1,data2f)
write.table(final, paste0("G:/Sourav/USFS/Revised/Coweeta/Coweeta_hourly_precip_data_in_inches"),row.names=FALSE, col.names=FALSE,na = "NaN")

