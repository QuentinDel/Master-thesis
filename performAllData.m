%function [features, Xval] = performAllData()
%function [pval, mu, sigma2, features] = performAllData()
function [score] = performAllData()
%Score
% Get the data from all the data sets and print the result

path = 'Data/2017_01_19/';
datasetNames = dir(strcat(path, '*.mat'));

idCrossDataset = 12;

toExploreNbPeriodInPast = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 120, 140, 150, 200, 300];

score = zeros(idCrossDataset, length(toExploreNbPeriodInPast));

for i = 1 : idCrossDataset     %size(datasetNames, 1)
    disp(strcat('Train with dataset: ', num2str(i)));
    
    for j  = 1 : length(toExploreNbPeriodInPast)
        nbPeriodInPast = toExploreNbPeriodInPast(j);
        disp(strcat('Train with nb periods in past:  ', num2str(nbPeriodInPast)));

        %Get training data set
        [features] = extractFeatures(strcat(path, datasetNames(i).name), false, nbPeriodInPast);

        %Get CrossValidation set
        dataset = load(strcat(path, datasetNames(i).name));
        [Xval, numberOfCollisionsInPast] = extractFeatures(strcat(path, datasetNames(i).name), true, nbPeriodInPast);

        yval = findYval(dataset.detect, dataset.detect_init, numberOfCollisionsInPast);
        N = dataset.N;
        [score(i, j)] = performTest(features, Xval, yval);
    end
    
end

end

