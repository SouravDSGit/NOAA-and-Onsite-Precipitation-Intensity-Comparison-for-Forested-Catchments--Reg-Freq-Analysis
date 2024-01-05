% clc
% clear all
% file=['01hrs';'02hrs';'03hrs';'06hrs';'12hrs';'24hrs'];
% rp=[2,5,10,25,50,100]';
% 
% %% Latitude and longitude of desired onsite station
% % grid=[-122.119763,44.207097]; %%% PPTUPL01 - UPLMET Precipitation by requested time interval (1995-Present), probe no. 01 at height 457 cm, stand-alone model
% grid=[-122.17378247,44.26425069]; %%%% PPTH1502 - H15MET Precipitation by requested time interval (1992-Present), probe no. 02 at height 410 cm
% % grid=[-122.255941,44.211893]; %%% PRIMET
% for q=1:length(file(:,1))   
%     outgpd=[];outgev=[];
%     for f=1:length(rp(:,1))
%         disp(f)
%         data=importdata(['D:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\Output_for_krigging_revised\PDS\',file(q,:),'\',num2str(rp(f,:)),'yr']);
%         k = dsearchn(data(:,1:2),grid);
%         outgpd=[outgpd;[rp(f,1),data(k,3),data(k,6),data(k,9)]];
% %         
%         data=importdata(['D:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\Output_for_krigging_revised\AMS\',file(q,:),'\',num2str(rp(f,:)),'yr']);
%         k = dsearchn(data(:,1:2),grid);
%         outgev=[outgev;[rp(f,1),data(k,3),data(k,6),data(k,9)]];
%     end
%     dlmwrite(['D:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\RL_for_Comparison_plot\H15MET\AMS\',file(q,:)],outgev,'delimiter','\t');
%     dlmwrite(['D:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\RL_for_Comparison_plot\H15MET\PDS\',file(q,:)],outgpd,'delimiter','\t');
% end

%% Plotting code
%% 
clc
clear all
ls=dir(['D:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\RL_for_Comparison_plot\']);
np=1;
file=['15min';'30min';'01hrs';'02hrs';'03hrs';'06hrs';'12hrs';'24hrs'];
g=[4;3;5];
tabf=[];
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
    N25=[];N50=[];N100=[];tab=[];
    for di=1:length(file(:,1))
        duration=file(di,:);
        
%         rll=importdata(['D:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\ONSITE\Return_Level_GPD\98p\',site,'\Lmoments\',duration]);
        
        rll=importdata(['D:\Sourav\USFS\Revised\HJ Andrews\RFA_results\',site,'\',duration]);
        lab=[lab;duration];
        z25=find(rll(:,1)==25);z50=find(rll(:,1)==50);z100=find(rll(:,1)==100);
        out25(n,1:4)=rll(z25,1:4);
        out50(n,1:4)=rll(z50,1:4);
        out100(n,1:4)=rll(z100,1:4);
        if di>2
%         noaa=importdata(['D:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\RL_for_Comparison_plot\',site,'\PDS/',duration]);
        noaa=importdata(['D:\Sourav\USFS\Revised\HJ Andrews\data_for_Reg_FA\NOAA\RL_for_Comparison_plot\',site,'\AMS/',duration]);
        N25(n,1:4)=noaa(4,1:4);
        N50(n,1:4)=noaa(5,1:4);
        N100(n,1:4)=noaa(6,1:4);
        else
        N25(n,1:4)=repmat(NaN,4,1)';
        N50(n,1:4)=repmat(NaN,4,1)';
        N100(n,1:4)=repmat(NaN,4,1)';
        end
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
%     gx=max([out100(:,4);N100(:,4)])
    yticks([0:1:6])
    yticklabels([0:1:6])
    xtickangle(45)
    xticklabels(lab)
    ylabel('PI (cm/hr)')
    xlabel('Duration')
    xlim([0.99 n-0.5])
    ylim([0,6])
    set(gca,'TickDir','out','FontName','Sans Serif','FontSize',7);
    set(gca,'TickLength',[0.001, 0.001])
%     title(['PIDF ',site])
    box('on')
    grid on

    axes(ha(np+1))
%     subplot(3,2,np+1)
    D1=[];D2=[];D3=[];clab=[lab;lab;lab];
    if di>2
    for i=1:length(out25(:,1))
        D1=[D1,round(((out25(i,3)-N25(i,3))/N25(i,3))*100)];
        D2=[D2,round(((out50(i,3)-N50(i,3))/N50(i,3))*100)];
        D3=[D3,round(((out100(i,3)-N100(i,3))/N100(i,3))*100)];
    end
    
    % Initialize data points
    
    P = [D1; D2; D3];P(:,1:2)=[];
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
   
    tabf=[tabf;P];
    ylabel('Duration')
    xlabel('Relative Difference (%)')
    yticks([xtp])
    xticks([-50:10:50])
    xticklabels([-50:10:50])
    yticklabels([lab(3:end,:);lab(3:end,:);lab(3:end,:)])
    
%     title(['Relative Diff. ',site])
    xlim([-60 60])
    box('on')
    np=np+2;clab=[];
    grid('on')
    set(gca,'TickDir','out','FontName','Sans Serif','FontSize',7);
    set(gca,'TickLength',[0.001, 0.001])
    else
    end
end
