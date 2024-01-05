####################################### Clsutering #####################################
rm(list = ls())
library(lmomRFA)
output=list();
files=list.files(paste0('G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/NOAA_Oregon_results/all_stations/'))
for (m in 1:length(files)){
  print(m)
  data=read.table(paste0('G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/NOAA_Oregon_results/final_1hr/',files[m]))
  outd=list()
  for (y in seq(from=1, to=length(data[,1])-23, by=24)){
    a=y;b=y+23;
  outd=rbind(outd,cbind(data[y,1:3],sum(data[a:b,6],na.rm = TRUE)))
  }
  outy=list()
  for (yr in 1979:2013){
    zy=outd[which(outd[,1]==yr),]
    outm=list()
  for (x in 1:12){
    zm=zy[which(zy[,2]==x),]
    outm=rbind(outm,cbind(yr,x,sum(zm[,4],na.rm=TRUE)))
  }
    outy=rbind(outy,outm)
  }
  outy=as.matrix(outy)
  outy[,2]=as.numeric(outy[,2])
  xm=list()
  for(mo in 1:12){
  me=as.data.frame(outy[which(outy[,2]==mo),3])
  xm=rbind(xm,apply(me,1,mean)) 
  }
  
  output=rbind(output,cbind(files[m],data[1,7:9],mean(outd[,4]),t(xm)))
}
output=as.matrix(output)

write.table(output, paste0("G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Input_for_clustering_1hr"),row.names=FALSE, col.names=FALSE,na = "NaN")

#####################################################################################################################

##################################################################################
####################################### Clsutering #####################################
rm(list = ls())
library(lmomRFA)
library(factoextra)
library(NbClust)
library(cluster)
data=read.table(paste0('G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Input_for_clustering_1hr'))
att=data[,2:17];
# silhouette method
fviz_nbclust(att, hcut, method = "silhouette")+
  labs(subtitle = "Silhouette method")
# Elbow method
fviz_nbclust(att, hcut, method = "wss") +
  geom_vline(xintercept = 4, linetype = 2)+
  labs(subtitle = "Elbow method")


cl=cluagg(att,method="ward.D2")
inf <- cluinf(cl, 4)
clkm <- clukm(att, inf$assign)
g=table(Kmeans=clkm$cluster, Ward=inf$assign)

cl1=as.matrix(inf$list$cluster.1)
cl2=as.matrix(inf$list$cluster.2)
cl3=as.matrix(inf$list$cluster.3)
cl4=as.matrix(inf$list$cluster.4)
#cl5=as.matrix(inf$list$cluster.5)
#cl6=as.matrix(inf$list$cluster.6)
#cl7=as.matrix(inf$list$cluster.07)
#cl8=as.matrix(inf$list$cluster.08)
#cl9=as.matrix(inf$list$cluster.09)
#cl10=as.matrix(inf$list$cluster.10)
#cl11=as.matrix(inf$list$cluster.11)
#cl12=as.matrix(inf$list$cluster.12)
#cl13=as.matrix(inf$list$cluster.13)
#cl14=as.matrix(inf$list$cluster.14)
#cl15=as.matrix(inf$list$cluster.15)
#cl16=as.matrix(inf$list$cluster.16)
#cl17=as.matrix(inf$list$cluster.17)

data[cl1,18]=1;
data[cl2,18]=2;
data[cl3,18]=3;
data[cl4,18]=4;
#data[cl5,18]=5;
#data[cl6,18]=6;
#data[cl7,18]=7;
#data[cl8,18]=8;
#data[cl9,18]=9;
#data[cl10,18]=10;
#data[cl11,18]=11;
#data[cl12,18]=12;
#data[cl13,18]=13;
#data[cl14,18]=14;
#data[cl15,18]=15;
#data[cl16,18]=16;
#data[cl17,18]=17;
out=cbind(data[,1:4],data[,18]);
plot(out[,3],out[,4],pch=16,col=out[,5])
write.table(out, paste0("G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Input_for_clustering_plot_1hr"),row.names=FALSE, col.names=FALSE,na = "NaN")
################################################################################################


########################################### MAP OF OREGON LEVEL 1 ############################
###############################################################################################
rm(list = ls())
library(usmap)
library(ggplot2)
library(viridis)
mybreaks <- seq(1,15,by=1)

out2=read.table(paste0('G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/ONSITE/grid_locations/ONSITE.txt'))
outg=as.data.frame(cbind(out2[,2],out2[,1]))
out2f <- usmap_transform(outg)
out2f[,5]<-0.1;
colnames(out2f)=c('lon1','lat1','long','lati','cluster')

out=read.table(paste0('G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Input_for_clustering_plot_1hr'))
out=as.data.frame(out)
t_data <- usmap_transform(out[,1:2])
t_data=as.data.frame(t_data)
t_data[,5]=as.numeric(out[,3])
colnames(t_data)=c("lon1","lat1","lon","lat","cluster")

plot_usmap(include = c("OR"))+geom_point(data=out2f, aes(x=long, y=lati),size=2,pch=21,colour="blue")+
geom_point(data=t_data, aes(x=lon, y=lat,size=cluster, color=cluster), alpha=0.9) +scale_size_continuous(range=c(1,5)) +
  scale_color_viridis(option="magma", trans="log", breaks=mybreaks, name="Regions" )+theme_void()

