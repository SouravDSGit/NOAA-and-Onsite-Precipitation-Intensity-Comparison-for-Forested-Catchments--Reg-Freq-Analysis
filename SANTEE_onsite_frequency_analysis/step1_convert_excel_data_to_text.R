#######################################  SANTEE HOURLY DATA #####################################

rm(list = ls())
data <- read.csv(paste0("G:/Sourav/USFS/Revised/Santee/Tian_Santee_Met25_Hourly_data.csv"))
colnames(data)=c("DATE","HOURS","RI")
dates <- as.POSIXct(data$DATE, format = "%m/%d/%Y")
date_f=cbind(as.numeric(format(dates, format="%Y")),as.numeric(format(dates, format="%m")),as.numeric(format(dates, format="%d")))
data_s=cbind(date_f[,1:3],data$HOURS,data$RI*0.1)
data_s=data_s[complete.cases(data_s[,1]),]
write.table(data_s, paste0("G:/Sourav/USFS/Revised/Santee/Tian_Santee_Met25_Hourly_data"),row.names=FALSE, col.names=FALSE,na = "NaN")
################################# New data
#######################################  SANTEE HOURLY DATA #####################################

rm(list = ls())
data1 <- read.table(paste0("G:/Sourav/USFS/Revised/Santee/Tian_Santee_Met25_Hourly_data"))

data2= read.csv(paste0("G:/Sourav/USFS/Revised/Santee/Met_25_hourly_rain_2017_2020.csv"))
dates <- as.POSIXct(data2$Date.time, format = "%m/%d/%Y %H:%M")
date_f=cbind(as.numeric(format(dates, format="%Y")),as.numeric(format(dates, format="%m")),as.numeric(format(dates, format="%d")),as.numeric(format(dates, format="%H")))
data_2=cbind(date_f[,1:4],data2$Rainfall..mm*0.1)

data3= read.csv(paste0("G:/Sourav/USFS/Revised/Santee/met25_hourly_rain_2021.csv"))
dates <- as.POSIXct(data3$Date.Time, format = "%m/%d/%Y %H:%M")
date_f=cbind(as.numeric(format(dates, format="%Y")),as.numeric(format(dates, format="%m")),as.numeric(format(dates, format="%d")),as.numeric(format(dates, format="%H")))
data_3=cbind(date_f[,1:4],data3$Hourly.rainfall.mm*0.1)
data_3[,1]=data_3[,1]+2000;

dataf=rbind(data1,data_2,data_3);
write.table(dataf, paste0("G:/Sourav/USFS/Revised/Santee/Santee_Met25_Hourly_data_1977_2021"),row.names=FALSE, col.names=FALSE,na = "NaN")
###################################  DATA FOR GAP FILLLING ################################

datag <- read.csv(paste0("G:/Sourav/USFS/Revised/Santee/NOAA_NCDC_CHS_AP_HourlyPrecip_1995_2002_2890719.csv"))
dates <- as.POSIXct(datag$DATE, format = "%Y%m%d %H:%M")
date_f=cbind(as.numeric(format(dates, format="%Y")),as.numeric(format(dates, format="%m")),as.numeric(format(dates, format="%d")),as.numeric(format(dates, format="%H")))
data_gs=cbind(date_f[,1:4],datag$Pr)
write.table(data_gs, paste0("G:/Sourav/USFS/Revised/Santee/NOAA_NCDC_CHS_AP_HourlyPrecip_1995_2002_2890719"),row.names=FALSE, col.names=FALSE,na = "NaN")
