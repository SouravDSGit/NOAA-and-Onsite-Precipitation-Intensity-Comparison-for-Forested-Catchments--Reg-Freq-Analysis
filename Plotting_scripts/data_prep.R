
rm(list = ls())
library(readxl)
library(sf)
library(ggmap)
library(ggplot2)
df=read_xlsx(paste0("G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/selected_stations_1979_2013.xlsx"))

data=cbind(df$longitude,df$latitude,df$elevation)
write.table(data, paste0("G:/Sourav/USFS/Revised/Fig/Fig_supp_NOAA_RFA_station_selection/NOAA-stations/all_stations"),row.names=FALSE, col.names=FALSE,na = "NaN")
