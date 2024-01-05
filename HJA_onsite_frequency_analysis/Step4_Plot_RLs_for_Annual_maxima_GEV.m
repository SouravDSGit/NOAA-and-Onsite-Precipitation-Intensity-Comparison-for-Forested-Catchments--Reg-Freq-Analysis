clc
clear all
file=['15min';'30min';'01hrs';'02hrs';'03hrs';'06hrs';'12hrs';'24hrs'];

for di=1:8
rlb=importdata(['G:/Sourav/USFS/Revised/HJ_Andrews/Return_Level_GEV/Bayesian/',num2str(file(di,:))]);
rlm=importdata(['G:/Sourav/USFS/Revised/HJ_Andrews/Return_Level_GEV/MLE/',num2str(file(di,:))]);
rll=importdata(['G:/Sourav/USFS/Revised/HJ_Andrews/Return_Level_GEV/Lmoments/',num2str(file(di,:))]);
subplot(2,4,di)
hold all
x=[2, 5, 10, 20, 25,30,35,40,45,50,100];
y1=rlb(:,1)';y2=rlb(:,3)';y3=rlb(:,2)';
yn=min(y1);yx=max(y2);
patch([x fliplr(x)], [y1 fliplr(y2)], 'b','FaceAlpha',0.12,'EdgeAlpha',0)
plot(x,y3,'-b','LineWidth',2)

y1=rlm(:,1)';y2=rlm(:,3)';y3=rlm(:,2)';
yn=min(y1);yx=max(y2);
patch([x fliplr(x)], [y1 fliplr(y2)], 'g','FaceAlpha',0.12,'EdgeAlpha',0)
plot(x,y3,'-g','LineWidth',2)

y1=rll(:,1)';y2=rll(:,3)';y3=rll(:,2)';
yn=min(y1);yx=max(y2);
patch([x fliplr(x)], [y1 fliplr(y2)], 'r','FaceAlpha',0.12,'EdgeAlpha',0)
plot(x,y3,'-r','LineWidth',2)

ylabel('Precipitation Intensity (in/hr)')
xlabel('Return Interval (year)')
title(file(di,:))
datae=importdata(['G:/Sourav/USFS/Revised/HJ_Andrews/NOAA_PIDFs/textfiles/AMS_est.txt']);
datal=importdata(['G:/Sourav/USFS/Revised/HJ_Andrews/NOAA_PIDFs/textfiles/AMS_lower.txt']);
datau=importdata(['G:/Sourav/USFS/Revised/HJ_Andrews/NOAA_PIDFs/textfiles/AMS_upper.txt']);
xx=[2,5,10,25,50,100];
errorbar(xx,datae(di,:),datae(di,:)-datal(di,:),datau(di,:)-datae(di,:),'.','MarkerSize',30,'LineWidth',2,'Color','k') 
xlim([0 110])
hold off
end