resultsPath = 'Results/DetectionPeriod/correctPdetection/';
prePath = 'Data/Data/';
PATHS = {};
PATHS{end+1} = 'DATA_2018_05_25_PER_0_1/ONOFF';
PATHS{end+1} = 'DATA_2018_06_20_PER_0_1_p_jam_0_05/ONOFF';
PATHS{end+1} = 'DATA_2018_06_15_PER_0_1_p_jam_0_1/ONOFF';
PATHS{end+1} = 'DATA_2018_06_20_PER_0_1_p_jam_0_2/ONOFF';
PATHS{end+1} = 'DATA_2018_06_20_PER_0_1_p_jam_0_3/ONOFF';
PATHS{end+1} = 'DATA_2018_06_20_PER_0_1_p_jam_0_4/ONOFF';

PATHS{end+1} = 'DATA_2018_05_25_PER_0_1/random';
PATHS{end+1} = 'DATA_2018_06_20_PER_0_1_p_jam_0_05/random';
PATHS{end+1} = 'DATA_2018_06_15_PER_0_1_p_jam_0_1/random';
PATHS{end+1} = 'DATA_2018_06_20_PER_0_1_p_jam_0_2/random';
PATHS{end+1} = 'DATA_2018_06_20_PER_0_1_p_jam_0_3/random';
PATHS{end+1} = 'DATA_2018_06_20_PER_0_1_p_jam_0_4/random';


pJam = [0.01, 0.05, 0.1, 0.2, 0.3, 0.4];
x = 1 : length(PATHS)/2;

xPos = [];
step = 0.155;
for i = 1 : length(PATHS)/2
    xPos = [xPos, [i - 2 * step : step : i + 2 * step]];
end

meanD = zeros(length(PATHS)/2, 5);
stdD = zeros(length(PATHS)/2, 5);
hold on
for j = 1 : 5

    for i = 1 : length(PATHS)/2
       path = PATHS{i};
       path = strrep(path, '/', '-');
       path = strrep(path, 'DATA', 'Results');
       load(strcat(resultsPath, path, '.mat'), 'Results');   
       meanD(i, j) = mean(Results.ratioAttackDetectedInPeriod(:, j));
       stdD(i, j) = std(Results.ratioAttackDetectedInPeriod(:, j)); 
    end
   
end
yval = meanD';
yval = yval(:);
stdVal = stdD';
stdVal = stdVal(:);

bar(x, meanD);
e = errorbar(xPos,yval,stdVal, '.');

set(gca,'XTick',[1:1:length(PATHS)/2])
%xticklabels([5:5:5*N])
set(gca,'XTickLabel',pJam)
legend( 'N=5', 'N=10', 'N=15', 'N=20', 'N=25');
xlabel('Pjam');
ylabel('Pdetect');

hold off
figure





hold on
for j = 1 : 5

    for i = 1 : length(PATHS)/2
       path = PATHS{i+length(PATHS)/2};
       path = strrep(path, '/', '-');
       path = strrep(path, 'DATA', 'Results');
       load(strcat(resultsPath, path, '.mat'), 'Results');   
       meanD(i, j) = mean(Results.ratioAttackDetectedInPeriod(:, j));
       stdD(i, j) = std(Results.ratioAttackDetectedInPeriod(:, j)); 
    end
   
end
yval = meanD';
yval = yval(:);
stdVal = stdD';
stdVal = stdVal(:);

bar(x, meanD);
e = errorbar(xPos,yval,stdVal, '.');

set(gca,'XTick',[1:1:length(PATHS)/2])
%xticklabels([5:5:5*N])
set(gca,'XTickLabel',pJam/2)
legend( 'N=5', 'N=10', 'N=15', 'N=20', 'N=25');
xlabel('p,');
ylabel('Pdetection');

hold off
