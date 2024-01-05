
####################################### Stationary GEV Fit #####################################
rm(list = ls())
library(extRemes)

files=list.files("D:/Sourav/USFS/Revised/Fraser/Annual_Maxima_Series/")
prf=list()
for(m in 1:length(files)){
  print(files[m])
  out=as.data.frame(read.table(paste0("D:/Sourav/USFS/Revised/Fraser/Annual_Maxima_Series/",files[m]),fill=TRUE))
  out=out[complete.cases(out[,2]),]
  colnames(out)=c("Year","AnMax")
  #out[,2]=detrend(out[,2]);
  ## Stationary
  ## Lmoments
  fitlmom=fevd(AnMax,data=out,location.fun = ~1,
               scale.fun = ~1, shape.fun = ~1,type="GEV",method = c("Lmoments"))
  rlmom=return.level(fitlmom, return.period =  seq(2,500,by=1),alpha=0.1,do.ci = TRUE,R = 10000)
  x=seq(2,500,by=1)
  rlmom=cbind(x,rlmom)
  #write.table(rlmom, paste0("G:/Sourav/USFS/Revised/Fraser/Return_Level_GEV/Lmoments/",files[m]),row.names=FALSE, col.names=FALSE)
  parl=ci(fitlmom, alpha = 0.1, type = c("parameter"),which.par, R = 1000)
  #write.table(parl, paste0("G:/Sourav/USFS/Revised/Fraser/GEV_parameters/Lmoments/",files[m]),row.names=FALSE, col.names=FALSE)
  prf=rbind(prf,cbind(files[m],t(parl[1,]),t(parl[2,]),t(parl[3,])))
  
}
write.table(prf, paste0("D:/Sourav/USFS/Revised/Fraser/GEV_parameters_Lmoments"),row.names=FALSE, col.names=FALSE)

