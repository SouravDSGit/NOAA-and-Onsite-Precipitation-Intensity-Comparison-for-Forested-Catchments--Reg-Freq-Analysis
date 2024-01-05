rm(list = ls())
library(rnoaa)
library(writexl)

delta=seq(42,46.5,by=0.25);
stf=list();q=length(delta)-1
for (i in 1:q){
st=ncdc_stations(datasetid='PRECIP_HLY', startdate='19480101', enddate='20131231',extent=c(delta[i],-124.0,delta[i+1],-115.5),token="mXWfzZxQMWzemFzEmmeqnmPYKyeWNSoU")
stout=as.data.frame(st$data)
stf=rbind(stf,stout)
}
stf=unique(stf)
write_xlsx(stf,paste0("D:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/all_stations.xlsx"),col_names = TRUE,format_headers = TRUE,use_zip64 = FALSE)  
start=as.numeric(gsub('-', '', stf$mindate));startf=as.numeric(gsub("(^\\d{4}).*", "\\1", start))
endd=as.numeric(gsub('-', '', stf$maxdate));endf=as.numeric(gsub("(^\\d{4}).*", "\\1", endd))
stf$ny=endf-startf+1
kout=list()
for (i in 1:length(stf[,1])){
  if(startf[i]<=1990&&endf[i]>=2013){
    kout=rbind(kout,1)
  }else
    kout=rbind(kout,0)
}
z=which(kout==1)
stfz=stf[z,];
write_xlsx(stfz,paste0("D:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/selected_stations_1990_2013.xlsx"),col_names = TRUE,format_headers = TRUE,use_zip64 = FALSE)  
files=as.data.frame(list.files(paste0("D:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/NOAA_Oregon_1hr_precip/")))
files[,1]=as.data.frame(gsub('.xlsx', '', files[,1]))
stq=as.data.frame(gsub(':', '', stfz$id))
zx=match(stq[,1],files[,1])
zxi=which(is.na(zx)==TRUE)
stfz=stfz[zxi,];stfz$count=seq(1,length(stfz[,1]))
for (i in 1:length(stfz[,1])){
  dates=seq(as.Date(stfz$mindate[i]), as.Date(stfz$maxdate[i]), by="days")
  dataf=list();station=gsub(':', '', stfz$id[i]);
  c=seq(1,length(dates),by=200);b=length(c)-1;
  for(j in 1:b){
    print(j)
    
    data<-ncdc(datasetid='PRECIP_HLY', stationid=stfz$id[i], datatypeid='HPCP',limit=200,
    startdate = dates[c[j]], enddate = dates[c[j]+199],token="mXWfzZxQMWzemFzEmmeqnmPYKyeWNSoU",add_units = TRUE)   
    if(is_empty(data$data)==FALSE){
    out=data$data;
    dataf=rbind(dataf,out[,1:6])}
    else{
      print("NA")
    }
  }
  f1=c[length(c)]+1;f2=length(dates)
  data<-ncdc(datasetid='PRECIP_HLY', stationid=stfz$id[i], datatypeid='HPCP',limit=200,
             startdate = dates[f1], enddate = dates[f2],token="mXWfzZxQMWzemFzEmmeqnmPYKyeWNSoU",add_units = TRUE)   
  if(is_empty(data$data)==FALSE){
    out=data$data;
    dataf=rbind(dataf,out[,1:6])}
  else{
    print("NA")
  }
  write_xlsx(dataf,paste0("G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/NOAA_Oregon_1hr_precip_add/",station,".xlsx"),col_names = TRUE,format_headers = TRUE,use_zip64 = FALSE)  
}

#z=which(stf$id=="COOP:351058")
#data=read.csv(paste0("G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/3003809.csv"),skipNul = TRUE)
#u=as.data.frame(unique(data$STATION))
#m=intersect(u[,1],stf$id)
