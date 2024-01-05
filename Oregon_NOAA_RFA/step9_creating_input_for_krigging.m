clc
clear all
file=['01hrs';'02hrs';'03hrs';'06hrs';'12hrs';'24hrs'];
for f=1:length(file(:,1))
    ls=dir(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\Return_levels_stations_revised\PDS\',file(f,:),'\']);
    
    rp=[2,5,10,15,20,25,35,50,75,100];
    for p=1:length(rp(1,:))
        disp(p)
        out=[];outp=[];
        for q=3:length(ls)
            hh=ls(q).name;
            data=load(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\Return_levels_stations_revised\AMS\',file(f,:),'\',hh]);
            per=data(:,5);
            perf = round(10.^7*per)/(10.^7);
            pk=1-(1/rp(1,p));pk=round(10.^7*pk)/(10.^7);  %% AMS
            z=find(perf==pk);
            out=[out;[data(1,2),data(1,3),data(z,8),data(z,6),data(z,9)]];
            
            datap=load(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\Return_levels_stations_revised\PDS\',file(f,:),'\',hh]);
            perp=datap(:,5);
            perpf = round(10.^7*perp)/(10.^7);
            pkp=exp(-(1/rp(1,p)));pkp=round(10.^7*pkp)/(10.^7); %% PDS
            zp=find(perpf==pkp);
            outp=[outp;[datap(1,2),datap(1,3),datap(zp,8),datap(zp,6),datap(zp,9)]];
            
        end
        dlmwrite(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\Input_for_krigging_revised\AMS\',file(f,:),'\',num2str(rp(1,p)),'yr',],out,'delimiter','\t') 
        dlmwrite(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\Input_for_krigging_revised\PDS\',file(f,:),'\',num2str(rp(1,p)),'yr',],outp,'delimiter','\t')              
    end
    
end



