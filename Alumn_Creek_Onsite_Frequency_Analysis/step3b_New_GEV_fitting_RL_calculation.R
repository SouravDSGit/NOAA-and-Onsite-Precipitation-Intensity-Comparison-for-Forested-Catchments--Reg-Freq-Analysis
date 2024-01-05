
####################################### Stationary GEV Fit #####################################
rm(list = ls())
library(extRemes)

files=list.files("D:/Sourav/USFS/Revised/Alum Creek (AC04)/Annual_Maxima_Series/")
prf=list()
for(m in 1:length(files)){
  print(files[m])
  out=as.data.frame(read.table(paste0("D:/Sourav/USFS/Revised/Alum Creek (AC04)/Annual_Maxima_Series/",files[m]),fill=TRUE))
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
  #write.table(rlmom, paste0("G:/Sourav/USFS/Revised/Alum Creek (AC04)/Return_Level_GEV/Lmoments/",files[m]),row.names=FALSE, col.names=FALSE)
  parl=ci(fitlmom, alpha = 0.1, type = c("parameter"),which.par, R = 1000)
  #write.table(parl, paste0("G:/Sourav/USFS/Revised/Alum Creek (AC04)/GEV_parameters/Lmoments/",files[m]),row.names=FALSE, col.names=FALSE)
  prf=rbind(prf,cbind(files[m],t(parl[1,]),t(parl[2,]),t(parl[3,])))
  
}
write.table(prf, paste0("D:/Sourav/USFS/Revised/Alum Creek (AC04)/GEV_parameters_Lmoments"),row.names=FALSE, col.names=FALSE)

####################################### Stationary GEV Fit #####################################
rm(list = ls())
library(eva)
library(ismev)
library(extRemes)
#library(modifiedmk)
#library(ggpubr)
library(ggplot2)
library(plotly)
library(mkac)

files=list.files("G:/Sourav/USFS/Revised/Alum Creek (AC04)/Annual_Maxima_Series/")

for(m in 1:length(files)){
  print(files[m])
  out=as.data.frame(read.table(paste0("G:/Sourav/USFS/Revised/Alum Creek (AC04)/Annual_Maxima_Series/",files[m]),fill=TRUE))
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
  write.table(rlmom, paste0("G:/Sourav/USFS/Revised/Alum Creek (AC04)/Return_Level_GEV/Lmoments/",files[m]),row.names=FALSE, col.names=FALSE)
  #parl=ci(fitlmom, alpha = 0.1, type = c("parameter"),which.par, R = 1000)
  #write.table(parl, paste0("G:/Sourav/USFS/Revised/Alum Creek (AC04)/GEV_parameters/Lmoments/",files[m]),row.names=FALSE, col.names=FALSE)
  
  ## Stationary-Bayesian
  m1 <- fevd(AnMax,data=out, location.fun = ~1,scale.fun = ~1,shape.fun = ~1,type = c("GEV"),method = "Bayesian",use.phi = TRUE, iter = 1000)
  rls=return.level(m1, return.period =  seq(2,500),alpha=0.1,do.ci = TRUE,R = 10000)
  write.table(cbind(x,rls), paste0("G:/Sourav/USFS/Revised/Alum Creek (AC04)/Return_Level_GEV/NS_bayesian/RL_s/",files[m]),row.names=FALSE, col.names=FALSE)
  
  ## Non-stationary Bayesian
  m2 <- fevd(AnMax,data=out, location.fun = ~Year,scale.fun = ~1,shape.fun = ~1,type = c("GEV"),method = "Bayesian",use.phi = TRUE, iter = 1000)
  m3 <- fevd(AnMax,data=out, location.fun = ~1,scale.fun = ~Year,shape.fun = ~1,type = c("GEV"),method = "Bayesian",use.phi = TRUE, iter = 1000)
  m4 <- fevd(AnMax,data=out, location.fun = ~Year,scale.fun = ~Year,shape.fun = ~1,type = c("GEV"),method = "Bayesian",use.phi = TRUE, iter = 1000)
  
  ## model selection using DIC
  dic1=summary(m1)$DIC
  dic2=summary(m2)$DIC
  dic3=summary(m3)$DIC
  dic4=summary(m4)$DIC
  
  dic_out=rbind(cbind(1,dic1),cbind(2,dic2),cbind(3,dic3),cbind(4,dic4))
  write.table(dic_out, paste0("G:/Sourav/USFS/Revised/Alum Creek (AC04)/Return_Level_GEV/NS_bayesian/DIC/",files[m]),row.names=FALSE, col.names=FALSE)
  
  z=which.min(dic_out[,2])
  print(z)
  
  if(z==2){
    x1=make.qcov(m2,nr=length(out[,1]))
    x1[,2]=seq(1,length(out[,1]))
    outrl=list();
    for(i in 2:500){
      rln=return.level(m2, return.period =  i,alpha=0.1,FUN = "mean",burn.in = 499,qcov = x1,qcov.base = NULL,do.ci = TRUE,R = 10000)
      outrl=rbind(outrl,cbind(i,quantile(rln[,1], probs = 0.5),quantile(rln[,2], probs = 0.5),quantile(rln[,3], probs = 0.5)))
    }
    
  }
  if(z==3){
    x1=make.qcov(m3,nr=length(out[,1]))
    x1[,3]=seq(1,length(out[,1]))
    outrl=list();
    for(i in 2:500){
      rln=return.level(m3, return.period =  i,alpha=0.1,FUN = "mean",burn.in = 499,qcov = x1,qcov.base = NULL,do.ci = TRUE,R = 10000)
      outrl=rbind(outrl,cbind(i,quantile(rln[,1], probs = 0.5),quantile(rln[,2], probs = 0.5),quantile(rln[,3], probs = 0.5)))
    }
    
  }
  if(z==4){
    x1=make.qcov(m4,nr=length(out[,1]))
    x1[,2]=seq(1,length(out[,1]));x1[,4]=seq(1,length(out[,1]));
    outrl=list();
    for(i in 2:500){
      rln=return.level(m4, return.period =  i,alpha=0.1,FUN = "mean",burn.in = 499,qcov = x1,qcov.base = NULL,do.ci = TRUE,R = 10000)
      outrl=rbind(outrl,cbind(i,quantile(rln[,1], probs = 0.5),quantile(rln[,2], probs = 0.5),quantile(rln[,3], probs = 0.5)))
    }
    
  }
  write.table(outrl, paste0("G:/Sourav/USFS/Revised/Alum Creek (AC04)/Return_Level_GEV/NS_bayesian/RL_ns/",files[m]),row.names=FALSE, col.names=FALSE)
  
}

