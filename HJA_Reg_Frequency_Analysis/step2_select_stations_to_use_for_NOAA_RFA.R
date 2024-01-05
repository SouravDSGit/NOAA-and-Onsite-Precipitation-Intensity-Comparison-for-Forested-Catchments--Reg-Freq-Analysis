######################################## Finding stations with full record from 1994 to 2013 

rm(list = ls())
library(readxl)
schar=read_xlsx(paste0("G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/selected_stations_1979_2013.xlsx"))
schar$id=gsub(':','',schar$id)
stid=list.files(paste0("G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/NOAA_Oregon_1hr_precip/"))
stfi=list();
for ( q in 1:length(stid)){
  print(q)
stname=gsub('.xlsx','',stid[q])
z=which(schar$id==stname)
data=read_xlsx(paste0("G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/NOAA_Oregon_1hr_precip/",stid[q]))
data$date=gsub('T', ' ', data$date)
dates <- as.POSIXct(data$date, format = "%Y-%m-%d %H:%M:%S")
date_f=cbind(as.numeric(format(dates, format="%Y")),as.numeric(format(dates, format="%m")),as.numeric(format(dates, format="%d")),as.numeric(format(dates, format="%H")),as.numeric(format(dates, format="%M")))
data_f=cbind(date_f,data[,4]/100,data[,5],schar$elevation[z],schar$longitude[z],schar$latitude[z])
data_f[which(data_f[,7]=="A"),6]=0;data_f[which(data_f[,7]=="["),6]=999.99;data_f[which(data_f[,7]=="]"),6]=999.99;
data_f = subset(data_f, select = -7 )
write.table(data_f, paste0("G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/NOAA_Oregon_results/preliminary/1hr/",stname),row.names=FALSE, col.names=FALSE,na = "NaN")
}

