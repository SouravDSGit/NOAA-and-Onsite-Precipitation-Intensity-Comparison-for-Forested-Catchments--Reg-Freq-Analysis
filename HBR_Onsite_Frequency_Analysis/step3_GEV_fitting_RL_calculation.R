
####################################### Stationary GEV Fit #####################################
rm(list = ls())
library(eva)
library(ismev)
library(extRemes)
library(modifiedmk)
library(ggpubr)
library(ggplot2)
library(plotly)
files=list.files("G:/Sourav/USFS/Revised/Hubbard_Brook/L4/Annual_Maxima_Series/")

for(m in 1:length(files)){
  out=as.data.frame(read.table(paste0("G:/Sourav/USFS/Revised/Hubbard_Brook/L4/Annual_Maxima_Series/",files[m]),fill=TRUE))
  out=out[complete.cases(out[,2]),]
  colnames(out)=c("Year","AnMax")
  mk=mkttest(out[,2])
  if(mk[5]>0.1){
  ## Bayesian
  fitbayes=fevd(AnMax,data=out,location.fun = ~1,
            scale.fun = ~1, shape.fun = ~1,type="GEV",method = c("Bayesian"),iter = 9999)
  rlb=return.level(fitbayes, return.period =  c(2, 5, 10, 20, 25,30,35,40,45,50,100),alpha=0.1,do.ci = TRUE)
  ## MLE
  fitmle=fevd(AnMax,data=out,location.fun = ~1,
               scale.fun = ~1, shape.fun = ~1,type="GEV",method = c("MLE"))
  rlmle=return.level(fitmle, return.period =  c(2, 5, 10, 20, 25,30,35,40,45,50,100),alpha=0.1,do.ci = TRUE)
  
  ## Lmoments
  fitlmom=fevd(AnMax,data=out,location.fun = ~1,
               scale.fun = ~1, shape.fun = ~1,type="GEV",method = c("Lmoments"))
  rlmom=return.level(fitlmom, return.period =  c(2, 5, 10, 20, 25,30,35,40,45,50,100),alpha=0.1,do.ci = TRUE,R = 10000)
  
  write.table(rlb, paste0("G:/Sourav/USFS/Revised/Hubbard_Brook/L4/Return Level/Bayesian/",files[m]),row.names=FALSE, col.names=FALSE)
  write.table(rlmle, paste0("G:/Sourav/USFS/Revised/Hubbard_Brook/L4/Return Level/MLE/",files[m]),row.names=FALSE, col.names=FALSE)
  write.table(rlmom, paste0("G:/Sourav/USFS/Revised/Hubbard_Brook/L4/Return Level/Lmoments/",files[m]),row.names=FALSE, col.names=FALSE)
  }else{rm(rlb)}
  x=c(2, 5, 10, 20, 25,30,35,40,45,50,100)
  rlbf=cbind(rep('Bayesian',11),x,rlb);
  rlmlef=cbind(rep('MLE',11),x,rlmle);
  rlmomf=cbind(rep('L-moments',11),x,rlmom);
  
  data=data.frame(rbind(rlbf,rlmlef,rlmomf))
  colnames(data)=c('Group','RP','Lower','Middle','Upper')
  data$RP=as.numeric(data$RP);data$Lower=as.numeric(data$Lower);
  data$Middle=as.numeric(data$Middle);data$Upper=as.numeric(data$Upper)
  g=ggplot(data=data, aes(y=Middle, x=RP, group=Group, colour=Group,fill=Group)) +
  geom_ribbon(aes(ymin = Lower, ymax = Upper),alpha=.2, linetype=0) +
    geom_line() +
    theme_classic()+scale_y_continuous(name="Precipitation Intensity (in/hr)", breaks = seq(0, 1, by=0.05)) +
    scale_x_continuous(name="Return Period (year)")
}