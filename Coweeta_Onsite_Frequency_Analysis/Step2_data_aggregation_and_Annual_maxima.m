clc
clear all
d1=importdata(['G:/Sourav/USFS/Revised/Coweeta/Coweeta_hourly_precip_data_in_inches']);
dat=[d1(:,1:4),d1(:,5)*2.54];

n=1;
for yr=d1(1,1):d1(end,1)
    z=find(d1(:,1)==yr);
    out(n,1:2)=[yr,max(d1(z,5))*2.54];
    n=n+1;
end
dlmwrite(['G:\Sourav\USFS\Revised\Coweeta\Annual_Maxima_Series\RG06\01hrs'],out,'delimiter','\t');
dlmwrite(['G:\Sourav\USFS\Revised\Coweeta\Aggregates\RG06\01hrs'],dat,'delimiter','\t');
out=[];
file=['02hrs';'03hrs';'06hrs';'12hrs';'24hrs'];
rl=[2,3,6,12,24];
dev=[0.5,1/3,1/6,1/12,1/24];
for di=1:5
    disp(di)
    d=rl(di);
    pr=[];
    for i=1:d:length(d1(:,1))-(d-1)
        pr=[pr;[d1(i,1:4),(nansum(d1(i:i+d-1,5)))*dev(di)*2.54]];
    end
    dlmwrite(['G:\Sourav\USFS\Revised\Coweeta\Aggregates\RG06\',file(di,:)],pr,'delimiter','\t');
    n=1;
    for yr=d1(1,1):d1(end,1)
        z=find(pr(:,1)==yr);
        out(n,1:2)=[yr,max(pr(z,5))];
        n=n+1;
    end
    dlmwrite(['G:\Sourav\USFS\Revised\Coweeta\Annual_Maxima_Series\RG06\',file(di,:)],out,'delimiter','\t');
end


