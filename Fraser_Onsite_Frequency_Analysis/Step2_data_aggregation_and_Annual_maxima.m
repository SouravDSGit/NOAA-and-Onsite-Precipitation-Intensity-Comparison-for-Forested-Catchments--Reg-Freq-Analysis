clc
clear all
d1=importdata(['G:\Sourav\USFS\Revised\Fraser\allmet_hourly_ppt_HQTRS_2004-2021_cm']);
n=1;
for yr=d1(1,1):d1(end,1)
    z=find(d1(:,1)==yr);
    out(n,1:2)=[yr,max(d1(z,5))];
    n=n+1;
end
dlmwrite(['G:\Sourav\USFS\Revised\Fraser\Annual_Maxima_Series\01hrs'],out,'delimiter','\t');
dlmwrite(['G:\Sourav\USFS\Revised\Fraser\Aggregates\01hrs'],d1,'delimiter','\t');

d1(:,6)=[1:length(d1(:,1))]';
l=length(d1(:,1));
file=['02hrs';'03hrs';'06hrs';'12hrs';'24hrs'];
rl=[120/60,180/60,360/60,720/60,(24*60)/60];
dev=[0.5,1/3,1/6,1/12,1/24];
outl=[];
% % % % % % % % % % % % checking divisibility for reshaping array
for di=1:5
    disp(di)
    d=rl(di);
   
    r=[];n=1;
    for i=l:-1:l-300
    r(n,1)=i;
    r(n,2)=rem(i,d);
    n=n+1;
    end
    z=min(find(r(:,2)==0));
    outl=[outl;[d,r(z,1)]];
end
lg=outl(end,2);
d1f=d1(l-lg+1:end,:);
clear d1;
% % % % % % % % % % % %  Aggregation starts here
lh=length(d1f(:,1));
for di=1:5
    disp(di)
    d=rl(di);g=lh/d;
    yr=reshape(d1f(:,1),d,g);
    mon=reshape(d1f(:,2),d,g);
    day=reshape(d1f(:,3),d,g);
    hr=reshape(d1f(:,4),d,g);
    out=reshape(d1f(:,5),d,g);
    outs=[yr(1,:)',mon(1,:)',day(1,:)',hr(1,:)',(nansum(out,1)')*dev(di)];
    
    dlmwrite(['G:\Sourav\USFS\Revised\Fraser\Aggregates\',file(di,:)],outs,'delimiter','\t');
    n=1;
    for yr=outs(1,1):outs(end,1)
        z=find(outs(:,1)==yr);
        outy(n,1:2)=[yr,max(outs(z,5))];
        n=n+1;
    end
        dlmwrite(['G:\Sourav\USFS\Revised\Fraser\Annual_Maxima_Series\',file(di,:)],outy,'delimiter','\t');
end

