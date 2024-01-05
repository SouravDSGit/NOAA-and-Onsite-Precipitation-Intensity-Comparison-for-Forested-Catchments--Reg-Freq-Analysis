clc
clear all
[lats,lons] = borders('Oregon');
xmin=min(lons);xmax=max(lons);
ymin=min(lats);ymax=max(lats);
xGrid = xmin:.005:xmax;               % I added this because we'll use these values later
yGrid = ymin:.005:ymax;
out=[];
for i=1:length(xGrid(1,:))
    out1=[];disp(i)
    for j=1:length(yGrid(1,:))
        out1=[out1;[xGrid(1,i),yGrid(1,j)]];
    end
    out=[out;out1];
end
for k=1:length(out(:,1))
    disp(k)
    xq=out(k,1);yq=out(k,2);
    [in,on] = inpolygon(xq,yq,lons',lats');
    out(k,3)=in+on;
end
out(out(:,3)==0,:)=[];
dlmwrite(['G:\Sourav\USFS\Revised\HJ_Andrews\data_for_Reg_FA\NOAA\Oregon_grids_for_krigging'],out,'delimiter','\t')
% scatter(out(:,1),out(:,2))
% 
% 
% [N,R] = egm96geoid;
% load coastlines
% worldmap([41.5 46.5],[-125 -116])
% levels = -120:20:100;
% contourfm(N,R,levels,'LineStyle','none')
% geoshow(coastlat,coastlon,'Color','k')
% contourcbar