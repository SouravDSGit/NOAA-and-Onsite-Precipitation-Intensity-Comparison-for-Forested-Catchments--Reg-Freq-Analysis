clc
clear all
ls=dir('G:\Sourav\USFS\Revised\HJ Andrews\Oregon_DEM\tables\');
output=[];
for q=3:length(ls)
%% Latitude and longitude of desired onsite station
file=ls(q).name;
disp(q)
grid=importdata(['G:\Sourav\USFS\Revised\HJ Andrews\Oregon_DEM\tables\',file]);
data=importdata(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\Output_for_krigging_revised\AMS\01hrs\2yr']);
data(data(:,1)>max(grid(:,1)),:)=[];
data(data(:,1)<min(grid(:,1)),:)=[];
data(data(:,2)>max(grid(:,2)),:)=[];
data(data(:,2)<min(grid(:,2)),:)=[];


F = scatteredInterpolant(grid(:,1), grid(:,2), (1:size(grid,1)).', 'nearest');
A_idx = F(data(:,1:2));
if isempty(A_idx)==0
output=[output;[data(:,1:2),grid(A_idx, 3)]];
else
end
end

dlmwrite(['G:\Sourav\USFS\Revised\HJ Andrews\Oregon_DEM\final_interpolated'],output,'delimiter','\t')

data2=importdata(['G:\Sourav\USFS\Revised\HJ Andrews\Oregon_DEM\final_interpolated']);
data2=unique(data2,'rows');
dlmwrite(['G:\Sourav\USFS\Revised\HJ Andrews\Oregon_DEM\unique_final_interpolated'],data2,'delimiter','\t')
