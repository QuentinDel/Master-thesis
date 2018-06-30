% 
% load('Results/DetectionPeriod/differentLengthTraining/Results_2018_06_20_PER_0_1_p_jam_0_4-ONOFF5-10-15-50-75-100.mat');
% onOffResults = Results.ratioAttackDetectedInPeriod(:, :, 3);
% load('Results/DetectionPeriod/differentLengthTraining/Results_2018_06_20_PER_0_1_p_jam_0_4-random5-10-15-50-75-100.mat');
% randomResults = Results.ratioAttackDetectedInPeriod(:, :, 3);


load('Results/DetectionPeriod/correctPdetection/Results-DifTrainLength-N-15_2018_06_20_PER_0_1_p_jam_0_4-ONOFF.mat');
onOffResults = Results.ratioAttackDetectedInPeriod(:, :, 5);
load('Results/DetectionPeriod/correctPdetection/Results-DifTrainLength-N-15_2018_06_20_PER_0_1_p_jam_0_4-random.mat');
randomResults = Results.ratioAttackDetectedInPeriod(:, :, 5);

 
 
%Place holder for window-based
% MCC_window_random_jamming_m=mean(randomResults,2);
% MCC_window_onoff_jamming_m=mean(onOffResults,2);
% MCC_window_random_jamming_s=std(randomResults,2);
% MCC_window_onoff_jamming_s=std(onOffResults,2);
%  
 
% load('Results_MCC_25_5-100_5.mat')
%MCC_random_jamming_m=rand(1,20);
%MCC_random_jamming_s=MCC_window_random_jamming_s;
MCC_random_jamming_m=mean(randomResults,2)';
MCC_random_jamming_s=std(randomResults');
MCC_onoff_jamming_m=mean(onOffResults,2)';
MCC_onoff_jamming_s=std(onOffResults');
 
% load('Results_ON_OFF_MCC_25_5-100_5.mat')
%MCC_onoff_jamming_m=rand(1,20);
%MCC_onoff_jamming_s=MCC_window_onoff_jamming_s;

N=7;
 
% load('results_fscore_5_25_jitter.mat')
% onoff_mean=mean(F_score_onoff_jamming,1);
% onoff_std=std(F_score_onoff_jamming,1);
% 
% random_mean=mean(F_score_random_jamming,1);
% random_std=std(F_score_random_jamming,1);
 
 
% err = [random_std; onoff_std];
 
% figure(2)
% hold on
% errorbar(N,random_mean,random_std,'s','MarkerSize',10,...
%     'MarkerEdgeColor','red','MarkerFaceColor','red')
% errorbar(N,onoff_mean,onoff_std,'s','MarkerSize',10,...
%     'MarkerEdgeColor','red','MarkerFaceColor','red')
% bar(N',y')
% errorbar(N,y,err,'s','MarkerSize',10,...
%     'MarkerEdgeColor','red','MarkerFaceColor','red')
% xlabel('$N$','fontsize',18)
% ylabel('$F_1$','fontsize',18)
% xlim([4 26]);
 
% data2 = [random_mean, onoff_mean];
group = [ MCC_random_jamming_m; MCC_onoff_jamming_m ];
k = 1;
for i=1:N
    for j = 1:2
        if j == 1
            err(1,k) = MCC_random_jamming_s(i);
            data2(1,k) = MCC_random_jamming_m(i);
        else
            err(1,k) = MCC_onoff_jamming_s(i);
            data2(1,k) = MCC_onoff_jamming_m(i);            
        end
        k = k + 1; 
    end
end
%err = [random_std, onoff_std];
%data2 = [random_std, onoff_mean];
figure()
%subplot(1,2,1)
set(gca,'FontSize',16) 
hold on
bar(1:N,group')
errorbar([0.86,1.14,1.86,2.14,2.86,3.14,3.86,4.14,4.86,5.14, 5.86,6.14, 6.86, 7.14], data2',err','.');%,7.86,8.14,8.86,9.14,9.86,10.14,10.86,11.14,11.86,12.14,12.86,13.14,13.86,14.14,14.86,15.14,15.86,16.14,16.86,17.14,17.86,18.14,18.86,19.14,19.86,20.14],data2,err,'.')
ylim([0.8 1])
xlabel('Length of training data, s','fontsize',18)
ylabel('Matthews Correlation Coefficient','fontsize',18)
%xticks([1:1:N])
set(gca,'XTick',[1:1:N])

%xticklabels([5:5:5*N])
set(gca,'XTickLabel',[1, 5, 10, 15, 50, 75, 100])
%xticklabels({'-3\pi','-2\pi','-\pi','0','\pi','2\pi','3\pi'})
box on
%title('Random jamming','fontsize',18)
legend( 'Random jamming', 'ON-OFF jamming', 'Standard deviation')
 
%same thing for the other panel
% data2=[];
% err=[];
% group = [MCC_window_onoff_jamming_m; MCC_onoff_jamming_m ];
% k = 1;
% for i=1:N
%     for j = 1:2
%         if j == 1
%             err(1,k) = MCC_window_onoff_jamming_s(1,i);
%             data2(1,k) = MCC_window_onoff_jamming_m(1,i);            
%         else
%             err(1,k) = MCC_onoff_jamming_s(1,i);
%             data2(1,k) = MCC_onoff_jamming_m(1,i);
%         end
%         k = k + 1; 
%     end
% end
% 
% subplot(1,2,2)
% set(gca,'FontSize',16) 
% hold on
% bar(1:N,group')
% errorbar([0.86,1.14,1.86,2.14,2.86,3.14,3.86,4.14,4.86,5.14, 5.86,6.14, 6.86,7.14,7.86,8.14,8.86,9.14,9.86,10.14,10.86,11.14,11.86,12.14,12.86,13.14,13.86,14.14,14.86,15.14,15.86,16.14,16.86,17.14,17.86,18.14,18.86,19.14,19.86,20.14],data2,err,'.')
% ylim([0 1])
% xlabel('Length of training data, s','fontsize',18)
% ylabel('Matthews Correlation Coefficient','fontsize',18)
% xticks([2:2:20])
% xticklabels([10:10:100])
% legend( 'Window-based detector', 'Hybrid detector', 'Standard deviation')
% box on
% title('ON-OFF jamming','fontsize',18)
 
% young= [458.05,509.63]; %values are for young and old respectively
% young2= [458.05,509.63,200,340];
% old= [200,340];
% group = [young;old];
% SEM=[12,12,56,45]; % values for error bars
%  figure
% hold on
% bar(1:2,group)
% errorbar([0.86,1.14,1.86,2.14],young2,SEM,'.') %errorbar(x,y,err)