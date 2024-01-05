%% Plotting code
% %%
% clc
% clear all
% ls=dir(['D:\Sourav\USFS\Revised\Coweeta\NOAA_PIDFs\textfiles\'])
% file=['01hrs';'02hrs';'03hrs';'06hrs';'12hrs';'24hrs'];
% for q=3:length(ls)
%     site=ls(q).name
%     est=importdata(['D:\Sourav\USFS\Revised\Coweeta\NOAA_PIDFs\textfiles\',site,'\AMS_est.txt']);
%     est=est';
%     low=importdata(['D:\Sourav\USFS\Revised\Coweeta\NOAA_PIDFs\textfiles\',site,'\AMS_lower.txt']);
%     low=low';
%     high=importdata(['D:\Sourav\USFS\Revised\Coweeta\NOAA_PIDFs\textfiles\',site,'\AMS_upper.txt']);
%     high=high';
%     
%     for i=1:6
%         
%         outf=[[2;5;10;25;50;100],low(:,i)*2.54,est(:,i)*2.54,high(:,i)*2.54];
%         
%         dlmwrite(['D:\Sourav\USFS\Revised\Coweeta\NOAA_PIDFs\Final\',site,'\',file(i,:)],outf,'delimiter','\t');
%         outf=[];
%     end
% end


clc
clear all
ls=dir(['D:\Sourav\USFS\Revised\Coweeta\NOAA_PIDFs\Final\']);
np=1;
file=['01hrs';'02hrs';'03hrs';'06hrs';'12hrs';'24hrs'];
g=[3;5;4];
ha = tight_subplot(3,2,[.09 .09],[.075 .005],[.04 .01]);
% [ha, pos] = tight_subplot(Nh, Nw, gap, marg_h, marg_w)
%
%   in:  Nh      number of axes in hight (vertical direction)
%        Nw      number of axes in width (horizontaldirection)
%        gap     gaps between the axes in normalized units (0...1)
%                   or [gap_h gap_w] for different gaps in height and width 
%        marg_h  margins in height in normalized units (0...1)
%                   or [lower upper] for different lower and upper margins 
%        marg_w  margins in width in normalized units (0...1)
%                   or [left right] for different left and right margins 
for q=1:length(g(:,1))
    axes(ha(np))
%     subplot(3,2,np)
    site=ls(g(q,1)).name
    n=1;out25=[];out50=[];out100=[];lab=[];
    N25=[];N50=[];N100=[];
    for di=1:length(file(:,1))
        duration=file(di,:);        
        rll=importdata(['D:\Sourav\USFS\Revised\Coweeta\RFA_results\',site,'\',duration]);
%         rll=importdata(['D:/Sourav/USFS/Revised/Coweeta/Return_Level_GEV/',site,'/Lmoments/',duration]);
%         rll=[[2, 5, 10, 20, 25,30,35,40,45,50,100]',rll];
        lab=[lab;duration];
        z25=find(rll(:,1)==25);z50=find(rll(:,1)==50);z100=find(rll(:,1)==100);
        out25(n,1:4)=rll(z25,1:4);
        out50(n,1:4)=rll(z50,1:4);
        out100(n,1:4)=rll(z100,1:4);
        
        noaa=importdata(['D:\Sourav\USFS\Revised\Coweeta\NOAA_PIDFs\Final\',site,'\',duration]);
        N25(n,1:4)=noaa(4,1:4);
        N50(n,1:4)=noaa(5,1:4);
        N100(n,1:4)=noaa(6,1:4);
        
        n=n+1;
    end
    hold all
    
    x=[1:n-1];   
    y1=out25(:,2)';y2=out25(:,4)';y3=out25(:,3)';
    yn=min(y1);yx=max(y2);
    patch([x fliplr(x)], [y1 fliplr(y2)], [0.3010 0.7450 0.9330],'FaceAlpha',0.12,'EdgeAlpha',0)
    plot(x,y3,'color',[0.3010 0.7450 0.9330],'LineStyle','-','LineWidth',1)
    
    y1=out50(:,2)';y2=out50(:,4)';y3=out50(:,3)';
    yn=min(y1);yx=max(y2);
    patch([x fliplr(x)], [y1 fliplr(y2)], [ 0.9100 0.4100 0.1700],'FaceAlpha',0.12,'EdgeAlpha',0)
    plot(x,y3,'color',[ 0.9100 0.4100 0.1700],'LineStyle','-','LineWidth',1)
    
    y1=out100(:,2)';y2=out100(:,4)';y3=out100(:,3)';
    yn=min(y1);yx=max(y2);
    patch([x fliplr(x)], [y1 fliplr(y2)], [0.5 0.5 0.5],'FaceAlpha',0.12,'EdgeAlpha',0)
    plot(x,y3,'color',[0.5 0.5 0.5],'LineStyle','-','LineWidth',1)
    
    xline(2.5,'--k')
    xline(5.5,'--k')
    
    errorbar(x,N25(:,3),N25(:,3)-N25(:,2),N25(:,4)-N25(:,3),'.','MarkerSize',15,'LineWidth',1,'Color',[0.3010 0.7450 0.9330])
    errorbar(x,N50(:,3),N50(:,3)-N50(:,2),N50(:,4)-N50(:,3),'.','MarkerSize',15,'LineWidth',1,'Color',[ 0.9100 0.4100 0.1700])
    errorbar(x,N100(:,3),N100(:,3)-N100(:,2),N100(:,4)-N100(:,3),'.','MarkerSize',15,'LineWidth',1,'Color',[0.5 0.5 0.5])
    
    set(gca, 'YScale', 'log')
    set(gca, 'XScale', 'log')
    xticks(x)
    xticklabels(lab)
    ylabel('PI (cm/hr)')
    xlabel('Duration')
    xlim([0.95 n-0.5])
%     gx=max([out100(:,4);N100(:,4)])
    yticks([0:1:10])
    yticklabels([0:1:10])
    xtickangle(45)
    ylim([0 12])
    set(gca,'TickDir','out','FontName','Sans Serif','FontSize',7);
    set(gca,'TickLength',[0.001, 0.001])
%     title(['PIDF ',site])
    box('on')
    grid on
    axes(ha(np+1))
%     subplot(3,2,np+1)
    D1=[];D2=[];D3=[];clab=[lab;lab;lab];
    for i=1:length(out25(:,1))
        D1=[D1,round(((out25(i,3)-N25(i,3))/N25(i,3))*100)];
        D2=[D2,round(((out50(i,3)-N50(i,3))/N50(i,3))*100)];
        D3=[D3,round(((out100(i,3)-N100(i,3))/N100(i,3))*100)];
    end
    
    % Initialize data points
    
    P = [D1; D2; D3];
    xp=[1:1:length(P(1,:))];xtp=[];
    for i=1:3
        hold on
        if i==1
            barh(xp,P(i,:),'BarWidth',0.5,'FaceColor',[0.3010 0.7450 0.9330],'EdgeColor','none');
        else if i==2
                barh(xp,P(i,:),'BarWidth',0.5,'FaceColor',[ 0.9100 0.4100 0.1700],'EdgeColor','none');
            else
                barh(xp,P(i,:),'BarWidth',0.5,'FaceColor',[0.5 0.5 0.5],'EdgeColor','none');
            end
        end
        xtp=[xtp,xp];
        xp=xp+length(xp)+2;
        
    end
   
    
    ylabel('Duration')
    xlabel('Relative Difference (%)')
    yticks([xtp])
    xticks([-50:10:50])
    xticklabels([-50:10:50])
    yticklabels([lab;lab;lab])
    
%     title(['Relative Diff. ',site])
    xlim([-30 30])
    box('on')
    np=np+2;clab=[];
    grid('on')
    set(gca,'TickDir','out','FontName','Sans Serif','FontSize',7);
    set(gca,'TickLength',[0.001, 0.001])
  
end
