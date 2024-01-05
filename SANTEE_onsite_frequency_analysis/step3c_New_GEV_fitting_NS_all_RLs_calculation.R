
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

files=list.files("G:/Sourav/USFS/Revised/Santee/Annual_Maxima_Series/")

for(m in 1:length(files)){
  print(files[m])
  out=as.data.frame(read.table(paste0("G:/Sourav/USFS/Revised/Santee/Annual_Maxima_Series/",files[m]),fill=TRUE))
  out=out[complete.cases(out[,2]),]
  colnames(out)=c("Year","AnMax")
  
  ## Non-stationary
  m1 <- fevd(AnMax,data=out, location.fun = ~1,scale.fun = ~1,shape.fun = ~1,type = c("GEV"),method = "Bayesian",use.phi = TRUE, iter = 1000)
  m2 <- fevd(AnMax,data=out, location.fun = ~Year,scale.fun = ~1,shape.fun = ~1,type = c("GEV"),method = "Bayesian",use.phi = TRUE, iter = 1000)
  m3 <- fevd(AnMax,data=out, location.fun = ~1,scale.fun = ~Year,shape.fun = ~1,type = c("GEV"),method = "Bayesian",use.phi = TRUE, iter = 1000)
  m4 <- fevd(AnMax,data=out, location.fun = ~Year,scale.fun = ~Year,shape.fun = ~1,type = c("GEV"),method = "Bayesian",use.phi = TRUE, iter = 1000)
  
  bf12=BayesFactor(m1, m2, burn.in = 100, method = "harmonic")
  bf13=BayesFactor(m1, m3, burn.in = 100, method = "harmonic")
  bf14=BayesFactor(m1, m4, burn.in = 100, method = "harmonic")
  bf23=BayesFactor(m2, m3, burn.in = 100, method = "harmonic")
  bf24=BayesFactor(m2, m4, burn.in = 100, method = "harmonic")
  bf34=BayesFactor(m3, m4, burn.in = 100, method = "harmonic")
  
  ## model selection
  dic1=summary(m1)$DIC
  dic2=summary(m2)$DIC
  dic3=summary(m3)$DIC
  dic4=summary(m4)$DIC
  
  dic_out=rbind(cbind(1,dic1),cbind(2,dic2),cbind(3,dic3),cbind(4,dic4))
  z=which.min(dic_out[,2])
  print(z)
  
  rl25s=return.level(m1, return.period =  seq(2,500,by=1),alpha=0.1,do.ci = TRUE,R = 10000)
  rl50s=return.level(m1, return.period =  seq(2,500,by=1),alpha=0.1,do.ci = TRUE,R = 10000)
  rl100s=return.level(m1, return.period =  seq(2,500,by=1),alpha=0.1,do.ci = TRUE,R = 10000)
  
  if(z==2){
    x1=make.qcov(m2)
    outrl25=list();outrl50=list();outrl100=list()
    for(i in 2:500){
    rl25n=return.level(as.list(paste0("m",2)), return.period =  i,alpha=0.1,FUN = "mean",burn.in = 499,qcov = x1,qcov.base = NULL,do.ci = TRUE,R = 10000)
    rl50n=return.level(m2, return.period =  i,alpha=0.1,FUN = "mean",burn.in = 499,qcov = x1,qcov.base = NULL,do.ci = TRUE,R = 10000)
    rl100n=return.level(m2, return.period =  i,alpha=0.1,FUN = "mean",burn.in = 499,qcov = x1,qcov.base = NULL,do.ci = TRUE,R = 10000)
    outrl25=rbind(outrl25,cbind(i,quantile(rl25n[,1], probs = 0.5),quantile(rl25n[,2], probs = 0.5),quantile(rl25n[,3], probs = 0.5)))
    }
  }
  if(z==3){
    x1=make.qcov(m3)
    rl25n=return.level(m3, return.period =  25,alpha=0.1,FUN = "mean",burn.in = 499,qcov = x1,qcov.base = NULL,do.ci = TRUE,R = 10000)
    rl50n=return.level(m3, return.period =  50,alpha=0.1,FUN = "mean",burn.in = 499,qcov = x1,qcov.base = NULL,do.ci = TRUE,R = 10000)
    rl100n=return.level(m3, return.period =  100,alpha=0.1,FUN = "mean",burn.in = 499,qcov = x1,qcov.base = NULL,do.ci = TRUE,R = 10000)
  }
  if(z==4){
    x1=make.qcov(m4)
    rl25n=return.level(m4, return.period =  25,alpha=0.1,FUN = "mean",burn.in = 499,qcov = x1,qcov.base = NULL,do.ci = TRUE,R = 10000)
    rl50n=return.level(m4, return.period =  50,alpha=0.1,FUN = "mean",burn.in = 499,qcov = x1,qcov.base = NULL,do.ci = TRUE,R = 10000)
    rl100n=return.level(m4, return.period =  100,alpha=0.1,FUN = "mean",burn.in = 499,qcov = x1,qcov.base = NULL,do.ci = TRUE,R = 10000)
  }
  
  if(z!=1){
    rl25=cbind(25,quantile(rl25n[,1], probs = 0.5),quantile(rl25n[,2], probs = 0.5),quantile(rl25n[,3], probs = 0.5))
    rl50=cbind(50,quantile(rl50n[,1], probs = 0.5),quantile(rl50n[,2], probs = 0.5),quantile(rl50n[,3], probs = 0.5))
    rl100=cbind(100,quantile(rl100n[,1], probs = 0.5),quantile(rl100n[,2], probs = 0.5),quantile(rl100n[,3], probs = 0.5))
    rloutn=rbind(rl25,rl50,rl100)
    write.table(rloutn, paste0("G:/Sourav/USFS/Revised/Santee/Return_Level_GEV/NS_bayesian/RL_ns/",files[m]),row.names=FALSE, col.names=FALSE)
  }
  rlouts= rbind(cbind(25,rl25s[1],rl25s[2],rl25s[3]),cbind(50,rl50s[1],rl50s[2],rl50s[3]),cbind(100,rl100s[1],rl100s[2],rl100s[3])) 
  write.table(dic_out, paste0("G:/Sourav/USFS/Revised/Santee/Return_Level_GEV/NS_bayesian/DIC/",files[m]),row.names=FALSE, col.names=FALSE)
  write.table(rlouts, paste0("G:/Sourav/USFS/Revised/Santee/Return_Level_GEV/NS_bayesian/RL_s/",files[m]),row.names=FALSE, col.names=FALSE)
  
}


