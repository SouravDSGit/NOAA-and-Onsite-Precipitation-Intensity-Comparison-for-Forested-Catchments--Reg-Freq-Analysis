clc
clear all
d15i = importdata(['G:/Sourav/USFS/Revised/Hubbard_Brook/L4/L4_precip_15min_RG1_1975-2021_cm']);

d15=importdata(['G:/Sourav/USFS/Revised/Hubbard_Brook/L4/L4_precip_15min_RG1_1975-2021_cm']);
d15(:,5)=d15(:,5)*4;
% d15(d15(:,5)>=5,5)=NaN; 
n=1;
for yr=d15(1,1):d15(end,1)
    z=find(d15(:,1)==yr);
    out(n,1:2)=[yr,max(d15(z,5))];
    n=n+1;
end
dlmwrite(['G:\Sourav\USFS\Revised\Hubbard_Brook\L4\Annual_Maxima_Series\15min'],out,'delimiter','\t');
dlmwrite(['G:\Sourav\USFS\Revised\Hubbard_Brook\L4\Aggregates\15min'],d15,'delimiter','\t');

d15(:,6)=[1:length(d15(:,1))]';
l=length(d15(:,1));
file=['30min';'01hrs';'02hrs';'03hrs';'06hrs';'12hrs';'24hrs'];
rl=[2,60/15,120/15,180/15,360/15,720/15,(24*60)/15];
dev=[2,1,0.5,1/3,1/6,1/12,1/24];
outl=[];
% % % % % % % % % % % % checking divisibility for reshaping array
for di=1:7
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
d15f=d15(l-lg+1:end,:);
d15f(:,5)=d15f(:,5)/4;
clear d15;
% % % % % % % % % % % %  Aggregation starts here
lh=length(d15f(:,1));
for di=1:7
    disp(di)
    d=rl(di);g=lh/d;
    yr=reshape(d15f(:,1),d,g);
    mon=reshape(d15f(:,2),d,g);
    day=reshape(d15f(:,3),d,g);
    hr=reshape(d15f(:,4),d,g);
    out=reshape(d15f(:,5),d,g);
    outs=[yr(1,:)',mon(1,:)',day(1,:)',hr(1,:)',(nansum(out,1)')*dev(di)];
    
    dlmwrite(['G:\Sourav\USFS\Revised\Hubbard_Brook\L4\Aggregates\',file(di,:)],outs,'delimiter','\t');
    n=1;
    for yr=outs(1,1):outs(end,1)
        z=find(outs(:,1)==yr);
        outy(n,1:2)=[yr,max(outs(z,5))];
        n=n+1;
    end
        dlmwrite(['G:\Sourav\USFS\Revised\Hubbard_Brook\L4\Annual_Maxima_Series\',file(di,:)],outy,'delimiter','\t');
end




% 
% 
% clc
% clear all
% d15=importdata(['G:/Sourav/USFS/Revised/Hubbard_Brook/L4/L4_precip_15min_RG1_1975-2021_cm']);
% d15f=d15;
% d15f(:,5)=d15f(:,5)*4; 
% n=1;
% for yr=d15f(1,1):d15f(end,1)
%     z=find(d15f(:,1)==yr);
%     out(n,1:2)=[yr,max(d15f(z,5))];
%     n=n+1;
% end
% dlmwrite(['G:\Sourav\USFS\Revised\Hubbard_Brook\L4\Annual_Maxima_Series\15min'],out,'delimiter','\t');
% dlmwrite(['G:\Sourav\USFS\Revised\Hubbard_Brook\L4\Aggregates\15min'],d15f,'delimiter','\t');
% out=[];
% file=['30min';'01hrs';'02hrs';'03hrs';'06hrs';'12hrs';'24hrs'];
% rl=[2,60/15,120/15,180/15,360/15,720/15,(24*60)/15];
% dev=[2,1,0.5,1/3,1/6,1/12,1/24];
% for di=1:7
%     disp(di)
%     d=rl(di);
%     pr=[];
%     for i=1:d:length(d15(:,1))-(d-1)
%         pr=[pr;[d15(i,1:4),(nansum(d15(i:i+d-1,5)))*dev(di)]];
%     end
%     dlmwrite(['G:\Sourav\USFS\Revised\Hubbard_Brook\L4\Aggregates\',file(di,:)],pr,'delimiter','\t');
%     n=1;
%     for yr=d15(1,1):d15(end,1)
%         z=find(pr(:,1)==yr);
%         out(n,1:2)=[yr,max(pr(z,5))];
%         n=n+1;
%     end
%     dlmwrite(['G:\Sourav\USFS\Revised\Hubbard_Brook\L4\Annual_Maxima_Series\',file(di,:)],out,'delimiter','\t');
% end
% 
