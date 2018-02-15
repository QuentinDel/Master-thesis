%function [features, Xval] = performAllData()
%function [pval, mu, sigma2, features] = performAllData()
%function 
%Score
% Get the data from all the data sets and print the result

path = 'Data/2017_01_19/';
datasetNames = dir(strcat(path, '*.mat'));

idCrossDataset = 4;

for o = idCrossDataset : idCrossDataset     %size(datasetNames, 1)
    %disp(strcat('Train with dataset: ', num2str(i)));
    
    [colDict, colDictCollideWith, emissionsVehicles, frequencyCol, cut, periods] = createColDict(o);
    [muEmiss, sigma2Emiss] = estimateGaussian(emissionsVehicles);
    
    dataExtraction = strcat(path, datasetNames(o).name);
    withJam = true;
    %[scores, training_part, detect_init, detect] = extractFeatures(strcat(path, datasetNames(i).name), true, colDict, colDictCollideWith, muEmiss, sigma2Emiss, frequencyCol);
    extractFeatures;
    yval = findYval(detect, detect_init, training_part);
    
    tp = sum(yval == 1 & scores == 1);
    fp = sum(yval == 0 & scores == 1);
    fn = sum(yval == 1 & scores == 0);
    
    prec = tp / (tp + fp);
    rec = tp / (tp + fn);

    F1 = 2*prec*rec / (prec + rec);
    
    fprintf('\n----------- Results data set %d -----------\n', o);
    fprintf('Collisions predicted correctly: %d/%d\n', sum(yval == scores),  sum(scores > -1));
    fprintf('\tFirst filtration: %d/%d\n', sum(yval(posFirstFilt) == scores(posFirstFilt)), length(posFirstFilt));
    fprintf('\tSecond filtration: %d/%d\n', sum(yval(posSecondFilt) == scores(posSecondFilt)), length(posSecondFilt));
    fprintf('\tNumber of predicted jammed collisions: %d/%d\n', sum(scores == 1), sum(yval == 1));
    fprintf('\tF1 score: %d\n', F1);    
    fprintf('Collisions that have been checked: %d/%d\n\n', sum(scores > -1), size(yval, 2));

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

