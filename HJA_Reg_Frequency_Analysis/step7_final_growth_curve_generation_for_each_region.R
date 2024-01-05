rm(list = ls())
library(lmomRFA)
library(zoo)
library(pracma)
#RG=list.files('G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/ONSITE/Annual_Maxima/use/')
dur=list.files('D:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/ONSITE/Annual_Maxima/use/PRIMET/')
pf=list()
for (d in 1:length(dur)){
  outf = data.frame(
    station = as.character(c("H15MET","PRIMET","UPLMET")),
    longitude = as.numeric(c(-83.468122,-83.4301,-83.4287)),
    latitude = as.numeric(c(35.032747,35.060411,35.055308)),
    cluster = as.numeric(c(1,1,1))
  )
  cld=unique(outf[,4])
  cluster=matrix(ncol=9);outg25=list();outg50=list();outg25p=list();outg50p=list();outg100=list();outg100p=list();
  for (c in 1:length(cld)){
    clfiles=outf[which(outf[,4]==cld[c]),1]
    data=list();means=matrix()
    cfdat=matrix(NA,ncol=1,nrow=46);
    for (i in 1:length(clfiles)){
      print(i)
      data1=read.table(paste0('D:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/ONSITE/Annual_Maxima/use/',clfiles[i],'/',dur[d]))
      cfdat=cbind(cfdat,as.numeric(data1[,2]))
      ts=zoo(data1[,2],seq(1,20,by=1))
      m <- lm(coredata(ts) ~ index(ts))
      detr <- zoo(resid(m), index(ts))
      #dt=detrend(data1[,2])
      dt=data1[,2]
      data[[i]]=t(dt);
    }
    cfdat=as.data.frame(cfdat[,2:4])
    names(data) <- c(clfiles)
    
    lmomobj=regsamlmu(data)
    
    lmomobj=na.omit(lmomobj)
    rmom <- regavlmom(lmomobj) # Regional average L-moments        
    rfit <- regfit(lmomobj, "gev")  # Fit a generalized extreme-value distribution
    rfit                            # Print details of the fitted distribution
    nsites <- nrow(lmomobj)
    means <- lmomobj$l_1
    LCVrange <- 0.025
    LCVs <- seq(rmom[2]-LCVrange/2, rmom[2]+LCVrange/2, len=nsites)
    Lskews<-rep(rmom[3], nsites)
    
    # Each site will have a generalized normal distribution:
    # get the parameter values for each site
    pp <- t(apply(cbind(means, means*LCVs ,Lskews), 1, pelgev))
    pp
    parameter=rbind(rfit$para,pp)
    write.table(parameter,paste0("D:/Sourav/USFS/Revised/HJ Andrews/RFA_GEV_parameters/",dur[d]),row.names=FALSE, col.names=FALSE,na = "NaN")
    
    # Set correlation between each pair of sites to 0.64, the
    # average inter-site correlation for the lmomobj data
    #if (length(clfiles)>1){
    #avcor=cor(as.numeric(cfdat[,1]), as.numeric(cfdat[,2]))}else{
    #avcor=1}
    avcor=cor(cfdat)
    #avcor <- 0.5
    T=seq(2,500,by=1)
    p=1-(1/T)
    # AMS based: Run the simulation.  To save time, use only 100 replications.
    simq <- regsimq(qfunc=quagev, para=pp,  cor = avcor, nrec=lmomobj$n,  nrep=1000, fit="gev",f = p,
                    boundprob = c(0.10, 0.90), save = TRUE)
    # convert ARI to AEP
    #pds=(exp(-(1/T)))
    # PDS based: Run the simulation.  To save time, use only 100 replications.
    #simqpds <- regsimq(qfunc=quagev, para=pp, cor=avcor, nrec=lmomobj$n,  nrep=1000, fit="gev",f = pds,
    #boundprob = c(0.10, 0.90), save = TRUE)
    
    # Apply the simulated bounds to the estimated regional growth curve
    rgCI=regquantbounds(simq, rfit)
    #rgCIpds=regquantbounds(simqpds, rfit)
    F_ind_site=as.matrix(rfit$index) # Index flood values
    pf=rbind(pf,cbind(dur[d],t(rfit$para),t(rfit$index)))
    
    for (s in 1:length(lmomobj[,1])){
      # Apply the simulated bounds to quantiles for site 3
      stCI=sitequantbounds(simq, rfit, site=s);
      #stpdsCI=sitequantbounds(simqpds, rfit, site=s)
      #output=cbind(rep(cld[c],length(stCI[,1])),rep(grids[s,1],length(stCI[,1])),rep(grids[s,2],length(stCI[,1])),rep(F_ind_site[s,1],length(stCI[,1])),stCI)
      #outputpds=cbind(rep(cld[c],length(stpdsCI[,1])),rep(grids[s,1],length(stpdsCI[,1])),rep(grids[s,2],length(stpdsCI[,1])),rep(F_ind_site[s,1],length(stpdsCI[,1])),stpdsCI)
      #write.table(output,paste0("G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Return_levels_stations_revised/AMS/",dur[d],"/data_",grids[s,1],"_",grids[s,2]),row.names=FALSE, col.names=FALSE,na = "NaN")
      #write.table(outputpds,paste0("G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Return_levels_stations_revised/PDS/",dur[d],"/data_",grids[s,1],"_",grids[s,2]),row.names=FALSE, col.names=FALSE,na = "NaN")
      
      ## FOR Figure 1 25-year and 50-year
      z25=which(stCI[,1]==(1-(1/25)),arr.ind = TRUE)
      z50=which(stCI[,1]==(1-(1/50)),arr.ind = TRUE)
      z100=which(stCI[,1]==(1-(1/100)),arr.ind = TRUE)
      outg=rbind(cbind(25,stCI[z25,4],stCI[z25,2],stCI[z25,5],F_ind_site[s,1]),cbind(50,stCI[z50,4],stCI[z50,2],stCI[z50,5],F_ind_site[s,1]),cbind(100,stCI[z100,4],stCI[z100,2],stCI[z100,5],F_ind_site[s,1]))
      outgf=list()
      for (rl in 2:500){
        zrl=which(stCI[,1]==(1-(1/rl)),arr.ind = TRUE)
        outgf=rbind(outgf,cbind(rl,stCI[zrl,4],stCI[zrl,2],stCI[zrl,5]))
      }
      #z25p=which(stpdsCI[,1]==exp(-(1/25)),arr.ind = TRUE)
      #z50p=which(stpdsCI[,1]==exp(-(1/50)),arr.ind = TRUE)
      #z100p=which(stpdsCI[,1]==exp(-(1/100)),arr.ind = TRUE)
      
      
      #outg25=rbind(outg25,cbind(grids[s,],stCI[z25,4],stCI[z25,2],stCI[z25,5],cld[c],F_ind_site[s,1]))
      #outg50=rbind(outg50,cbind(grids[s,],stCI[z50,4],stCI[z50,2],stCI[z50,5],cld[c],F_ind_site[s,1]))
      #outg100=rbind(outg100,cbind(grids[s,],stCI[z100,4],stCI[z100,2],stCI[z100,5],cld[c],F_ind_site[s,1]))
      
      #outg25p=rbind(outg25p,cbind(grids[s,],stpdsCI[z25p,4],stpdsCI[z25p,2],stpdsCI[z25p,5],cld[c],F_ind_site[s,1]))
      #outg50p=rbind(outg50p,cbind(grids[s,],stpdsCI[z50p,4],stpdsCI[z50p,2],stpdsCI[z50p,5],cld[c],F_ind_site[s,1]))
      #outg100p=rbind(outg100p,cbind(grids[s,],stpdsCI[z100p,4],stpdsCI[z100p,2],stpdsCI[z100p,5],cld[c],F_ind_site[s,1]))
      RG=lmomobj$name
      #write.table(outg,paste0("G:/Sourav/USFS/Revised/HJ Andrews/RFA_results/",RG[s],"/",dur[d]),row.names=FALSE, col.names=FALSE,na = "NaN")
      #write.table(outgf,paste0("G:/Sourav/USFS/Revised/HJ Andrews/RFA_results_all/",RG[s],"/",dur[d]),row.names=FALSE, col.names=FALSE,na = "NaN")
      
    }
   
    #write.table(rgCI,paste0("G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Return_levels_regions_revised/AMS/",dur[d],"/region_",cld[c]),row.names=FALSE, col.names=FALSE,na = "NaN")
    #write.table(rgCIpds,paste0("G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Return_levels_regions_revised/PDS/",dur[d],"/region_",cld[c]),row.names=FALSE, col.names=FALSE,na = "NaN")
    
    
  }  # loop for regions ends
  #write.table(outg25,paste0("G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Fig1_plot_inputs_revised/point_RLs/AMS/25yr_",dur[d]),row.names=FALSE, col.names=FALSE,na = "NaN")
  #write.table(outg50,paste0("G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Fig1_plot_inputs_revised/point_RLs/AMS/50yr_",dur[d]),row.names=FALSE, col.names=FALSE,na = "NaN")
  #write.table(outg100,paste0("G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Fig1_plot_inputs_revised/point_RLs/AMS/100yr_",dur[d]),row.names=FALSE, col.names=FALSE,na = "NaN")
  
  #write.table(outg25p,paste0("G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Fig1_plot_inputs_revised/point_RLs/PDS/25yr_",dur[d]),row.names=FALSE, col.names=FALSE,na = "NaN")
  #write.table(outg50p,paste0("G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Fig1_plot_inputs_revised/point_RLs/PDS/50yr_",dur[d]),row.names=FALSE, col.names=FALSE,na = "NaN")
  #write.table(outg100p,paste0("G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Fig1_plot_inputs_revised/point_RLs/PDS/100yr_",dur[d]),row.names=FALSE, col.names=FALSE,na = "NaN")
  
}  # loop for duration ends

write.table(pf,paste0("D:/Sourav/USFS/Revised/HJ Andrews/RFA_parameters_GEV"),row.names=FALSE, col.names=FALSE,na = "NaN")
