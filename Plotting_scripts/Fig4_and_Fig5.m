clc
clear all
ls=dir(['D:\Sourav\USFS\Revised\Plotting_codes\Sites\']);
ls(6,:)=[];ls(4,:)=[];np=1;
% c=[6,3];
c=[4,5];
ha = tight_subplot(2,2,[.15 .09],[.075 .005],[.07 .01]);
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
for q=1:length(c)
%     subplot(4,2,np)
    axes(ha(np))
    site=ls(c(q)).name
    dur=dir(['D:\Sourav\USFS\Revised\',site,'\Return_Level_GPD\98p\Lmoment\']);
    n=1;out25=[];out50=[];out100=[];lab=[];
    N25=[];N50=[];N100=[];
    if c(q)~=5
        file=['01hrs';'02hrs';'03hrs';'06hrs';'12hrs';'24hrs'];
    else
        file=['15min';'30min';'01hrs';'02hrs';'03hrs';'06hrs';'12hrs';'24hrs'];
    end
    for di=1:length(file(:,1))
        duration=file(di,:);
%         rll=importdata(['D:/Sourav/USFS/Revised/',site,'/Return_Level_GPD/98p/Lmoment/',duration]);
        
        rll=importdata(['D:/Sourav/USFS/Revised/',site,'/Return_Level_GEV/Lmoments/',duration]);
        lab=[lab;duration];
        z25=find(rll(:,1)==25);z50=find(rll(:,1)==50);z100=find(rll(:,1)==100);
        out25(n,1:4)=rll(z25,1:4);
        out50(n,1:4)=rll(z50,1:4);
        out100(n,1:4)=rll(z100,1:4);
        
%         noaa=importdata(['D:\Sourav\USFS\Revised\NOAA_atlas14/',site,'/PDS/',duration]);
        noaa=importdata(['D:\Sourav\USFS\Revised\NOAA_atlas14/',site,'/AMS/',duration]);
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
    
    if q==4
        xline(2.5,'--k')
        xline(5.5,'--k')
    else
        xline(3.5,'--k')
    end
    
    
    errorbar(x,N25(:,3),N25(:,3)-N25(:,2),N25(:,4)-N25(:,3),'.','MarkerSize',22,'LineWidth',1,'Color',[0.3010 0.7450 0.9330])
    errorbar(x,N50(:,3),N50(:,3)-N50(:,2),N50(:,4)-N50(:,3),'.','MarkerSize',22,'LineWidth',1,'Color',[ 0.9100 0.4100 0.1700])
    errorbar(x,N100(:,3),N100(:,3)-N100(:,2),N100(:,4)-N100(:,3),'.','MarkerSize',22,'LineWidth',1,'Color',[0.5 0.5 0.5])
    
    set(gca, 'YScale', 'log')
    set(gca, 'XScale', 'log')
    xticks(x)
    xticklabels(lab)
    ylabel('PI (cm/hr)')
    xlabel('Duration')
    xlim([0.95 n-0.5])
    yticks([0:1:20])
    yticklabels([0:1:20])
    xtickangle(45)
    ylim([0 20])
    set(gca,'TickDir','out','FontName','Sans Serif','FontSize',8);
%     title(['PIDF ',site])
    box('on')
    grid on
    axes(ha(np+1))
%     subplot(4,2,np+1)
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
    xticks([-60:10:60])
    xticklabels([-60:10:60])
    yticklabels([lab;lab;lab])
    if q==4
    set(gca,'TickDir','out','FontName','Sans Serif','FontSize',6.5);
    else
        set(gca,'TickDir','out','FontName','Sans Serif','FontSize',8.5);
    end
%     title(['Relative Diff. ',site])
    xlim([-70 70])
    box('on')
    np=np+2;clab=[];
    grid('on')
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% clc
% clear all
% ls=dir(['D:\Sourav\USFS\Revised\Plotting_codes\Sites\']);
% for q=3:length(ls)
%     subplot(2,3,q-2)
%     site=ls(q).name
%     dur=dir(['D:\Sourav\USFS\Revised\',site,'\Return_Level_GPD\98p\Lmoment\']);
%     n=1;out25=[];out50=[];out100=[];lab=[];
%     N25=[];N50=[];N100=[];
%     if q~=6&&q~=7
%         file=['01hrs';'02hrs';'03hrs';'06hrs';'12hrs';'24hrs'];
%     else
%         file=['15min';'30min';'01hrs';'02hrs';'03hrs';'06hrs';'12hrs';'24hrs'];
%     end
%     for di=1:length(file(:,1))
%         duration=file(di,:);
%         %         rll=importdata(['D:/Sourav/USFS/Revised/',site,'/Return_Level_GPD/98p/Lmoment/',duration]);
%         rll=importdata(['D:/Sourav/USFS/Revised/',site,'/Return_Level_GEV/Lmoments/',duration]);
%         lab=[lab;duration];
%         out25(n,1:4)=rll(6,1:4);
%         out50(n,1:4)=rll(8,1:4);
%         out100(n,1:4)=rll(10,1:4);
%         if q~=6
%             %         noaa=importdata(['D:\Sourav\USFS\Revised\NOAA_atlas14/',site,'/PDS/',duration]);
%             noaa=importdata(['D:\Sourav\USFS\Revised\NOAA_atlas14/',site,'/AMS/',duration]);
%             N25(n,1:4)=noaa(4,1:4);
%             N50(n,1:4)=noaa(5,1:4);
%             N100(n,1:4)=noaa(6,1:4);
%         else
%         end
%
%
%         n=n+1;
%     end
%
%     x=[1:n-1];
%
%     %
%     if q~=6
%         D1=[];D2=[];D3=[];
%         for i=1:length(out25(:,1))
%             D1=[D1,round(((out25(i,3)-N25(i,3))/N25(i,3))*100)];
%             D2=[D2,round(((out50(i,3)-N50(i,3))/N50(i,3))*100)];
%             D3=[D3,round(((out100(i,3)-N100(i,3))/N100(i,3))*100)];
%         end
%         % Initialize data points
%
%         P = [D1; D2; D3];
%
%         barh(P,'BarWidth',0.5,'FaceColor','k','EdgeColor',[0 .9 .9],'FaceAlpha',0.2);
%     else
%     end
%     ylabel('Reutn Interval')
%     xlabel('Relative Difference (%)')
%     yticks([1,2,3])
%     yticklabels({'25-yr','50-yr','100-yr'})
%     set(gca,'TickDir','out','FontName','Sans Serif');
%     title(site)
%     xlim([-70 70])
% end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% clc
% clear all
% % sites=['HJ Andrews';'Hubbard Brook';'Santee';'Alum Creek (AC04)';'Coweeta';'Fraser'];
% ls=dir(['D:\Sourav\USFS\Revised\Plotting_codes\Sites\']);
% for q=3%:length(ls)
% %     subplot(2,3,q-2)
%     site=ls(q).name
%     dur=dir(['D:\Sourav\USFS\Revised\',site,'\Return_Level_GPD\98p\Lmoment\']);
%     n=1;out25=[];out50=[];out100=[];lab=[];
%     N25=[];N50=[];N100=[];
%     if q~=6&&q~=7
%         file=['01hrs';'02hrs';'03hrs';'06hrs';'12hrs';'24hrs'];
%     else
%         file=['15min';'30min';'01hrs';'02hrs';'03hrs';'06hrs';'12hrs';'24hrs'];
%     end
%     for di=1:length(file(:,1))
%         duration=file(di,:);
%         %         rll=importdata(['D:/Sourav/USFS/Revised/',site,'/Return_Level_GPD/98p/Lmoment/',duration]);
%         rll=importdata(['D:/Sourav/USFS/Revised/',site,'/Return_Level_GEV/Lmoments/',duration]);
%         lab=[lab;duration];
%         out25(n,1:4)=rll(6,1:4);
%         out50(n,1:4)=rll(8,1:4);
%         out100(n,1:4)=rll(10,1:4);
%         if q~=6
%             %         noaa=importdata(['D:\Sourav\USFS\Revised\NOAA_atlas14/',site,'/PDS/',duration]);
%             noaa=importdata(['D:\Sourav\USFS\Revised\NOAA_atlas14/',site,'/AMS/',duration]);
%             N25(n,1:4)=noaa(4,1:4);
%             N50(n,1:4)=noaa(5,1:4);
%             N100(n,1:4)=noaa(6,1:4);
%         else
%         end
%
%
%         n=n+1;
%     end
%
%     x=[1:n-1];
%
% %
%     if q~=6
%         D1=[];D2=[];D3=[];
%         for i=1:length(out25(:,1))
%             D1=[D1,round(((out25(i,3)-N25(i,3))/N25(i,3))*100)];
%             D2=[D2,round(((out50(i,3)-N50(i,3))/N50(i,3))*100)];
%             D3=[D3,round(((out100(i,3)-N100(i,3))/N100(i,3))*100)];
% %             text(x(1,i),30,num2str(round(((out25(i,3)-N25(i,3))/N25(i,3))*100)),'Color',[0.3010 0.7450 0.9330],'FontSize',11,'FontName','Sans Serif')
% %             text(x(1,i),35,num2str(round(((out50(i,3)-N50(i,3))/N50(i,3))*100)),'Color',[ 0.9100 0.4100 0.1700],'FontSize',11,'FontName','Sans Serif')
% %             text(x(1,i),40,num2str(round(((out100(i,3)-N100(i,3))/N100(i,3))*100)),'Color',[0.5 0.5 0.5],'FontSize',11,'FontName','Sans Serif')
%         end
%         % Initialize data points
%
%         P = [D1; D2; D3];
%
%         if q~=7
%         % Spider plot
%         spider_plot(P,...
%             'AxesLabels', {'01hrs','02hrs','03hrs','06hrs','12hrs','24hrs'},...
%             'AxesInterval', 2,...
%             'FillOption', {'on', 'on', 'off'},...
%             'Color', [0.3010, 0.7450, 0.9330; 0.9100, 0.4100, 0.1700; 0.5, 0.5 ,0.5],...
%             'FillTransparency', [0.2, 0.1, 0.1],'AxesFontSize',21,'LabelFontSize',21);
%         else
%             spider_plot(P,...
%             'AxesLabels', {'15min','30min','01hrs','02hrs','03hrs','06hrs','12hrs','24hrs'},...
%             'AxesInterval', 2,...
%             'FillOption', {'on', 'on', 'off'},...
%             'Color', [0.3010, 0.7450, 0.9330; 0.9100, 0.4100, 0.1700; 0.5, 0.5 ,0.5],...
%             'FillTransparency', [0.2, 0.1, 0.1],'AxesFontSize',21,'LabelFontSize',21);
%         end
%
%         %
%         %         plot(x,round(((out25(:,3)-N25(:,3))./N25(:,3))*100),'LineStyle','--','Color',[0.3010 0.7450 0.9330])
%         %         plot(x,round(((out50(:,3)-N50(:,3))./N50(:,3))*100),'LineStyle','--','Color',[ 0.9100 0.4100 0.1700])
%         %         plot(x,round(((out100(:,3)-N100(:,3))./N100(:,3))*100),'LineStyle','--','Color',[0.5 0.5 0.5])
%
%     else
%     end
%
% end
