clc; clear; close all;

load('Local_t_auditory01.mat');
load('Local_t_auditory02.mat');
load('Local_t_tactile.mat');

load('Global_t_auditory01.mat');
load('Global_t_auditory02.mat');
load('Global_t_tactile.mat');

load('OmissionX_t_auditory01.mat');
load('OmissionX_t_auditory02.mat');
load('OmissionX_t_tactile.mat');

load('OmissionY_t_auditory01.mat');
load('OmissionY_t_auditory02.mat');
load('OmissionY_t_tactile.mat');

% time points and EEG label
time = -0.9:0.01:1.1; % s
label = Local_t_auditory01.label;
nCondition = 12;

% Local effect for three experiments
A1 = mean(Local_t_auditory01.stat(:,571:601),2); % 190-250ms
A2 = mean(Local_t_auditory02.stat(:,526:551),2); % 100-150ms
A3 = mean(Local_t_tactile.stat(:,716:736),2); % 150-190ms
% Global effect for three experiments
A4 = mean(Global_t_auditory01.stat(:,586:926),2); % 220-900ms
A5 = mean(Global_t_auditory02.stat(:,596:801),2); % 240-650ms
A6 = mean(Global_t_tactile.stat(:,916:1091),2); % 550-900ms
% Omission X effect for three experiments
A7 = mean(OmissionX_t_auditory01.stat(:,776:976),2); % 600-1000ms
A8 = mean(OmissionX_t_auditory02.stat(:,776:976),2); % 600-1000ms
A9 = mean(OmissionX_t_tactile.stat(:,991:1191),2); % 700-1100ms
% Omission Y effect for three experiments
A10 = mean(OmissionY_t_auditory01.stat(:,726:976),2); % 500-1000ms
A11 = mean(OmissionY_t_auditory02.stat(:,801:976),2); % 650-1000ms
A12 = mean(OmissionY_t_tactile.stat(:,1016:1191),2); % 750-1100ms

SpatialCorr = nan(nCondition,nCondition);
for m = 1: nCondition
    for n = 1: nCondition
       eval(['SpatialCorr(m,n) = abs(sum(A',num2str(m),'.*A',num2str(n),'))/(sqrt(sum(A',num2str(m),'.^2))*sqrt(sum(A',num2str(n),'.^2)));'])
    end
end

figure(1);
% choosing a good colormap
colors = cbrewer('div', 'RdBu', 64);
colors = flipud(colors); % puts red on top, blue at the bottom
colormap(colors);
imagesc(SpatialCorr); axis tight; axis equal; 
set(gca,'YDir','normal');
set (gca, 'xtick',[1:1:12]); set (gca, 'xticklabel', [1:1:12]); 
set (gca, 'ytick',[1:1:12]); set (gca, 'yticklabel', [1:1:12]); 
set(gca,'linewidth',1,'fontsize',12);
h = colorbar;
set(h, 'ylim', [0 1]);
xlabel('Condition Comparisons',"fontsize",13);
ylabel('Condition Comparisons',"fontsize",13);
title('Spatial correlation: pattern of t values', 'FontSize', 14);
saveas(figure(1),'spatial_correlation_all_ERP_t','png')



