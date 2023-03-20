
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

%% Define the neighbourhood structure using a FieldTrip function. 
cfg = [];
cfg.method = 'triangulation';
cfg.layout = 'acticap-64ch-standard2-modified.mat';
cfg.feedback = 'no';
neighbours = ft_prepare_neighbours(cfg);

%% Statistical analysis of time-domain data at the group level
% Creating a FieldTrip design matrix
design = zeros(1,2*nSubs); % for within-subjects analysis,the design matrix contains two rows
for i = 1:nSubs
  design(1,i) = i;
end
for i = 1:nSubs
  design(1,nSubs+i) = i;
end
design(2,1:nSubs) = 1;
design(2,nSubs+1:2*nSubs) = 2;                            

%% no correction
cfg = [];
cfg.channel = {'all'}; 
%cfg.latency = [-0.9 1.5];
cfg.statistic = 'ft_statfun_depsamplesT';
cfg.method = 'analytic';
cfg.correctm = 'no';
cfg.alpha = 0.005; 
cfg.design = design;
cfg.uvar = 1; % the 1st row in cfg.design contains the independent variable
cfg.ivar = 2; % the 2nd row in cfg.design contains the subject number
statErp = ft_timelockstatistics(cfg,allERP_LocalDeviant{:},allERP_LocalStandard{:});

% % Plotting stat output
% cfg = [];
% cfg.layout = 'acticap-64ch-standard2-modified.mat';
% cfg.parameter = 'stat';
% cfg.maskparameter = 'mask';
% cfg.graphcolor = 'k';
% cfg.showcomment = 'no';
% cfg.showscale = 'no';
% cfg.showlabels = 'yes';
% figure;
% ft_multiplotER(cfg,statErp);

%% Plotting stat difference ERP at Cz electrode
cfg = [];
% cfg.ylim = [-6 16];
cfg.channel = {'Cz'};
cfg.parameter = 'stat';
cfg.maskparameter = 'mask';
cfg.linewidth = 2;
cfg.graphcolor = 'k';
figure(1);
ft_singleplotER(cfg,statErp);
set(gca,'Fontsize',14);
title ('T-test with no correction at Cz electrode (p<0.005)');
set(gca,'box','on');
xlabel('time (s)');
ylabel('Local Standard vs. Local Deviant');
xlim([-1,1.5]);
saveas(figure(1),'Local_ERP_stat_Cz','png')

% Plotting MMN component (190 - 250 ms) topography in units of t-value
cfg = [];
cfg.layout = 'acticap-64ch-standard2-modified.mat';
cfg.xlim = [0.19 0.25];
cfg.parameter = 'stat';
% cfg.zlim = [-5 5];
cfg.colormap = parula;
cfg.marker = 'off';
cfg.style = 'fill';
cfg.comment = ' ';
cfg.colorbar = 'yes';
figure(2);
ft_topoplotER(cfg,statErp);
title('MMN topography (190 - 250 ms)')
c = colorbar;
c.LineWidth = 1;
c.FontSize = 14;
title(c,'t-val')
saveas(figure(2),'Local_MMN_stat','png')
