
clc; clear; close all;
subs = [1:5,8,10:21];
nSubs = length(subs);

% path define
currentdir = pwd;                    % get current path

% where to save decoding output
saveLocation = pwd; % set directory for decoding results.

%% Computing group average ERP

allERP_LocalStandard = cell(1,nSubs);
allERP_LocalDeviant = cell(1,nSubs);

% Loading single subject ERPs in a single cell array
for s = 1:nSubs
    sn = subs(s);
    fprintf('Subject:\t%d\n',sn)
    % load data
    currentSub = num2str(sn,'%02d');
    loadThis = strcat(currentdir,'/Results_ERP_Local_',currentSub,'.mat');
    load(loadThis)
    allERP_LocalStandard{s} = ERP_LocalStandard;
    allERP_LocalDeviant{s} = ERP_LocalDeviant;
    allERP_Differ{s} = ERP_diff;
end

% Computing grand average across subjects
% Local Standard
cfg = [];
cfg.keepindividual = 'yes';
grandAvgERP_LocalStandard = ft_timelockgrandaverage(cfg,allERP_LocalStandard{:});
% Local Deviant
cfg = [];
cfg.keepindividual = 'yes';
grandAvgERP_LocalDeviant = ft_timelockgrandaverage(cfg,allERP_LocalDeviant{:});
% differ between two conditions
cfg = [];
cfg.keepindividual = 'yes';
grandAvgERP_Differ = ft_timelockgrandaverage(cfg,allERP_Differ{:});

% %% Visualization of the group average ERP
% % Plotting ERP time courses of at each electrode in both conditions
% cfg = [];
% cfg.layout = 'acticap-64ch-standard2-modified.mat';
% cfg.graphcolor = 'br';
% cfg.showcomment = 'no';
% cfg.showscale = 'no';
% cfg.showlabels = 'yes';
% figure;
% ft_multiplotER(cfg,grandAvgERP_LocalStandard,grandAvgERP_LocalDeviant);
% 
% % Plotting ERP time courses of the difference between two conditions at each electrode
% cfg = [];
% cfg.layout = 'acticap-64ch-standard2-modified.mat';
% cfg.graphcolor = 'br';
% cfg.showcomment = 'no';
% cfg.showscale = 'no';
% cfg.showlabels = 'yes';
% figure;
% ft_multiplotER(cfg,grandAvgERP_Differ);

% Plotting mean ERPs with Standard error(se) over fronto-central electrodes in both conditions
cfg = [];
cfg.channel = {'Cz'}; % AFz, Fz, FCz, Cz, CPz
cfg.avgoverchan = 'yes'; % averaging over channels
grandavgSel01 = ft_selectdata(cfg,grandAvgERP_LocalDeviant);
grandavgSel02 = ft_selectdata(cfg,grandAvgERP_LocalStandard);
x01 = grandavgSel01.time'; % defining x axis
x02 = grandavgSel02.time'; % defining x axis
y01 = mean(squeeze(grandavgSel01.individual),1)'; % defining y axis
y02 = mean(squeeze(grandavgSel02.individual),1)'; % defining y axis
e01 = std(squeeze(grandavgSel01.individual),1)'/sqrt(nSubs); % Standard error 
e02 = std(squeeze(grandavgSel02.individual),1)'/sqrt(nSubs); % Standard error 
low01 = y01 - e01; % lower bound
low02 = y02 - e02; % lower bound
high01 = y01 + e01; % upper bound
high02 = y02 + e02; % upper bound
figure(1);
hp01 = patch([x01; x01(end:-1:1); x01(1)], [low01; high01(end:-1:1); low01(1)], 'r');
hp02 = patch([x02; x02(end:-1:1); x02(1)], [low02; high02(end:-1:1); low02(1)], 'b');
hold on;
hl = line(x01,y01);
h2 = line(x02,y02);
set(hp01,'facecolor',[1 0.8 0.8],'edgecolor','none');
set(hp02,'facecolor',[0.8 0.8 1],'edgecolor','none');
set(hl,'color','r','linewidth',2);
set(h2,'color','b','linewidth',2);
set(gca,'FontSize',12);
title ('ERPs at Cz electrode');
set(gca,'box','on');
xlabel('time (s)');
ylabel('amplitude (\muV)');
xlim([-1 1.5])
legend([hl,h2],'Local Deviant','Local Standard','Location','NorthEast')
saveas(figure(1),'Local_ERP_Cz','png')
