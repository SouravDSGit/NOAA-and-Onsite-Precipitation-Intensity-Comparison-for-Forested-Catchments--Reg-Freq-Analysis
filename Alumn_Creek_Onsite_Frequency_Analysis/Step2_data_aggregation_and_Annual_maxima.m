clc
clear all
d1=importdata(['G:\Sourav\USFS\Revised\Alum Creek (AC04)\Alum Creek (AC04) Hourly rainfall intensity data 1975 to 2015']);
d1(:,6)=d1(:,6)*0.1;
dat=[d1(:,1:4),d1(:,6)];
n=1;
for yr=d1(1,1):d1(end,1)
    z=find(d1(:,1)==yr);
    out(n,1:2)=[yr,max(d1(z,6))];
    n=n+1;
end
dlmwrite(['G:\Sourav\USFS\Revised\Alum Creek (AC04)\Annual_Maxima_Series\01hrs'],out,'delimiter','\t');
dlmwrite(['G:\Sourav\USFS\Revised\Alum Creek (AC04)\Aggregates\01hrs'],dat,'delimiter','\t');
out=[];
file=['02hrs';'03hrs';'06hrs';'12hrs';'24hrs'];
rl=[2,3,6,12,24];
dev=[0.5,1/3,1/6,1/12,1/24];
for di=1:5
    disp(di)
    d=rl(di);
    pr=[];
    for i=1:d:length(d1(:,1))-(d-1)
        pr=[pr;[d1(i,1:4),(nansum(d1(i:i+d-1,6)))*dev(di)]];
    end
    dlmwrite(['G:\Sourav\USFS\Revised\Alum Creek (AC04)\Aggregates\',file(di,:)],pr,'delimiter','\t');
    n=1;
    for yr=d1(1,1):d1(end,1)
        z=find(pr(:,1)==yr);
        out(n,1:2)=[yr,max(pr(z,5))];
        n=n+1;
    end
    dlmwrite(['G:\Sourav\USFS\Revised\Alum Creek (AC04)\Annual_Maxima_Series\',file(di,:)],out,'delimiter','\t');
end

