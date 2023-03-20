% compute average decoding accuracy and perform cluster-based permutation
% analysis.

clear all
subList = [1:5,8,10:21];
Nsub = length(subList);

Nblock = 10; % cross-validation
Nitr = 5; % iteration
Ntp = 250; % # of time points
NBins = 2; % # of condition bin

tm = -950:10:1548;

%create empty matrix
AverageAccuracy = nan(Nsub,Ntp);

for sub = 1:Nsub
    DecodingAccuracy = nan(Ntp,Nitr,Nblock);
    
    %% load SVM_ECOC output files
    fileLocation = pwd;
    
    readThis =strcat(fileLocation,'/Results_Local_singleTrial_norm_',num2str(subList(sub),'%02d'),'.mat');
    load(readThis)
    
    % prediciton from SVM-ECOC model
    svmPrediction = svmECOC.modelPredict;
    tstTargets = svmECOC.targets;
    clear svmECOC
    
    % compute decoding accuracy of each decoding trial
    for itr = 1:Nitr
        for block = 1:Nblock
            for tp = 1:Ntp
                prediction = squeeze(svmPrediction(itr,tp,block,:)); % this is predictions from models
                TrueAnswer = squeeze(tstTargets(itr,tp,block,:)); % this is predictions from models
                Err = TrueAnswer - prediction;
                ACC = mean(Err==0);
                DecodingAccuracy(tp,itr,block) = ACC; % average decoding accuracy
            end
        end
    end
    
    %average across block and iterations
    grandAvg = squeeze(mean(mean(DecodingAccuracy,2),3));
    
    % perform temporal smoothing
    smoothed = nan(1,Ntp);
    for tAvg = 1:Ntp
        if tAvg ==1
            smoothed(tAvg) = mean(grandAvg((tAvg):(tAvg+2)));
        elseif tAvg ==2
            smoothed(tAvg) = mean(grandAvg((tAvg-1):(tAvg+2)));
        elseif tAvg == (Ntp-1)
            smoothed(tAvg) = mean(grandAvg((tAvg-2):(tAvg+1)));
        elseif tAvg == Ntp
            smoothed(tAvg) = mean(grandAvg((tAvg-2):(tAvg)));
        else
            smoothed(tAvg) = mean(grandAvg((tAvg-2):(tAvg+2)));
        end
    end
    
    % Save smoothe data
    AverageAccuracy(sub,:) =smoothed; % average across iteration and block
    
end %End of subject

%compute average accuracy across participants and SE of the mean.
subAverage = squeeze(mean(AverageAccuracy,1));
seAverage = squeeze(std(AverageAccuracy,1))/sqrt(Nsub);

% figure
% plot(tm,subAverage,'LineWidth',2);
% xlim([-950 1548])
% xlabel('Time (ms)','fontsize',14);ylabel('Decoding Accuracy','fontsize',14)
% hold on
% h = line(tm,1/2* ones(1,Ntp));
% h.LineStyle = '--';
% h.Color = [0.1,0.1,0.1];
% set(gca,'linewidth',1,'fontsize',13);
% title('Local decoding','fontsize',14)
% hold off

%% do cluster mass analyses
releventTime = 1:250; % from -950 ms - 1548 ms

% t-test at each relevent time point
Ps = nan(2,length(releventTime));
for i = 1:length(releventTime)
    tp = releventTime(i);
    
    [H,P,CI,STATS] =  ttest(AverageAccuracy(:,tp), 0.5, 'tail', 'right'); % one sample t-test
    
    Ps(1,i) = STATS.tstat;
    Ps(2,i) = P;
end

% find significant time points
candid = Ps(2,:) <= .05;

%remove orphan time points
candid_woOrphan = candid;
candid_woOrphan(1,1) = candid(1,1);
for i = 2:(length(releventTime)-1)
    
    if candid(1,i-1) == 0 && candid(1,i) ==1 && candid(1,i+1) ==0
        candid_woOrphan(1,i) = 0;
    else
        candid_woOrphan(1,i) = candid(1,i);
    end
    
end

% combine whole time range with relevent time & significant information
clusters = zeros(length(tm),1);
clusterT = zeros(length(tm),1);
clusters(releventTime,1) = candid_woOrphan;
clusterT(releventTime,1) = Ps(1,:);
clusterTsum = sum(Ps(1,logical(candid_woOrphan)));

%%find how many clusters are there, and compute summed T of each cluster
tmp = zeros(10,300);
cl = 0;
member = 0;
for i = 2:length(clusters)-1
    
    if clusters(i-1) ==0 && clusters(i) == 1 && clusters(i+1) == 1
        cl = cl+1;
        member = member +1;
        tmp(cl,member) = i;
        
    elseif clusters(i-1) ==1 && clusters(i) == 1 && clusters(i+1) == 0
        member = member +1;
        tmp(cl,member) = i;
        member = 0;
    elseif clusters(i-1) ==1 && clusters(i) == 1 && clusters(i+1) == 1
        member = member +1;
        tmp(cl,member) = i;
        
    else
        
    end
end


HowManyClusters = cl;
a = tmp(1:cl,:); % subset significant clusters
eachCluster = a(:,logical(sum(a,1)~=0)); % cut the size at the maximum cluster

%now, compute summed T of each cluster
dat_clusterSumT = nan(HowManyClusters,1);
for c = 1:HowManyClusters
    dat_clusterSumT(c,1) = sum(clusterT(eachCluster(c,eachCluster(c,:) ~=0)));
end

%% do monte-carlo simulation
NPermutations = 1000;

%% note: simulation takes very long time.

load('Permutation_Local_singleTrial_norm.mat')

%% find critical t-value
cutOff = NPermutations - NPermutations * 0.05; %one tailed
critT = permutedT(cutOff); % t-mass of top 95%
sigCluster = dat_clusterSumT > critT;

%% plot significant clusters
figure(1)
cl=colormap(parula(50));
% draw average accuracy
accEst = squeeze(subAverage);
% draw clusters
draw = eachCluster(sigCluster,:);
draw = sort(reshape(draw,1,size(draw,1)*size(draw,2)));
draw = draw(draw>0);

w = zeros(Ntp,1);
w(draw)=1;
a = area(1:length(tm), accEst.*w');
a.EdgeColor = 'none';
a.FaceColor = [0.9,0.9,0.9];
child = get(a,'Children');
set(child,'FaceAlpha',0.9)

% draw mean and SE of average decoding accuracy
hold on
mEI = boundedline(1:length(tm),subAverage,seAverage, 'cmap','k','alpha','transparency',0.5);
xlabel('Time (ms)','fontsize',14);ylabel('Decoding Accuracy','fontsize',14)
ax = gca;
ax.YLim = [0.45, 0.6];
ax.YTick = [0.45:0.05:0.6];
ax.XLim = [16, 236];
ax.XTick = [16 36 56 76 96 116 136 156 176 196 216 236];
ax.XTickLabel = {'-800','-600','-400','-200','0','200','400','600','800','1000','1200','1400'};
set(gca,'linewidth',1,'fontsize',13);
h = line(1:length(tm),0.5* ones(1,Ntp));
h.LineStyle = '--';
h.Color = [0.1,0.1,0.1];
ylim=get(gca,'Ylim'); 
line([find(tm==0),find(tm==0)],ylim,'linestyle','--','color',[0.1,0.1,0.1]);
title('Decoding: Local standard vs. Local deviant ','fontsize',15)
hold off

saveas(figure(1),'Local_ERP_Permutation_norm','png')