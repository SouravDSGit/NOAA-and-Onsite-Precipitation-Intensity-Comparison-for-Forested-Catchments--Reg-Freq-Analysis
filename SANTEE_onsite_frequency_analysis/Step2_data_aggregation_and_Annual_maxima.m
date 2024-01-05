%% ##########################  DATA GAP-FILLING
clc
clear all
data1=importdata(['G:/Sourav/USFS/Revised/Santee/Santee_Met25_Hourly_data_1977_2021']);
data2=importdata(['G:\Sourav\USFS\Revised\Santee\NOAA_NCDC_CHS_AP_HourlyPrecip_1995_2002_2890719']);
data2(:,5)=data2(:,5)*100;
z1=find(data1(:,1)==1994);zs=z1(end,1);
data=[data1(1:zs,:);data2;data1(zs+1:end,:)];
data(data(:,1)==20,1)=data(data(:,1)==20,1)+2000;
data(data(:,1)==2022,:)=[];
dlmwrite(['G:\Sourav\USFS\Revised\Santee\Full_hourly_cm_per_hr_1977_2021'],data,'delimiter','\t');
d1=data;
n=1;
for yr=d1(1,1):d1(end,1)
    z=find(d1(:,1)==yr);
    out(n,1:2)=[yr,max(d1(z,5))];
    n=n+1;
end
dlmwrite(['G:\Sourav\USFS\Revised\Santee\Annual_Maxima_Series\01hrs'],out,'delimiter','\t');
dlmwrite(['G:\Sourav\USFS\Revised\Santee\Aggregates\01hrs'],data,'delimiter','\t');
out=[];
file=['02hrs';'03hrs';'06hrs';'12hrs';'24hrs'];
rl=[2,3,6,12,24];
dev=[0.5,1/3,1/6,1/12,1/24];
for di=1:5
    disp(di)
    d=rl(di);
    pr=[];
    for i=1:d:length(d1(:,1))-(d-1)
        pr=[pr;[d1(i,1:4),(nansum(d1(i:i+d-1,5)))*dev(di)]];
    end
    dlmwrite(['G:\Sourav\USFS\Revised\Santee\Aggregates\',file(di,:)],pr,'delimiter','\t');
    n=1;
    for yr=d1(1,1):d1(end,1)
        z=find(pr(:,1)==yr);
        out(n,1:2)=[yr,max(pr(z,5))];
        n=n+1;
    end
    dlmwrite(['G:\Sourav\USFS\Revised\Santee\Annual_Maxima_Series\',file(di,:)],out,'delimiter','\t');
end

