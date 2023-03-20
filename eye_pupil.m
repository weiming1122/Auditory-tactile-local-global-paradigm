
clear; clc; close all;
load('EyePupil_all.mat');
subs = [4,6:22];
nSubs = length(subs);

grandAvg_Standard = mean(EyePupil_Standard_all,1);grandSe_Standard = (std(EyePupil_Standard_all,1))/sqrt(nSubs);
grandAvg_NewFrequency = mean(EyePupil_NewFrequency_all,1);grandSe_NewFrequency = (std(EyePupil_NewFrequency_all,1))/sqrt(nSubs);

grandAvg_globStandard = mean(EyePupil_globStandard_all,1);grandSe_globStandard = (std(EyePupil_globStandard_all,1))/sqrt(nSubs);
grandAvg_globDeviant = mean(EyePupil_globDeviant_all,1);grandSe_globDeviant = (std(EyePupil_globDeviant_all,1))/sqrt(nSubs);

grandAvg_locStandard = mean(EyePupil_locStandard_all,1);grandSe_locStandard = (std(EyePupil_locStandard_all,1))/sqrt(nSubs);
grandAvg_locDeviant = mean(EyePupil_locDeviant_all,1);grandSe_locDeviant = (std(EyePupil_locDeviant_all,1))/sqrt(nSubs);

grandAvg_nonOmissionX = mean(EyePupil_nonOmissionX_all,1);grandSe_nonOmissionX = (std(EyePupil_nonOmissionX_all,1))/sqrt(nSubs);
grandAvg_OmissionX = mean(EyePupil_OmissionX_all,1);grandSe_OmissionX = (std(EyePupil_OmissionX_all,1))/sqrt(nSubs);

grandAvg_nonOmissionY = mean(EyePupil_nonOmissionY_all,1);grandSe_nonOmissionY = (std(EyePupil_nonOmissionY_all,1))/sqrt(nSubs);
grandAvg_OmissionY = mean(EyePupil_OmissionY_all,1);grandSe_OmissionY = (std(EyePupil_OmissionY_all,1))/sqrt(nSubs);

grandAvg_pureOmissionStandard = mean(EyePupil_pureOmissionStandard_all,1);grandSe_pureOmissionStandard = (std(EyePupil_pureOmissionStandard_all,1))/sqrt(nSubs);
grandAvg_pureOmission = mean(EyePupil_pureOmission_all,1);grandSe_pureOmission = (std(EyePupil_pureOmission_all,1))/sqrt(nSubs);

