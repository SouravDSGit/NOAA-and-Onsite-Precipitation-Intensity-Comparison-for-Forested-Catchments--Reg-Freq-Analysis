rm(list = ls())
library(lmomRFA)
library(zoo)
library(pracma)

dur=list.files('D:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/NOAA_Oregon_results/annual_maxima/1hr_based/COOP353604/')
out=read.table(paste0('D:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Input_for_clustering_plot_1hr'))
outf=cbind(out[,1],out[,3:5])
cld=unique(out[,5])

for (c in 1:length(cld)){
    clfiles=outf[which(outf[,4]==cld[c]),1]
    grids=outf[which(outf[,4]==cld[c]),2:3]
    
    pf=list() 
  for (d in 1:length(dur)){
    data=list();means=matrix()
  for (i in 1:length(clfiles)){
    print(i)
    
      data1=read.table(paste0('D:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/NOAA_Oregon_results/annual_maxima/1hr_based/',clfiles[i],'/',dur[d]))
      data1=data1[which(data1[,1]>=1979),]
      ts=zoo(data1[,2],seq(1,20,by=1))
      m <- lm(coredata(ts) ~ index(ts))
      detr <- zoo(resid(m), index(ts))
      #dt=detrend(data1[,2])
      dt=data1[,2]
      data[[i]]=t(dt);
    }
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
    
    # Set correlation between each pair of sites to 0.64, the
    # average inter-site correlation for the lmomobj data
    avcor <- 0.64
    T=seq(2,100,by=1)
    p=1-(1/T)
    # AMS based: Run the simulation.  To save time, use only 100 replications.
    simq <- regsimq(qfunc=quagev, para=pp, cor=avcor, nrec=lmomobj$n,  nrep=1000, fit="gev",f = p,
                    boundprob = c(0.10, 0.90), save = TRUE)
    # convert ARI to AEP
    pds=(exp(-(1/T)))
    # PDS based: Run the simulation.  To save time, use only 100 replications.
    simqpds <- regsimq(qfunc=quagev, para=pp, cor=avcor, nrec=lmomobj$n,  nrep=1000, fit="gev",f = pds,
                       boundprob = c(0.10, 0.90), save = TRUE)
    
    # Apply the simulated bounds to the estimated regional growth curve
    rgCI=regquantbounds(simq, rfit)
    rgCIpds=regquantbounds(simqpds, rfit)
    F_ind_site=as.matrix(rfit$index) # Index flood values
    pf=rbind(pf,cbind(dur[d],t(rfit$para),t(rfit$index)))
    
    
  } # loop for cluster ends
    write.table(pf,paste0("D:/Sourav/USFS/Revised/HJ Andrews/NOAA_RFA_GEV_parameters/",cld[c]),row.names=FALSE, col.names=TRUE,na = "NaN")
    
  
} # loop for regions ends 

