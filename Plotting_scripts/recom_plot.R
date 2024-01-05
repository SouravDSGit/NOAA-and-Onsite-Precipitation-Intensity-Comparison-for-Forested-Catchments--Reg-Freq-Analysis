################################## AMS stationary
rm(list = ls())
library(ggplot2)
library(ggpattern)
library(ggthemes)
library(RColorBrewer)
#set.seed(40)
#df2 <- data.frame(Row = rep(1:9,times=9), Column = rep(1:9,each=9),
#                  Evaporation = runif(81,50,100),
#                  TreeCover = sample(c("Yes", "No"), 81, prob = c(0.3,0.7), replace = TRUE))
out=as.data.frame(read.table(paste0("D:/Sourav/USFS/Revised/Fig/Final_Fig/AMS_LMOM_25yr"),fill=TRUE))
colnames(out)=c("Duration","EFR","RP","Frequency")
out[which(out[,4]==1),4]="Yes"
out[which(out[,4]==0),4]="No"
ggplot(data=out, aes(x=as.factor(Duration), y=as.factor(EFR),pattern = Frequency, fill= RP)) +
  geom_tile_pattern(pattern_color = NA,
                    pattern_fill = "black",
                    pattern_angle = 45,
                    pattern_density = 0.5,
                    pattern_spacing = 0.025,
                    pattern_key_scale_factor = 1) +
  scale_pattern_manual(values = c(Yes = "circle", No = "none")) +
  scale_fill_gradientn(colours = colorspace::heat_hcl(10),na.value = "grey50",breaks=c(0,25,50,100),limits=c(0,100),oob = scales::squish) +
  coord_equal() + 
  labs(x = "Duration",y = "EFR site") +
  guides(pattern = guide_legend(override.aes = list(fill = "white")))+theme_classic()+guides(color=guide_legend("Onsite Recurrence Interval"))+ 
  ggtitle("NOAA-Atlas14 25-year Recurrence Interval")+
  scale_x_discrete(labels=c("-1" = "15-min", "0" = "30-min","1" = "1-hr","2"="2-hr","3" = "3-hr", "4" = "6-hr","5" = "12-hr","6"="24-hr"))+
  
  scale_y_discrete(labels=c("1" = "Santee", "2" = "AC(04)","3" = "Coweeta","4"="Fraser","5" = "HB"))


################################## AMS NS
rm(list = ls())
library(ggplot2)
library(ggpattern)
library(ggthemes)
library(RColorBrewer)
library(dplyr) # data reformatting
library(tidyr) # data reformatting
library(stringr) # string manipulation
#set.seed(40)
#df2 <- data.frame(Row = rep(1:9,times=9), Column = rep(1:9,each=9),
#                  Evaporation = runif(81,50,100),
#                  TreeCover = sample(c("Yes", "No"), 81, prob = c(0.3,0.7), replace = TRUE))
out=as.data.frame(read.table(paste0("G:/Sourav/USFS/Revised/Fig/Final_Fig/AMS_LMOM_100yr"),fill=TRUE))
colnames(out)=c("Duration","EFR","RP","Frequency")
out[which(out[,4]==1),4]="Higher"
out[which(out[,4]==0),4]="Lower"
out= mutate(out,EFR=factor(EFR, levels=rev(sort(unique(EFR))))) %>%
  mutate(RPfactor=cut(RP, breaks=c(-1, 0, 10, 25, 50, 100, 200, 300, max(RP, na.rm=T)),
                         labels=c("0", "0-10", "10-25", "25-50", "50-100","100-200","200-300", ">300"))) %>%
  # change level order
  mutate(RPfactor=factor(as.character(RPfactor), levels=rev(levels(RPfactor))))
  

ggplot(data=out, aes(x=as.factor(Duration), y=as.factor(EFR),pattern = Frequency, fill= RPfactor)) +
  geom_tile_pattern(pattern_color = NA,
                    pattern_fill = "black",
                    pattern_angle = 45,
                    pattern_density = 0.05,
                    pattern_spacing = 0.025,
                    pattern_key_scale_factor = 0.5) +
  
  scale_fill_manual(values=c( "#d47400","#ff8c00","#fdae61", "#fee08b", "#e6f598", "#abdda4", "#87CEEB","blue"), na.value = "grey90")+
  #scale_fill_manual(values=c( "#c38452","#fdae61", "#fee08b", "#e6f598", "#abdda4", "#87CEEB"), na.value = "grey90")+
  scale_pattern_manual(values = c(Higher = "circle", Lower = "none")) +
  guides(fill=guide_legend(title="Onsite RI (yr)"))+
  #scale_fill_gradientn(colours = colorspace::heat_hcl(10),na.value = "grey50",breaks=c(0,25,50,100),limits=c(0,100),oob = scales::squish) +
  coord_equal() + 
  labs(x = "Duration",y = "EF Station Name") +
  guides(pattern = guide_legend(override.aes = list(fill = "white")))+
  theme(axis.text = element_text(color = "grey20", size =c(11), face=c("plain")))+
  #guides(color=guide_legend("Onsite Recurrence Interval"))+ 
  #ggtitle("POT-based Onsite-BS-BNS Frequency")+
  ggtitle("Comparison with NOAA-100yr RI")+
  ##############################################  For LMOM
  #scale_x_discrete(labels=c("-1" = "15-min", "0" = "30-min","1" = "1-hr","2"="2-hr","3" = "3-hr", "4" = "6-hr","5" = "12-hr","6"="24-hr"))+
  #scale_y_discrete(labels=c("1" = "HJA-PRIMET","2" = "HJA-H15MET", "3" = "HJA-UPLMET","4" = "SAN-MET25",
  #                         "5" = "CHL-RRG06", "6" = "ALC-AC04","7"= "FRS-HQTRS", "8"= "HBR-RG01"))+
  
  ################################################ For Bayesian
  scale_x_discrete(labels=c("-1" = "15-min", "0" = "30-min","1" = "1-hr","2"="2-hr","3" = "3-hr", "4" = "6-hr","5" = "12-hr","6"="24-hr"))+
  scale_y_discrete(labels=c("1" = "HJA-PRIMET","2" = "HJA-H15MET", "3" = "HJA-UPLMET","4" = "CHL-RRG06","5" = "CHL-RRG41","6" = "CHL-RRG31","7" = "SAN-MET25",
                             "8" = "ALC-AC04","9"="FRS-HQTRS","10"= "HBR-RG01"))+
  
  #scale_y_discrete(labels=c("1" = "HJA-H15MET", "2" = "HJA-PRIMET","3" = "HJA-UPLMET","4" = "Santee-RG01",
   #                        "5" = "CHL-RRG06", "6" = "AC(04)","7"= "HB-RG01"))+
  theme_bw()+
  theme(axis.title.y = element_text(size = 20, angle = 90),axis.text.x=element_text(size = 15,angle = 45))+
  theme(axis.title.x = element_text(size = 20, angle = 00),axis.text.y=element_text(size = 20))+
  theme(legend.title=element_text(size=rel(1.8)))+
  theme(plot.title = element_text(size = 21, face = "bold"),legend.text=element_text(size=20))+
  #guides(pattern = guide_legend(override.aes = list(fill = "white")))+
  guides(pattern = guide_legend("Onsite Frequency",override.aes = list(fill = "white"), order = 2),
         fill = guide_legend("Onsite RI",override.aes = list(pattern = "none", order=1)   
         ))



