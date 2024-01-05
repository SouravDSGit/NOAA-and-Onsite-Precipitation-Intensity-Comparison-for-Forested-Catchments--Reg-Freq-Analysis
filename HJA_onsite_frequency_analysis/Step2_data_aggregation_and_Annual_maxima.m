% clc
% clear all
% ls=dir('G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\ONSITE\All_data\Stations\');
% for q=5%:length(ls)
%     file=ls(q).name
%     data0=importdata(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\ONSITE\All_data\Stations\',file]);
%     
%     data=data0(data0(:,1)<=2018,:);
%     
%     %% dates
%     t1 = datetime(data(1,1),data(1,2),data(1,3),data(1,4),data(1,5),data(1,6));
%     t2 = datetime(data(end,1),data(end,2),data(end,3),data(end,4),data(end,5),data(end,6));
%     
%     mj=diff(data(:,5));mk=mj(mj>0);m=min(mk);
%     timed=[t1:m/(24*60):t2];
%     date=[year(timed)',month(timed)',day(timed)', hour(timed)', minute(timed)'];
%     if length(data(:,1))==length(date(:,1))
%         g=1
%         m
%         data1=data;data1(:,6)=[];
%     else
%         data1=repmat(NaN,length(date(:,1)),6);
%         data1(:,1:5)=date;
%         [a b c]=intersect(data1(:,1:5),data(:,1:5),'rows');
%         
%         data1(b,6)=data(c,7);
%         g=0
%         m
%     end
%     dlmwrite(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\ONSITE\All_data_final\',file],data1,'delimiter','\t')
% end


% 
clc
clear all
d05=importdata(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\ONSITE\All_data_final\UPLMET_cm']);
d05(d05(:,6)>=1,6)=NaN; %%
d05(:,7)=[1:length(d05(:,1))]';
l=length(d05(:,1));
file=['15min';'30min';'01hrs';'02hrs';'03hrs';'06hrs';'12hrs';'24hrs'];
rl=[3,6,60/5,120/5,180/5,360/5,720/5,(24*60)/5];
dev=[4,2,1,0.5,1/3,1/6,1/12,1/24];
outl=[];
% % % % % % % % % % % % checking divisibility for reshaping array
for di=1:8
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
d05f=d05(l-lg+1:end,:);
clear d05;
% % % % % % % % % % % %  Aggregation starts here
lh=length(d05f(:,1));
for di=1:8
    disp(di)
    d=rl(di);g=lh/d;
    yr=reshape(d05f(:,1),d,g);
    mon=reshape(d05f(:,2),d,g);
    day=reshape(d05f(:,3),d,g);
    hr=reshape(d05f(:,4),d,g);
    sec=reshape(d05f(:,5),d,g);
    out=reshape(d05f(:,6),d,g);
    outs=[yr(1,:)',mon(1,:)',day(1,:)',hr(1,:)',sec(1,:)',(nansum(out,1)')*dev(di)];
    
    dlmwrite(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\ONSITE\Aggregates\use\PRIMET\',file(di,:)],outs,'delimiter','\t');
    n=1;
    for yr=outs(1,1):outs(end,1)
        z=find(outs(:,1)==yr);
        outy(n,1:2)=[yr,max(outs(z,6))];
        n=n+1;
    end
    dlmwrite(['G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/ONSITE/Annual_Maxima/use/PRIMET/',file(di,:)],outy,'delimiter','\t');
end