clc
clear all
data=importdata(['G:\Sourav\USFS\Revised\Coweeta\Coweeta_data.csv']);
datarg = data.data(1:33,14:20); %% RG31
% datarg = data.data(1:33,27:33); %% RG41
d1=importdata(['G:\Sourav\USFS\Revised\Coweeta\data\Hourly_precip_RG31_2009_2021']);
d1(:,4)=d1(:,4)*2.54; %% converting from inch to cm per hour
dat=[d1(:,1:3),d1(:,4)];

n=1;
for yr=d1(1,1):d1(end,1)
    z=find(d1(:,1)==yr);
    out(n,1:2)=[yr,max(d1(z,4))]; 
    n=n+1;
end
outf=[datarg(:,1:2);out];
dlmwrite(['G:\Sourav\USFS\Revised\Coweeta\Annual_Maxima_Series\RG31\01hrs'],outf,'delimiter','\t');
dlmwrite(['G:\Sourav\USFS\Revised\Coweeta\Aggregates\RG31\01hrs'],dat,'delimiter','\t');
out=[];
file=['02hrs';'03hrs';'06hrs';'12hrs';'24hrs'];
rl=[2,3,6,12,24];
dev=[0.5,1/3,1/6,1/12,1/24];
for di=1:5
    disp(di)
    d=rl(di);
    pr=[];
    for i=1:d:length(d1(:,1))-(d-1)
        pr=[pr;[d1(i,1:3),(nansum(d1(i:i+d-1,4)))*dev(di)]];
    end
    dlmwrite(['G:\Sourav\USFS\Revised\Coweeta\Aggregates\RG31\',file(di,:)],pr,'delimiter','\t');
    n=1;
    for yr=d1(1,1):d1(end,1)
        z=find(pr(:,1)==yr);
        out(n,1:2)=[yr,max(pr(z,4))];
        n=n+1;
    end
    outf=[[datarg(:,1),datarg(:,di+2)];out];
    dlmwrite(['G:\Sourav\USFS\Revised\Coweeta\Annual_Maxima_Series\RG31\',file(di,:)],outf,'delimiter','\t');
end

