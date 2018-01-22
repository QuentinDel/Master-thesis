%function [features, Xval, Yval, Xtest, yTest] = performAllData(print)
function [pval, mu, sigma2] = performAllData()
% Get the data from all the data sets and print the result

path = 'Data/2017_01_19/';
datasetNames = dir(strcat(path, '*.mat'));

idCrossDataset = 2;

for i = 1 : idCrossDataset     %size(datasetNames, 1)
    
    %Get training data set
    [features, numberOfCollisionsInPast] = extractFeatures(strcat(path, datasetNames(i).name), false);
    
    %Get CrossValidation set
    dataset = load(strcat(path, datasetNames(i).name));
    [Xval] = extractFeatures(strcat(path, datasetNames(i).name), true);
    
    yval = findYval(dataset.detect, dataset.detect_init, numberOfCollisionsInPast);
    N = dataset.N;
    
    [pval, mu, sigma2] = performTest(features, Xval, yval, N);
end

end

