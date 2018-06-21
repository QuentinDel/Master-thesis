resultsPath = 'Results/DetectionPeriod/';
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
meanD = zeros(length(PATHS), 1);
stdD = zeros(length(PATHS), 1);
Res = cell(length(PATHS), 1);
for i = 1 : length(PATHS)
   path = PATHS{i};
   path = strrep(path, '/', '-');
   path = strrep(path, 'DATA', 'Results');
   load(strcat(resultsPath, path, '.mat'), 'Results');
   Res{i} = Results;
   meanD(i) = mean(Results.ratioAttackDetectedInPeriod(:, 5));
   stdD(i) = std(Results.ratioAttackDetectedInPeriod(:, 5)); 
end
%[stdD(1:length(PATHS)/2), stdD(1 + length(PATHS)/2 : end)]
hold on
y = [meanD(1:length(PATHS)/2), meanD(1 + length(PATHS)/2 : end)];
hBar = bar(pJam, y);
for k = 1 : 2
    ctr(k,:) = bsxfun(@plus, hBar(1).XData, [hBar(k).XOffset]');
    ydt(k,:) = hBar(k).YData;
end

err = [stdD(1:length(PATHS)/2), stdD(1 + length(PATHS)/2 : end)];
errorbar(ctr, ydt, err', '.');
hold off
