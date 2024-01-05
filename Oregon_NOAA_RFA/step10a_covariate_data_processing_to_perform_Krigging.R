rm(list = ls())
library(raster)
rm(list = ls())
#### follow: https://gis.stackexchange.com/questions/260283/fit-variogram-iteration-warning
library(sp)
library(gstat)
library(pracma)
library("RColorBrewer", lib.loc="~/R/win-library/4.0")
library(geoR)
library(terrainr)
# packages for manipulation & visualization
suppressPackageStartupMessages({
  library(dplyr) # for "glimpse"
  library(ggplot2)
  library(scales) # for "comma"
  library(magrittr)
})

#grids=as.data.frame(read.table(paste0('G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Oregon_grids_for_krigging')))
#colnames(grids)<- c("x","y","c")
f <- list.files("G:/Sourav/USFS/Revised/HJ Andrews/Oregon_DEM/tif/")

for (i in 1:length(f)){
  print(i)
r <- raster(paste0('G:/Sourav/USFS/Revised/HJ Andrews/Oregon_DEM/tif/',f[i]))
xy <- data.frame(xyFromCell(r, 1:ncell(r)))
#lonmin=min(xy[,1]);lonmax=max(xy[,1]);latmin=min(xy[,2]);latmax=max(xy[,2])
#grid=subset(grids, x <= lonmax & x >= lonmin & y <= latmax & y >= latmin)

v <- getValues(r)
iz <- !is.na(v)
xy <- xy[iz,]
v <- v[iz]
datv=data.frame(longitude=xy[,1],latitude=xy[,2],dem=v)

write.table(datv,paste0('G:/Sourav/USFS/Revised/HJ Andrews/Oregon_DEM/tables/',f[i],'.txt'),row.names=FALSE, col.names=FALSE,na = "NaN")
}
