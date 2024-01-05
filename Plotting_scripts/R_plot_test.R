rm(list = ls())
library(dplyr)
library(ggplot2)
library(gridExtra)

#library(gapminder)
site=list.files("G:/Sourav/USFS/Revised/Fig/Fig6/input_for_plot_in_R/POT/")
for (s in 1:5){

out=as.data.frame(read.table(paste0("G:/Sourav/USFS/Revised/Fig/Fig6/input_for_plot_in_R/AMS/",site[s])));
colnames(out)=c("Method","Duration","L","M","U")
noaa=out[seq(1,length(out[,1]),by=3),];noaa$Duration=c(1,1,1,3,3,3,24,24,24)
lmom=out[seq(2,length(out[,1]),by=3),];lmom$Duration=c(1,1,1,3,3,3,24,24,24)
ns=out[seq(3,length(out[,1]),by=3),];ns$Duration=c(1,1,1,3,3,3,24,24,24)

noaa$RDiff=(ns$M-noaa$M)*(100/noaa$M)
lmom$RDiff=(ns$M-lmom$M)*(100/lmom$M)
data=cbind(c(25,50,100,25,50,100,25,50,100),noaa,lmom,ns)

out$x=rbind(1,2,3,6,7,8,11,12,13,14,15,16,19,20,21,24,25,26,27,28,29,32,33,34,37,38,39)
write.csv(data,file=paste0("G:/Sourav/USFS/Revised/Fig/Fig6/excel_files_for_tables/AMS/",site[s],".csv"));
}


rm(list = ls())
library(dplyr)
library(ggplot2)
library(gridExtra)

#library(gapminder)
site=list.files("G:/Sourav/USFS/Revised/Fig/Fig6/input_for_plot_in_R/POT/")
for (s in 1:5){
  
  out=as.data.frame(read.table(paste0("G:/Sourav/USFS/Revised/Fig/Fig6/input_for_plot_in_R/AMS/",site[s])));
  colnames(out)=c("Method","Duration","L","M","U")
  noaa=out[seq(1,length(out[,1]),by=3),]
  lmom=out[seq(2,length(out[,1]),by=3),]
  ns=out[seq(3,length(out[,1]),by=3),]
  noaa$RDiff=(ns$M-noaa$M)*(100/noaa$M)
  lmom$RDiff=(ns$M-lmom$M)*(100/lmom$M)
  data=cbind(noaa,lmom,ns)
  
  out$x=rbind(1,2,3,6,7,8,11,12,13,14,15,16,19,20,21,24,25,26,27,28,29,32,33,34,37,38,39)
if (s==3){
out[which(out[,1]==1),1]="NOAA-RFA"
}else{
  out[which(out[,1]==1),1]="NOAA-Atlas14"
}
out[which(out[,1]==2),1]="Onsite-LMOM"
out[which(out[,1]==3),1]="Onsite-BS"
out[which(out[,1]==4),1]="Onsite-BNS"
out[which(out[,2]==1),2]="1-hr"
out[which(out[,2]==2),2]="3-hr"
out[which(out[,2]==3),2]="24-hr"

# (1) Pointrange: Vertical line with point in the middle
ggplot(out, aes(x, M)) +
  geom_pointrange(
    aes(ymin = L, ymax = U, color = Method),
    position = position_dodge(0.3)
  )+facet_wrap(~Duration, scale = "free") +
  scale_color_manual(values = c("greenyellow", "#c38452","#E7B800"),name="")+labs(x = "",y = "PI(cm/hr)") +
  theme_bw() +
  theme(
    legend.background = element_rect(fill = "white", size = 4, colour = "white"),
    #axis.ticks = element_line(colour = "grey70", size = 0.2),
    panel.grid.major = element_line(),
    panel.grid.minor = element_blank(),
    
    strip.background = element_blank(),
    axis.title.y = element_text(size = 15, angle = 90),
    axis.text.x=element_blank(),
    axis.ticks.x=element_blank(),
    plot.title = element_text(size = rel(1.8), face = "bold"),
    strip.text.x = element_text(size = rel(1.8)),legend.text=element_text(size=15)
  )

}
# (2) Standard error bars
#ggplot(df.summary2, aes(dose, len)) +
  #geom_errorbar(
    #aes(ymin = len-sd, ymax = len+sd, color = supp),
    #position = position_dodge(0.3), width = 0.2
  #)+
  #geom_point(aes(color = supp), position = position_dodge(0.3)) +
  #scale_color_manual(values = c("#00AFBB", "#E7B800"))