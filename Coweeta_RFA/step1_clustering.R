rm(list = ls())
library(lmomRFA)
files=list.files('G:/Sourav/USFS/Revised/Coweeta/Annual_Maxima_Series/')

#out=read.table(paste0('G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Input_for_clustering_plot'))

#outf=cbind(files,out)
outf = data.frame(
  station = as.character(c("RG31","RG06","RG41")),
  longitude = as.numeric(c(-83.468122,-83.4301,-83.4287)),
  latitude = as.numeric(c(35.032747,35.060411,35.055308)),
  cluster = as.numeric(c(1,2,2))
)
cld=unique(outf[,4])
cluster=matrix(ncol=9);
for (c in 1:length(cld)){
  clfiles=outf[which(outf[,4]==cld[c]),1]
  data=list();means=matrix()
  for (i in 1:length(clfiles)){
    print(i)
    data1=read.table(paste0('G:/Sourav/USFS/Revised/Coweeta/Annual_Maxima_Series/',clfiles[i],'/01hrs'))
    x=data1[,2];
    data[[i]]=t(x);
  }
  names(data) <- c(clfiles)
  
  lmomobj=regsamlmu(data)
  
  lmomobj=na.omit(lmomobj)
  
  rmom<-regavlmom(lmomobj) # Regional average L-moments
  
  
  # Set up an artificial region to be simulated:
  # -- Same number of sites as Cascades
  # -- Same record lengths as Cascades
  # -- Mean 1 at every site (results do not depend on the site means)
  # -- L-CV varies linearly across sites, with mean value equal
  #    to the regional average L-CV for the Cascades data.
  #    'LCVrange' specifies the  range of L-CV across the sites.
  # -- L-skewness the same at each site, and equal to the regional
  #    average L-skewness for the Cascades data
  nsites <- nrow(lmomobj)
  means <- rep(1,nsites)
  LCVrange <- 0.025
  LCVs <- seq(rmom[2]-LCVrange/2, rmom[2]+LCVrange/2, len=nsites)
  Lskews<-rep(rmom[3], nsites)
  
  # Each site will have a generalized normal distribution:
  # get the parameter values for each site
  pp <- t(apply(cbind(means, means*LCVs ,Lskews), 1, pelgev))
  
  # Set correlation between each pair of sites to 0.64, the
  # average inter-site correlation for the Cascades data
  avcor <- 0.64
  
  # Run the simulation.  It will take some time (about 25 sec
  # on a Lenovo W500, a moderately fast 2011-vintage laptop)
  # Note that the results are consistent with the statement
  # "the average H value of simulated regions is 1.08"
  # in Hosking and Wallis (1997, p.98).
  set.seed(123)
  homog=regsimh(qfunc=quagev, para=pp, cor=avcor, nrec=lmomobj$n,
                nrep=100)
  v=as.matrix(homog$means);
  cluster=rbind(cluster,cbind(cld[c],t(v)))
  
  library(lmom)
  lmrd(lmomobj,twopar="GUM",xlim=c(0,0.6),ylim=c(0,0.5),xlegend=0.02)
}

cluster=as.data.frame(na.omit(cluster))
library("writexl")
write_xlsx(cluster,"G:/Sourav/USFS/Revised/Coweeta/homogenoeous_regions/Homogeneous_region_statistics.xlsx")
