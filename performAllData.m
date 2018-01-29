%function [features, Xval] = performAllData()
%function [pval, mu, sigma2, features] = performAllData()
%function 
%Score
% Get the data from all the data sets and print the result

path = 'Data/2017_01_19/';
datasetNames = dir(strcat(path, '*.mat'));

idCrossDataset = 1;

toExploreNbPeriodInPast = 10;
%toExploreNbPeriodInPast = 10;

cuttedNumber = zeros(idCrossDataset, length(toExploreNbPeriodInPast));
score = zeros(idCrossDataset, length(toExploreNbPeriodInPast));

for i = idCrossDataset : idCrossDataset     %size(datasetNames, 1)
    disp(strcat('Train with dataset: ', num2str(i)));
    
    for j  = 1 : length(toExploreNbPeriodInPast)
        nbPeriodInPast = toExploreNbPeriodInPast(j);
        disp(strcat('Train with nb periods in past:  ', num2str(nbPeriodInPast)));

        %Get training data set
        [features] = extractFeatures(strcat(path, datasetNames(i).name), false, nbPeriodInPast);

        %Get CrossValidation set
        dataset = load(strcat(path, datasetNames(i).name));
        [Xval, numberOfCollisionsInPast] = extractFeatures(strcat(path, datasetNames(i).name), true, nbPeriodInPast);
        cuttedNumber(i, j) = numberOfCollisionsInPast;
        disp(strcat('Cutted number of collisions: ', num2str(numberOfCollisionsInPast)));

        yval = findYval(dataset.detect, dataset.detect_init, numberOfCollisionsInPast);
        N = dataset.N;
        %[score(i, j)] = performTest(features, Xval, yval);
        performTest
    end
    
end

%end

