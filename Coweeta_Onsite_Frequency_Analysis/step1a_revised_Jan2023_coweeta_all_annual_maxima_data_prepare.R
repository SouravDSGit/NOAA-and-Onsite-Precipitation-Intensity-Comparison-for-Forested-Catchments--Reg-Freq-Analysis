## RG31
rm(list = ls())
data31 <- as.data.frame(read.csv(paste0("G:/Sourav/USFS/Revised/Coweeta/data/Hourly_RRG31_2009_2019.csv")))
colnames(data31)<- c("year","doy","day","PI")
data31x <- as.data.frame(read.table(paste0("G:/Sourav/USFS/Revised/Coweeta/data/Hourly_precip_31_2020.txt")))
colnames(data31x)<- c("year","doy","day","PI")
data31xf <- as.data.frame(read.table(paste0("G:/Sourav/USFS/Revised/Coweeta/data/Hourly_precip_31_2021.txt")))
colnames(data31xf)<- c("year","doy","day","PI")

datf31= rbind(data31,data31x, data31xf)
write.table(datf31, paste0("G:/Sourav/USFS/Revised/Coweeta/data/Hourly_precip_RG31_2009_2021"),row.names=FALSE, col.names=FALSE,na = "NaN")

## RG41
rm(list = ls())
data41 <- as.data.frame(read.csv(paste0("G:/Sourav/USFS/Revised/Coweeta/data/Hourly_RRG41_2009_2018.csv")))
colnames(data41)<- c("year","doy","day","PI")
data_41 <- as.data.frame(read.csv(paste0("G:/Sourav/USFS/Revised/Coweeta/data/Hourly_RRG41_2019.csv")))
colnames(data_41)<- c("year","doy","day","PI")
data41x <- as.data.frame(read.table(paste0("G:/Sourav/USFS/Revised/Coweeta/data/Hourly_precip_41_2020.txt")))
colnames(data41x)<- c("year","doy","day","PI")
data41xf <- as.data.frame(read.table(paste0("G:/Sourav/USFS/Revised/Coweeta/data/Hourly_precip_41_2021.txt")))
colnames(data41xf)<- c("year","doy","day","PI")

datf41= rbind(data41,data_41,data41x, data41xf)
write.table(datf41, paste0("G:/Sourav/USFS/Revised/Coweeta/data/Hourly_precip_RG41_2009_2021"),row.names=FALSE, col.names=FALSE,na = "NaN")