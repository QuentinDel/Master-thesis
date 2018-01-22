%function [features, Xval, Yval, Xtest, yTest] = performAllData(print)
function [pval, mu, sigma2] = performAllData()
% Get the data from all the data sets and print the result

path = 'Data/2017_01_19/';
datasetNames = dir(strcat(path, '*.mat'));

idCrossDataset = 5;

%Training data set
for i = 1 : idCrossDataset     %size(datasetNames, 1)
    [lastSuccessTransmissionOneCar, frequencePacketsSuccSent, lastCollisionsFeedback, numberOfCollisionsInPast] = extractFeatures(strcat(path, datasetNames(i).name), false);
    
    %Transform to Gaussian
    [lastSuccessTransmissionOneCar, frequencePacketsSuccSent, lastCollisionsFeedback] = ...
        transformDataToGaussian(lastSuccessTransmissionOneCar, frequencePacketsSuccSent, lastCollisionsFeedback);


    %Get CrossValidation set
    dataset = load(strcat(path, datasetNames(i).name));
    [lastSuccCross, lastFreqCross, lastCollCross] = extractFeatures(strcat(path, datasetNames(i).name), true);

    [lastSuccCross, lastFreqCross, lastCollCross] = ...
        transformDataToGaussian(lastSuccCross, lastFreqCross, lastCollCross);

    Xval = [lastSuccCross; lastFreqCross; lastCollCross]';
    yval = findYval(dataset.detect, dataset.detect_init, numberOfCollisionsInPast);
    N = dataset.N;
    
    [pval, mu, sigma2] = performTest(lastSuccessTransmissionOneCar, frequencePacketsSuccSent, lastCollisionsFeedback, Xval, yval, N);

end

end