% %% plot Standard vs. New frequency
% % t-test
% for t = 1:length(time),
%     [~, pval(t)] = ttest(EyePupil_NewFrequency_all(:,t), EyePupil_Standard_all(:,t));
% end
% % convert to logical
% signific = nan(1, length(time)); signific(pval<=0.01) = 1;
% figure(1)
% a = area(time, 0.25.*signific');
% a.BaseValue = -0.05;
% a.EdgeColor = 'none';
% a.FaceColor = [0.9,0.9,0.9];
% child = get(a,'Children');
% set(child,'FaceAlpha',0.9)
% colors = cbrewer('qual', 'Set2', 8);
% b = boundedline(time, grandAvg_Standard, grandSe_Standard, ...
%     time, grandAvg_NewFrequency, grandSe_NewFrequency, 'cmap', colors,'alpha','transparency',0.5');
% set(b,'linewidth',2);
% set(gca,'Linewidth',1,'fontsize',13);
% xlabel('Time (s)','fontsize',14);ylabel('EyePupil','fontsize',14)
% title('Standard vs. New frequency','fontsize',14)
% xlim([-1.0 1.5]); set(gca,'XTick',[-1.0:0.5:1.5]);
% ylim([-0.05 0.25]); set(gca,'YTick',[-0.05:0.05:0.25]);
% % instead of a legend, show colored text
% leg = legend(b);
% legnames = {'Standard', 'New Frequency'};
% for i = 1:length(legnames)
%     str{i} = ['\' sprintf('color[rgb]{%f,%f,%f} %s', colors(i, 1), colors(i, 2), colors(i, 3), legnames{i})];
% end
% leg.String = str; leg.Box = 'off'; leg.Location = 'northwest';
% saveas(figure(1),'plot_Standard_vs_New_frequency','png')

%% plot Local standard vs. Local deviant
% t-test
for t = 1:length(time),
    [~, pval(t)] = ttest(EyePupil_locDeviant_all(:,t), EyePupil_locStandard_all(:,t));
end
% convert to logical
signific = nan(1, length(time)); signific(pval<=0.01) = 1;

% Fig13.A
figure(2)
a = area(time, 0.30.*signific');
a.BaseValue = -0.05;
a.EdgeColor = 'none';
a.FaceColor = [0.9,0.9,0.9];
child = get(a,'Children');
set(child,'FaceAlpha',0.9)
colors = cbrewer('qual', 'Set2', 8);
b = boundedline(time, grandAvg_locStandard, grandSe_locStandard, ...
    time, grandAvg_locDeviant, grandSe_locDeviant, 'cmap', colors);
set(b,'linewidth',2);
set(gca,'Linewidth',1,'fontsize',13);
xlabel('Time (s)','fontsize',14);ylabel('EyePupil','fontsize',14)
title('Local standard vs. Local deviant','fontsize',14)
xlim([-1.0 1.5]); set(gca,'XTick',[-1.0:0.5:1.5]);
ylim([-0.05 0.30]); set(gca,'YTick',[-0.05:0.05:0.30]);
% instead of a legend, show colored text
leg = legend(b);
legnames = {'Local standard', 'Local deviant'};
for i = 1:length(legnames)
    str{i} = ['\' sprintf('color[rgb]{%f,%f,%f} %s', colors(i, 1), colors(i, 2), colors(i, 3), legnames{i})];
end
leg.String = str; leg.Box = 'off'; leg.Location = 'northwest';
hold off
saveas(figure(2),'plot_Local','png')

%% plot Global standard vs. Global deviant
% t-test
for t = 1:length(time),
    [~, pval(t)] = ttest(EyePupil_globDeviant_all(:,t), EyePupil_globStandard_all(:,t));
end
% convert to logical
signific = nan(1, length(time)); signific(pval<=0.01) = 1;

% Fig13.B
figure(3)
a = area(time, 0.35.*signific');
a.BaseValue = -0.05;
a.EdgeColor = 'none';
a.FaceColor = [0.9,0.9,0.9];
child = get(a,'Children');
set(child,'FaceAlpha',0.9)
colors = cbrewer('qual', 'Set2', 8);
b = boundedline(time, grandAvg_globStandard, grandSe_globStandard, ...
    time, grandAvg_globDeviant, grandSe_globDeviant, 'cmap', colors);
set(b,'linewidth',2);
set(gca,'Linewidth',1,'fontsize',13);
xlabel('Time (s)','fontsize',14);ylabel('EyePupil','fontsize',14)
title('Global standard vs. Global deviant','fontsize',14)
xlim([-1.0 1.5]); set(gca,'XTick',[-1.0:0.5:1.5]);
ylim([-0.05 0.35]); set(gca,'YTick',[-0.05:0.05:0.35]);
% instead of a legend, show colored text
leg = legend(b);
legnames = {'Global standard', 'Global deviant'};
for i = 1:length(legnames)
    str{i} = ['\' sprintf('color[rgb]{%f,%f,%f} %s', colors(i, 1), colors(i, 2), colors(i, 3), legnames{i})];
end
leg.String = str; leg.Box = 'off'; leg.Location = 'northwest';
hold off
saveas(figure(3),'plot_Global','png')

%% plot Non omision x vs. Omission x
% t-test
for t = 1:length(time),
    [~, pval(t)] = ttest(EyePupil_OmissionX_all(:,t), EyePupil_nonOmissionX_all(:,t));
end
% convert to logical
signific = nan(1, length(time)); signific(pval<=0.01) = 1;

% Fig13.C
figure(4)
a = area(time, 0.30.*signific');
a.BaseValue = -0.05;
a.EdgeColor = 'none';
a.FaceColor = [0.9,0.9,0.9];
child = get(a,'Children');
set(child,'FaceAlpha',0.9)
colors = cbrewer('qual', 'Set2', 8);
b = boundedline(time, grandAvg_nonOmissionX, grandSe_nonOmissionX, ...
    time, grandAvg_OmissionX, grandSe_OmissionX, 'cmap', colors);
set(b,'linewidth',2);
set(gca,'Linewidth',1,'fontsize',13);
xlabel('Time (s)','fontsize',14);ylabel('EyePupil','fontsize',14)
title('Non omision x vs. Omission x','fontsize',14)
xlim([-1.0 1.5]); set(gca,'XTick',[-1.0:0.5:1.5]);
ylim([-0.05 0.30]); set(gca,'YTick',[-0.05:0.05:0.30]);
% instead of a legend, show colored text
leg = legend(b);
legnames = {'Non omision x', 'Omission x'};
for i = 1:length(legnames)
    str{i} = ['\' sprintf('color[rgb]{%f,%f,%f} %s', colors(i, 1), colors(i, 2), colors(i, 3), legnames{i})];
end
leg.String = str; leg.Box = 'off'; leg.Location = 'northwest';
hold off
saveas(figure(4),'plot_Omission_x','png')

%% plot Non omision y vs. Omission y
% t-test
for t = 1:length(time),
    [~, pval(t)] = ttest(EyePupil_OmissionY_all(:,t), EyePupil_nonOmissionY_all(:,t));
end
% convert to logical
signific = nan(1, length(time)); signific(pval<=0.01) = 1;

% Fig13.D
figure(5)
a = area(time, 0.25.*signific');
a.BaseValue = -0.05;
a.EdgeColor = 'none';
a.FaceColor = [0.9,0.9,0.9];
child = get(a,'Children');
set(child,'FaceAlpha',0.9)
colors = cbrewer('qual', 'Set2', 8);
b = boundedline(time, grandAvg_nonOmissionY, grandSe_nonOmissionY, ...
    time, grandAvg_OmissionY, grandSe_OmissionY, 'cmap', colors);
set(b,'linewidth',2);
set(gca,'Linewidth',1,'fontsize',13);
xlabel('Time (s)','fontsize',14);ylabel('EyePupil','fontsize',14)
title('Non omision y vs. Omission y','fontsize',14)
xlim([-1.0 1.5]); set(gca,'XTick',[-1.0:0.5:1.5]);
ylim([-0.05 0.25]); set(gca,'YTick',[-0.05:0.05:0.25]);
% instead of a legend, show colored text
leg = legend(b);
legnames = {'Non omision y', 'Omission y'};
for i = 1:length(legnames)
    str{i} = ['\' sprintf('color[rgb]{%f,%f,%f} %s', colors(i, 1), colors(i, 2), colors(i, 3), legnames{i})];
end
leg.String = str; leg.Box = 'off'; leg.Location = 'northwest';
hold off
saveas(figure(5),'plot_Omission_y','png')

% %% plot Pure Omission Standard y vs. Pure Omission New
% % t-test
% for t = 1:length(time),
%     [~, pval(t)] = ttest(EyePupil_pureOmission_all(:,t), EyePupil_pureOmissionStandard_all(:,t));
% end
% % convert to logical
% signific = nan(1, length(time)); signific(pval<=0.01) = 1;
% figure(6)
% a = area(time, 0.30.*signific');
% a.BaseValue = -0.05;
% a.EdgeColor = 'none';
% a.FaceColor = [0.9,0.9,0.9];
% child = get(a,'Children');
% set(child,'FaceAlpha',0.9)
% colors = cbrewer('qual', 'Set2', 8);
% b = boundedline(time, grandAvg_pureOmissionStandard, grandSe_pureOmissionStandard, ...
%     time, grandAvg_pureOmission, grandSe_pureOmission, 'cmap', colors);
% set(b,'linewidth',2);
% set(gca,'Linewidth',1,'fontsize',13);
% xlabel('Time (s)','fontsize',14);ylabel('EyePupil','fontsize',14)
% title('Pure Omission Standard vs. Pure Omission New','fontsize',14)
% xlim([-1.0 1.5]); set(gca,'XTick',[-1.0:0.5:1.5]);
% ylim([-0.05 0.30]); set(gca,'YTick',[-0.05:0.05:0.30]);
% % instead of a legend, show colored text
% leg = legend(b);
% legnames = {'Pure Omission Standard', 'Pure Omission New'};
% for i = 1:length(legnames)
%     str{i} = ['\' sprintf('color[rgb]{%f,%f,%f} %s', colors(i, 1), colors(i, 2), colors(i, 3), legnames{i})];
% end
% leg.String = str; leg.Box = 'off'; leg.Location = 'northwest';
% hold off
% saveas(figure(6),'plot_pureOmission','png')