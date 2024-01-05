rm(list = ls())
#### follow: https://rpubs.com/r_anisa/kriging-interpolation
library(sp)
library(gstat)
library(pracma)
library("RColorBrewer", lib.loc="~/R/win-library/4.0")
library(geoR)
# packages for manipulation & visualization
suppressPackageStartupMessages({
  library(dplyr) # for "glimpse"
  library(ggplot2)
  library(scales) # for "comma"
  library(magrittr)
})

grids=read.table(paste0('G:/Sourav/USFS/Revised/HJ Andrews/Oregon_DEM/unique_final_interpolated'))

dur=list.files('G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Input_for_krigging_revised/AMS/')

for (d in 1:length(dur)){
  print(dur[d])
  files=list.files(paste0('G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Input_for_krigging_revised/AMS/',dur[d],'/'))
  for(t in 1:length(files)){
  data=read.table(paste0('G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Input_for_krigging_revised/AMS/',dur[d],'/',files[t]))
  data=as.data.frame(data)
  colnames(data)=c('longitude','latitude','CI5','PE','CI95')
  out=read.table(paste0('G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Input_for_clustering_plot_1hr'))
  z=match(do.call(paste, data.frame(data[,1:2])), do.call(paste, data.frame(out[,3:4])))
  data[,6]=out[z,2]
  
  #ouptput=rbind()
  #class(data)
  #str(data)
  ##### convert it to a spatial dataframe
  
  #data1@data %>% glimpse
  #data %>% as.data.frame %>% glimpse
  output=matrix()
  for (c in 3:5){
  data1=as.data.frame(cbind(data[,1:2],data[,c],data[,6]))
  colnames(data1)=c('longitude','latitude','PE','elev')
  coordinates(data1) <- ~ longitude + latitude
  #class(data)
  #str(data)
  h=bbox(data1)  ##### bounding box of the region
  coordinates(data1) %>% glimpse
  proj4string(data1)
  identical( bbox(data1), data1@bbox )
  identical( coordinates(data1), data1@coords )
  
  
  lzn.vgm <- variogram(log(PE)~elev, data1) # calculates sample variogram values 
  #lzn.vgm <- variogram(log(PE)~1, data1) # calculates sample variogram values 
  #lzn.fit <- fit.variogram(lzn.vgm, model=vgm(1, "Sph", 100, 1)) # fit model
  
  lzn.fit <- fit.variogram(lzn.vgm, vgm(c("Exp", "Ste", "Sph")), fit.kappa = seq(.3,5,.01))
  #lzn.fit <- fit.variogram(lzn.vgm, vgm(psill=max(lzn.vgm$gamma)*0.9, model = "Sph", range=max(lzn.vgm$dist)/2, nugget = mean(lzn.vgm$gamma)/4))
  
  plot(lzn.vgm, lzn.fit) # plot the sample values, along with the fit model
  
  grids=as.data.frame(grids)
  colnames(grids)=c('x','y','elev')
  coordinates(grids) <- ~ x + y # step 3 above
  ## Perform Krigging
  lzn.kriged <- krige(log(PE) ~ elev, data1, grids, model=lzn.fit)
  
  pts <- list("sp.points",data1,pch=3,col="black")
  data1.layout <- list(pts)
  lzn.kriged$var1.pred=exp(lzn.kriged$var1.pred)
  spplot(lzn.kriged["var1.pred"], sp.layout=data1.layout, main="cokriging predictions-Zn/distance river ")
  
  #lzn.kriged %>% as.data.frame %>%
    #ggplot(aes(x=x, y=y)) + geom_tile(aes(fill=exp(var1.pred))) + coord_equal() +
    #scale_colour_brewer(palette = "Spectral")+
    #scale_fill_gradient(low = "yellow", high="darkblue") +
    #scale_x_continuous(labels=comma) + scale_y_continuous(labels=comma) +
    #theme_classic()
  out=as.data.frame(lzn.kriged)
  output=cbind(output,cbind(out[,1:2],exp(out[,3])))
  
  }
  output=output[,2:10]
  #write.table(output,paste0('G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Output_for_krigging_revised/AMS/',dur[d],'/',files[t]),row.names=FALSE, col.names=FALSE,na = "NaN")

}
}
