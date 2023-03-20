clc; clear; close all;

load('ERP_all.mat');
load('EyePupil_all.mat');

% time points 
time = -0.7:0.002:1.5; % s
nSubs = 16;

% local
local_erp = ERP_locDeviant_all(:,126:1226) - ERP_locStandard_all(:,126:1226);
local_pupil = EyePupil_locDeviant_all([1:15,18],151:1251) - EyePupil_locStandard_all([1:15,18],151:1251);

% global
global_erp = ERP_globDeviant_all(:,126:1226) - ERP_globStandard_all(:,126:1226);
global_pupil = EyePupil_globDeviant_all([1:15,18],151:1251) - EyePupil_globStandard_all([1:15,18],151:1251);

% omissionX
omissionX_erp = ERP_OmissionX_all(:,1:1101) - ERP_nonOmissionX_all(:,1:1101);
omissionX_pupil = EyePupil_OmissionX_all([1:15,18],151:1251) - EyePupil_nonOmissionX_all([1:15,18],151:1251);

% omissionY
omissionY_erp = ERP_OmissionY_all(:,1:1101) - ERP_nonOmissionY_all(:,1:1101);
omissionY_pupil = EyePupil_OmissionY_all([1:15,18],151:1251) - EyePupil_nonOmissionY_all([1:15,18],151:1251);

% calculate corss-correlation
%% local
for i = 1:nSubs
    [r_local(i,:),lags_local(i,:)] = xcorr(local_pupil(i,:), local_erp(i,:),'coeff');
end

% Fig15.A
figure(1);
% Plotting mean correlation with Standard error(se)
x = 0.002*lags_local(1,:)'; % defining x axis
y = mean(r_local,1)'; % defining y axis
e = std(r_local,1)'/sqrt(nSubs); % Standard error 
low = y - e; % lower bound
high = y + e; % upper bound
hp = patch([x; x(end:-1:1); x(1)], [low; high(end:-1:1); low(1)], 'k');
hold on;
h = line(x,y);
set(hp,'facecolor',[0.8 0.8 0.8],'edgecolor','none');
set(h,'color','k','linewidth',2);
set(gca,'FontSize',12);
title ('Cross Correlation between ERP and Pupil: Local');
set(gca,'box','on');
xlabel('Time (s)');
ylabel('Cross Correlation');
xlim([-2.2 2.2])
saveas(figure(1),'cross_crorelation_local','png')

%% global
for i = 1:16
    [r_global(i,:),lags_global(i,:)] = xcorr(global_pupil(i,:), global_erp(i,:),'coeff');
end

% Fig15.B
figure(2);
% Plotting mean correlation with Standard error(se)
x = 0.002*lags_global(1,:)'; % defining x axis
y = mean(r_global,1)'; % defining y axis
e = std(r_global,1)'/sqrt(nSubs); % Standard error 
low = y - e; % lower bound
high = y + e; % upper bound
hp = patch([x; x(end:-1:1); x(1)], [low; high(end:-1:1); low(1)], 'k');
hold on;
h = line(x,y);
set(hp,'facecolor',[0.8 0.8 0.8],'edgecolor','none');
set(h,'color','k','linewidth',2);
set(gca,'FontSize',12);
title ('Cross Correlation between ERP and Pupil: Global');
set(gca,'box','on');
xlabel('Time (s)');
ylabel('Cross Correlation');
xlim([-2.2 2.2])
saveas(figure(2),'cross_crorelation_global','png')

%% omissionX
for i = 1:16
    [r_omissionX(i,:),lags_omissionX(i,:)] = xcorr(omissionX_pupil(i,:), omissionX_erp(i,:),'coeff');
end

% Fig15.C
figure(3);
% Plotting mean correlation with Standard error(se)
x = 0.002*lags_omissionX(1,:)'; % defining x axis
y = mean(r_omissionX,1)'; % defining y axis
e = std(r_omissionX,1)'/sqrt(nSubs); % Standard error 
low = y - e; % lower bound
high = y + e; % upper bound
hp = patch([x; x(end:-1:1); x(1)], [low; high(end:-1:1); low(1)], 'k');
hold on;
h = line(x,y);
set(hp,'facecolor',[0.8 0.8 0.8],'edgecolor','none');
set(h,'color','k','linewidth',2);
set(gca,'FontSize',12);
title ('Cross Correlation between ERP and Pupil: omissionX');
set(gca,'box','on');
xlabel('Time (s)');
ylabel('Cross Correlation');
xlim([-2.2 2.2])
saveas(figure(3),'cross_crorelation_omissionX','png')

%% omissionY
for i = 1:16
    [r_omissionY(i,:),lags_omissionY(i,:)] = xcorr(omissionY_pupil(i,:), omissionY_erp(i,:),'coeff');
end

% Fig15.D
figure(4);
% Plotting mean correlation with Standard error(se)
x = 0.002*lags_omissionY(1,:)'; % defining x axis
y = mean(r_omissionY,1)'; % defining y axis
e = std(r_omissionY,1)'/sqrt(nSubs); % Standard error 
low = y - e; % lower bound
high = y + e; % upper bound
hp = patch([x; x(end:-1:1); x(1)], [low; high(end:-1:1); low(1)], 'k');
hold on;
h = line(x,y);
set(hp,'facecolor',[0.8 0.8 0.8],'edgecolor','none');
set(h,'color','k','linewidth',2);
set(gca,'FontSize',12);
title ('Cross Correlation between ERP and Pupil: omissionY');
set(gca,'box','on');
xlabel('Time (s)');
ylabel('Cross Correlation');
xlim([-2.2 2.2])
saveas(figure(4),'cross_crorelation_omissionY','png')
