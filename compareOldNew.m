load('Results/DetectionPeriod/nojitterP04/Results_2018_06_21_no_jitter_p_jam_0_4-ONOFF.mat');
onOffResults = Results.ratioAttackDetectedInPeriod(1, :, :);
load('Results/DetectionPeriod/nojitterP04/Results_2018_06_21_no_jitter_p_jam_0_4-random.mat');
randomResults = Results.ratioAttackDetectedInPeriod(1, :, :);
load('Results/DetectionPeriod/nojitterP04/P_detection_model_based_p_04.mat');
oldResultOnOff = P;

oldOnOff = zeros(10, 5);
oldRandom = zeros(10, 5);
for i = 1 : 5
   oldOnOff(:,i) = oldResultOnOff(i).P_onoff(1,:);
   oldRandom(:,i) = oldResultOnOff(i).P_rand(1,:);
end

meanOnOff = zeros(2, 5);
meanRand = zeros(2, 5);
stdOnOff = zeros(2, 5);
stdRand = zeros(2, 5);  

meanOnOff(1, :) = mean(onOffResults);
meanOnOff(2, :) = mean(oldOnOff);
stdOnOff(1, :) = std(onOffResults);
stdOnOff(2, :) = std(oldOnOff);

figure
N=5;
hold on
bar(1:N,meanOnOff')
errorbar([0.86,1.14,1.86,2.14,2.86,3.14,3.86,4.14,4.86,5.14], meanOnOff(:),stdOnOff(:),'.');

set(gca,'XTick',[1:1:N])
%xticklabels([5:5:5*N])
set(gca,'XTickLabel',5:5:25)

hold off



%Random
meanRand(1, :) = mean(randomResults);
meanRand(2, :) = mean(oldRandom);
stdRand(1, :) = std(randomResults);
stdRand(2, :) = std(oldRandom);

figure
N=5;
hold on
bar(1:N,meanRand')
errorbar([0.86,1.14,1.86,2.14,2.86,3.14,3.86,4.14,4.86,5.14], meanRand(:),stdRand(:),'.');

set(gca,'XTick',[1:1:N])
%xticklabels([5:5:5*N])
set(gca,'XTickLabel',5:5:25)


hold off







