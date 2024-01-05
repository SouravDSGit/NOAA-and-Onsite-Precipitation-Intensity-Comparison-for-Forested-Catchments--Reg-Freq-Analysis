%% hourly Data pre-processing
clc
clear all
t1 = datetime(1948,1,1,0,0,0);
t2 = datetime(2013,12,31,23,0,0);
timed=[t1:hours(1):t2];
[yd,md,dd]=ymd(timed);
dates=[yd',md',dd'];
A=[0:23];
hr=repmat(A,length(dates(:,1))/24,1);
hrf=reshape(hr',length(dates(:,1)),1);
dates=[dates,hrf];
outk=[];stk=[];
ls=dir(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\NOAA_Oregon_results\preliminary\1hr\']);
for q=3:length(ls)
    files=ls(q).name;
    disp(q-2)
    datesf=dates;
    data=importdata(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\NOAA_Oregon_results\preliminary\1hr\',files]);
    data(data(:,6)==999.99,6)=NaN;
    y1=data(1,1);
    data(:,6)=data(:,6)*2.54; %% Converting inch to cm
    [a b c]=intersect(dates,data(:,1:4),'rows');
    datesf(:,6)=0;
    datesf(b,6)=data(c,6);

    datesf(:,7:9)=repmat(data(1,7:9),length(datesf(:,1)),1);
    n=1;
    for yr=1979:2013
        out(n,1)=yr;
        z=find(datesf(:,1)==yr);
        x=find(datesf(z,6)>0);
        y=find(isnan(datesf(z,6))==1);
        out(n,2)=max(datesf(z,6));
        out(n,3)=size(x,1);
        out(n,4)=size(y,1);
        n=n+1;
    end
    g=str2num(files(1,5:end));
    outk=[outk;[g,nanmean(out(:,3)),size(find(out(:,3)==0),1),nanmean(out(:,4))]];
    datesf(datesf(:,1)<y1,:)=[];
    stk=[stk;files];
%     dlmwrite(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\NOAA_Oregon_results\final_1hr\',files],datesf,'delimiter','\t')
end
subplot(3,1,1)
bar([1:length(outk(:,1))],outk(:,2))
xticks([1:length(outk(:,1))])
xticklabels(stk)
ylabel("Number of non-zero records / year")
xlabel("Station ID")
set(gca,'TickLength',[0, 0])
grid('on')
subplot(3,1,2)
bar([1:length(outk(:,1))],outk(:,3))
xticks([1:length(outk(:,1))])
xticklabels(stk)
ylabel("Number of years with zero precip")
xlabel("Station ID")
set(gca,'TickLength',[0, 0])
grid('on')
subplot(3,1,3)
bar([1:length(outk(:,1))],outk(:,4))
xticks([1:length(outk(:,1))])
xticklabels(stk)
ylabel("Number of missing values per year")
xlabel("Station ID")
set(gca,'TickLength',[0, 0])
grid('on')
dlmwrite(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\1hr_precip_station_selection_criteria'],outk,'delimiter','\t')


% %% Data aggregation
% %
% %%
% clc
% clear all
% ls=dir(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\NOAA_Oregon_results\final_1hr\']);
% outg=[];
% for q=3:length(ls)
%     files=ls(q).name;
%     disp(q)
%     d1=importdata(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\NOAA_Oregon_results\final_1hr\',files]);
%     d1f=d1;d1f(:,6)=d1f(:,6);
%     mkdir(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\NOAA_Oregon_results\aggregates\1hr_based\',files]);
%     mkdir(['G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/NOAA_Oregon_results/annual_maxima/1hr_based\',files])
%     n=1;outg=[];
%     for yr=d1f(1,1):d1f(end,1)
%         z=find(d1f(:,1)==yr);
%         outg(n,1:2)=[yr,max(d1f(z,6))];
%         n=n+1;
%     end
%     dlmwrite(['G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/NOAA_Oregon_results/annual_maxima/1hr_based\',files,'/01hrs'],outg,'delimiter','\t');
%     dlmwrite(['G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/NOAA_Oregon_results/aggregates/1hr_based\',files,'/01hrs'],d1f,'delimiter','\t');
% 
% 
%     %%
% 
%     file=['02hrs';'03hrs';'06hrs';'12hrs';'24hrs'];
%     rl=[2,3,6,12,24];
%     dev=[1/2,1/3,1/6,1/12,1/24];
%     l=length(d1(:,1));
%     outl=[];
%     vector=[1:l]';
% 
%     for di=1:5
%         out=[];
%         disp(di)
%         d=rl(di);
%         shortvector = vector((end-d*floor(end/d)+1):end);
%         g=length(shortvector(:,1))/d;
%         df=d1(shortvector,:);
%         yr=reshape(df(:,1),d,g);
%         mon=reshape(df(:,2),d,g);
%         day=reshape(df(:,3),d,g);
%         hr=reshape(df(:,4),d,g);
%         min=reshape(df(:,5),d,g);
%         out=reshape(df(:,6),d,g);
%         outs=[yr(1,:)',mon(1,:)',day(1,:)',hr(1,:)',min(1,:)',(nansum(out,1)')*dev(di)];
% 
%         dlmwrite(['G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/NOAA_Oregon_results/aggregates/1hr_based/',files,'/',file(di,:)],outs,'delimiter','\t');
%         n=1;outy=[];
%         for yr=outs(1,1):outs(end,1)
%             z=find(outs(:,1)==yr);
%             outy(n,1:2)=[yr,max(outs(z,6))];
%             n=n+1;
%         end
% 
% 
%         dlmwrite(['G:/Sourav/USFS/Revised/HJ Andrews/data_for_Reg_FA/NOAA/NOAA_Oregon_results/annual_maxima/1hr_based/',files,'/',file(di,:)],outy,'delimiter','\t');
%         outs=[];
%     end
% end


% Checking which stations can be selected based on 1-day aggregates

clc
clear all
ls=dir(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\NOAA_Oregon_results\final_1hr\']);
outk=[];stk=[];gout=[];
for q=3:length(ls)
    files=ls(q).name;
    disp(q)
    dat=importdata(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\NOAA_Oregon_results\preliminary\1hr\',files]);
    outs=importdata(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\NOAA_Oregon_results\aggregates/1hr_based/',files,'/24hrs']);
    n=1;
    for yr=1979:2013
        out(n,1)=yr;
        z=find(outs(:,1)==yr);
        x=find(outs(z,6)>0);
        y=find(isnan(outs(z,6))==1);
        if isempty(z)==1
            out(n,2)=NaN;
        else
            out(n,2)=max(outs(z,6));
        end
        out(n,3)=size(x,1);
        out(n,4)=size(y,1);
        n=n+1;
    end
    g=str2num(files(1,5:end));
    outk=[outk;[g,nanmean(out(:,3)),size(find(out(:,3)==0),1),nanmean(out(:,4))]];
    stk=[stk;files];
    gout=[gout;[dat(1,8),dat(1,9)]];
end
outj=importdata(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\1hr_precip_station_selection_criteria']);
subplot(3,1,1)
bar([1:length(outk(:,1))],outk(:,2))
xticks([1:length(outk(:,1))])
xticklabels(stk)
ylabel("Number of non-zero records / year")
xlabel("Station ID")
set(gca,'TickLength',[0, 0])
grid('on')
subplot(3,1,2)
bar([1:length(outk(:,1))],outk(:,3))
xticks([1:length(outk(:,1))])
xticklabels(stk)
ylabel("Number of years with zero precip")
xlabel("Station ID")
set(gca,'TickLength',[0, 0])
grid('on')
subplot(3,1,3)
bar([1:length(outj(:,1))],outj(:,4))
xticks([1:length(outj(:,1))])
xticklabels(stk)
ylabel("Number of missing values per year")
xlabel("Station ID")
set(gca,'TickLength',[0, 0])
grid('on')

z=find(outk(:,2)>=50&outk(:,3)==0&outj(:,4)<=20);
ls=dir(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\NOAA_Oregon_results\preliminary\1hr\']);
stk=[];
for q=3:length(ls)
    files=ls(q).name;
    stk=[stk;files];
end
stkf=stk(z,:);out=[];
for i=1:length(stkf(:,1))
    data=importdata(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\NOAA_Oregon_results\preliminary\1hr\',stkf(i,:)]);
    
    out=[out;[data(1,8),data(1,9)]];
end

dlmwrite(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\1day_precip_station_selection_criteria'],outk,'delimiter','\t')


%% Finally selecting stations
fout=outk(z,:);
for j=1:length(fout(:,1))
file=['COOP',num2str(fout(j,1))];    
mkdir(['G:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\NOAA_Oregon_results\all_stations\',file])
end
