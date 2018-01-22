%function [features, Xval, Yval, Xtest, yTest] = performAllData(print)
function [lastSuccessTransmissionOneCar, frequencePacketsSuccSent, lastCollisionsFeedback, Xval, yval, N] = performAllData()
% Get the data from all the data sets and print the result

path = 'Data/2017_01_19/';
datasetNames = dir(strcat(path, '*.mat'));

%Get features
lastSuccessTransmissionOneCar = [];
lastCollisionsFeedback = [];
frequencePacketsSuccSent = [];

idCrossDataset = 5;

%Training data set
for i = idCrossDataset : idCrossDataset     %size(datasetNames, 1)
    [lastTransm, freqPcktsSucc, lastCollFeed, numberOfCollisionsInPast] = extractFeatures(strcat(path, datasetNames(i).name), false);
    lastSuccessTransmissionOneCar = [lastSuccessTransmissionOneCar , lastTransm];
    frequencePacketsSuccSent = [frequencePacketsSuccSent , freqPcktsSucc];
    lastCollisionsFeedback = [lastCollisionsFeedback , lastCollFeed];
end

%Transform to Gaussian
[lastSuccessTransmissionOneCar, frequencePacketsSuccSent, lastCollisionsFeedback] = ...
    transformDataToGaussian(lastSuccessTransmissionOneCar, frequencePacketsSuccSent, lastCollisionsFeedback);


%Get CrossValidation set
dataset = load(strcat(path, datasetNames(idCrossDataset).name));
[lastSuccCross, lastFreqCross, lastCollCross] = extractFeatures(strcat(path, datasetNames(idCrossDataset).name), true);

[lastSuccCross, lastFreqCross, lastCollCross] = ...
    transformDataToGaussian(lastSuccCross, lastFreqCross, lastCollCross);

Xval = [lastSuccCross; lastFreqCross; lastCollCross]';
yval = findYval(dataset.detect, dataset.detect_init, numberOfCollisionsInPast);
N = dataset.N;


% if print
%     for i = 1 : size(features, 2)
%         figure();
%         hist(features(:, i) , nbPrint);
%     end
% end
end

