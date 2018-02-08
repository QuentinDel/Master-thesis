%function [features, Xval] = performAllData()
%function [pval, mu, sigma2, features] = performAllData()
%function 
%Score
% Get the data from all the data sets and print the result

path = 'Data/2017_01_19/';
datasetNames = dir(strcat(path, '*.mat'));

idCrossDataset = 1;

for i = idCrossDataset : idCrossDataset     %size(datasetNames, 1)
    %disp(strcat('Train with dataset: ', num2str(i)));
    
    [colDict, colDictCollideWith, emissionsVehicles, frequencyCol] = createColDict(i);
    [muEmiss, sigma2Emiss] = estimateGaussian(emissionsVehicles);
    
    dataExtraction = strcat(path, datasetNames(i).name);
    withJam = true;
    %[scores, training_part, detect_init, detect] = extractFeatures(strcat(path, datasetNames(i).name), true, colDict, colDictCollideWith, muEmiss, sigma2Emiss, frequencyCol);
    extractFeatures;
    yval = findYval(detect, detect_init, training_part);
%     
     nbRight = sum(yval == scores)
     nbChecked = sum(scores == 1) + sum(scores == 0)
     total = size(yval, 2)
%     if ffcheck1 ~= ffcheck2
%        fprintf('Bad evaluation first filtration'); 
%        ffcheck1
%        ffcheck2
%     else
%         fprintf('\nfirst filtration contains : %d on %d col in total\n', ffcheck1, length(yval));
%     end
%     
%     
%     figure();
%     subplot(2,1,1)       % add first plot in 2 x 1 grid
%     bar(yval)
%     title('True value')
% 
%     subplot(2,1,2)       % add second plot in 2 x 1 grid
%     bar(yval == scores);  % plot using + markers
%     title('First filtration');
%     legend('1 = evaluated correctly');
%     
end



% for j  = 1 : length(toExploreNbPeriodInPast)
%         colDic
%         nbPeriodInPast = toExploreNbPeriodInPast(j);
%         disp(strcat('Train with nb periods in past:  ', num2str(nbPeriodInPast)));
% 
%         %Get training data set
%         [features] = extractFeatures(strcat(path, datasetNames(i).name), false, nbPeriodInPast);
% 
%         %Get CrossValidation set
%         dataset = load(strcat(path, datasetNames(i).name));
%         [Xval, numberOfCollisionsInPast] = extractFeatures(strcat(path, datasetNames(i).name), true, nbPeriodInPast);
%         cuttedNumber(i, j) = numberOfCollisionsInPast;
%         disp(strcat('Cutted number of collisions: ', num2str(numberOfCollisionsInPast)));
% 
%         yval = findYval(dataset.detect, dataset.detect_init, numberOfCollisionsInPast);
%         N = dataset.N;
%         %[score(i, j)] = performTest(features, Xval, yval);
%         performTest
%     end
%end

