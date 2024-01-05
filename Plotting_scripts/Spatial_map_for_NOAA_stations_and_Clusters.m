clc
clear all
%% plotting
data=importdata(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\Input_for_clustering_plot_1hr']);
z=find(data.data(:,2)==-117.05&data.data(:,3)==42.979);
data.data(z,4)=1;
z=find(data.data(:,2)==-116.1&data.data(:,3)==44.887);
data.data(z,4)=1;

t = array2table(data.data);
t.Properties.VariableNames = {'Elevation','Longitude' 'Latitude' 'Region'};

t.CT=categorical(t.Region);
t.Region=repmat(1,height(t),1);
figure

gb = geobubble(t,'Latitude','Longitude', ...
        'SizeVariable','Region','ColorVariable','CT', 'MapLayout','normal','FontSize',15,'FontName','Times New Roman');

% gb.BubbleColorList=col;    
    
% geolimits([42 46.3],[-124.5 -116.5])
title 'Oregon';
% gb.SizeLegendTitle = 'Region';
% gb.SizeLegend = "off"
gb.ColorLegendTitle = 'Region';
gb.BubbleWidthRange = [15,15];
geobasemap grayterrain



clc
clear all
%% plotting
data=importdata(['G:\Sourav\USFS\Revised\Fig\Fig_supp_NOAA_RFA_station_selection\NOAA-stations\all_stations']);
data(:,4)=10;
t = array2table(data);
t.Properties.VariableNames = {'Longitude' 'Latitude' 'Elevation1' 'Elevation'};

t.CT=categorical(t.Elevation);
t.Elevation=repmat(1,height(t),1);
figure

gb = geobubble(t,'Latitude','Longitude', ...
        'SizeVariable','Elevation','ColorVariable','CT', 'MapLayout','normal','FontSize',15,'FontName','Times New Roman');

% gb.BubbleColorList=col;    
    
% geolimits([42 46.3],[-124.5 -116.5])
title 'Oregon';
% gb.SizeLegendTitle = 'Region';
% gb.SizeLegend = "off"
gb.ColorLegendTitle = 'Elevation (m)';
gb.BubbleWidthRange = [15,15];
geobasemap grayterrain
