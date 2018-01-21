%function [features, Xval, Yval, Xtest, yTest] = performAllData(print)
function [lastSuccessTransmissionOneCar, lastCollisionsFeedback, frequencePacketsSuccSent, Xval, yval, N] = performAllData()
% Get the data from all the data sets and print the result

path = 'Data/2017_01_19/';
datasetNames = dir(strcat(path, '*.mat'));

%Get features
lastSuccessTransmissionOneCar = [];
lastCollisionsFeedback = [];
frequencePacketsSuccSent = [];

%Training data set
for i = 1 : 1%size(datasetNames, 1)
    [lastTransm, lastCollFeed, freqPcktsSucc, numberOfCollisionsInPast] = extractFeatures(strcat(path, datasetNames(i).name), false);
    lastSuccessTransmissionOneCar = [lastSuccessTransmissionOneCar , lastTransm];
    lastCollisionsFeedback = [lastCollisionsFeedback , lastCollFeed];
    frequencePacketsSuccSent = [frequencePacketsSuccSent , freqPcktsSucc];
end

%Transform to Gaussian
[lastSuccessTransmissionOneCar, frequencePacketsSuccSent, lastCollisionsFeedback] = ...
    transformDataToGaussian(lastSuccessTransmissionOneCar(:), frequencePacketsSuccSent(:), lastCollisionsFeedback);


%Get CrossValidation set
idCrossDataset = 1;
dataset = load(strcat(path, datasetNames(idCrossDataset).name));
[lastSuccCross, lastCollCross, lastFreqCross] = extractFeatures(strcat(path, datasetNames(idCrossDataset).name), true);
[lastSuccCross, lastFreqCross, lastCollCross] = ...
    transformDataToGaussian(lastSuccCross, lastFreqCross, lastCollCross);

Xval = [lastSuccCross; lastFreqCross; lastCollCross]';
yval = findYval(dataset.detect, dataset.detect_init, numberOfCollisionsInPast);
N = dataset.N;

%Get Test set
% dataset = load(datasetNames(2, :));
% [~, tc1val, tc3val, tc5val, ~, lastTval] = extractFeatures(datasetNames(2, :), false);
% Xtest = buildGaussian([tc1val, tc3val, tc5val, lastTval]);
%yTest = findYval(dataset.detect, dataset.detect_init);
%Xtest = Xval;
%yTest = Yval;

% if print
%     for i = 1 : size(features, 2)
%         figure();
%         hist(features(:, i) , nbPrint);
%     end
% end
end

