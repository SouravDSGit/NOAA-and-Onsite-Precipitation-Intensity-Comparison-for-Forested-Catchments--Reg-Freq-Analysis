rm(list = ls())
#######  https://trucvietle.me/r/tutorial/2017/01/18/spatial-heat-map-plotting-using-r.html
#devtools::install_github("dkahle/ggmap", ref = "tidyup")
library(ggplot2)
library(maps);
library(ggmap)
library(RColorBrewer) # for color selection
dur=list.files('G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Input_for_krigging_revised/AMS/')
files <- c("25yr","50yr","100yr")
for (d in 1){#:length(dur)){
  print(dur[d])
  output=list();outlow=list();outhigh=list();
  for(t in 1:length(files)){
data=read.table(paste0('G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/Output_for_krigging_revised/AMS/',dur[d],'/',files[t]))
output=cbind(output,data[,6])
outlow=cbind(outlow,data[,3])
outhigh=cbind(outhigh,data[,9])
  }
  }
output=as.data.frame(cbind(data[,1:2],output)); colnames(output)<- c("long","lat","syr","tyr","uyr")
outlow=as.data.frame(cbind(data[,1:2],outlow));colnames(outlow)<- c("long","lat","syr","tyr","uyr")
outhigh=as.data.frame(cbind(data[,1:2],outhigh));colnames(outhigh)<- c("long","lat","syr","tyr","uyr")
ggplot(data=output,aes(x=long, y=lat)) + geom_density2d_filled(aes(fill=syr)) + coord_equal() +
  scale_colour_brewer(palette = "Set1")+
  #scale_fill_discrete(low = "yellow", high="darkblue") +
  #scale_x_continuous(labels=comma) + scale_y_continuous(labels=comma) +
  theme_classic()
  
oregon <- get_stamenmap(bbox = c(left = min(output[,1]), bottom = min(output[,2]), 
                              right = max(output[,1]), top = max(output[,2])), 
                     zoom = 6)


map=ggmap(oregon)
map <- map + geom_tile(data = output, aes(x = long, y = lat, fill = syr), alpha = 0.8) +
  scale_fill_continuous(name = "Rain (mm)",
                        low = "white", high = "blue") +
  ggtitle("Rwandan rainfall") +
  xlab("Longitude") +
  ylab("Latitude") +
  
  theme(plot.title = element_text(size = 25, face = "bold"),
        legend.title = element_text(size = 15),
        axis.text = element_text(size = 15),
        axis.title.x = element_text(size = 20, vjust = -0.5),
        axis.title.y = element_text(size = 20, vjust = 0.2),
        legend.text = element_text(size = 10)) +
  coord_map()


  stat_contour(data = output, aes(x = long, y = lat, z = syr)) +
## Plot strikes by each year
drone.map <- drone.map + facet_wrap(~year)
print(drone.map)
#dfZ <- data.frame(long = rep(output$longitude, output$uyr), 
#                  lat  = rep(output$latitude, output$uyr))
dfZ <- as.data.frame(output[,1:3])

plot_mapdata <- function(df)
{
  states <- ggplot2::map_data("state")
  
  ggplot2::ggplot(data = df, ggplot2::aes(x = long, y = lat)) + 
    ggplot2::lims(x = c(-140, 50), y = c(20, 60)) +
    ggplot2::coord_cartesian(xlim = c(-125, -115.5), ylim = c(42, 46.3)) +
    ggplot2::geom_polygon(data = states, ggplot2::aes(x = long, y = lat, group = group), 
                          color = "black", fill = "white") +
    ggplot2::stat_summary_2d(data = df, aes(x = long, y = lat, z = syr), fun = mean, alpha = 0.6, bins = 30)+
    #ggplot2::stat_density2d(ggplot2::aes(fill = ..level.., alpha = ..level..), 
    #                        geom = "polygon") +
    ggplot2::scale_fill_gradientn(colours = rev(RColorBrewer::brewer.pal(7, "Spectral"))) +
    ggplot2::geom_polygon(data = states, ggplot2::aes(x = long, y = lat, group = group), 
                          color = "black", fill = NA) +
    #ggplot2::facet_wrap( ~type, nrow = 2) + 
    ggplot2::theme(legend.position = "right")
}

plot_mapdata(dfZ)