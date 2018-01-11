%function [features, Xval, Yval, Xtest, yTest] = performAllData(print)
function [lastSuccessTransmissionOneCar, lastCollisionsFeedback, frequencePacketsSuccSent, ...
    Xval, yval] = performAllData(print)
% Get the data from all the data sets and print the result

%datasetNames = ['sek100_1.mat' ; 'sek100_2.mat'; 'sek150_1.mat'];%'sek100_1.mat' ; 'sek100_2.mat'; 'sek150_1.mat'];
datasetNames = ['firstVariable.mat'];
nbDatasets = size(datasetNames,1);
results = cell(nbDatasets, 3);
nbColl = 0;

%Get features
lastSuccessTransmissionOneCar = [];
lastCollisionsFeedback = [];
frequencePacketsSuccSent = [];

%Training data set
for i = 1 : nbDatasets
    [results{i, 1}, results{i, 2}, results{i, 3}, nbCollEff] = extractFeatures(datasetNames(i, :), true);
    nbColl = nbColl + nbCollEff;
    lastSuccessTransmissionOneCar = [lastSuccessTransmissionOneCar ; results{i,1}];
    lastCollisionsFeedback = [lastCollisionsFeedback ; results{i, 2}];
    frequencePacketsSuccSent = [frequencePacketsSuccSent ; results{i, 3}];
end

%For the dataset, we vectorize this to have one normal car "comportement"
lastSuccessTransmissionOneCar = log(lastSuccessTransmissionOneCar(:));
lastCollisionsFeedback = log(lastCollisionsFeedback);
frequencePacketsSuccSent = frequencePacketsSuccSent(:);

%Get CrossValidation set
dataset = load(datasetNames(1, :));
[lastSuccCross, lastCollCross, lastFreqCross] = extractFeatures(datasetNames(1, :), false);
lastSuccCross = log(lastSuccCross);
lastCollCross = log(lastCollCross);
lastFreqCross = log(lastFreqCross);
Xval = [lastSuccCross ; lastFreqCross ; lastCollCross];
%Xval = buildGaussian([lastSuccCross', lastCollCross', lastFreqCross']);
yval = findYval(dataset.detect, dataset.detect_init);

%Get Test set
% dataset = load(datasetNames(2, :));
% [~, tc1val, tc3val, tc5val, ~, lastTval] = extractFeatures(datasetNames(2, :), false);
% Xtest = buildGaussian([tc1val, tc3val, tc5val, lastTval]);
%yTest = findYval(dataset.detect, dataset.detect_init);
%Xtest = Xval;
%yTest = Yval;

%nbPrint = 50;
%features = buildGaussian([timeCollision1, timeCollision3, timeCollision5, lastSuccessTransmission]);
%features = [timeCollision1, timeCollision3, timeCollision5, lastSuccessTransmission];

% if print
%     for i = 1 : size(features, 2)
%         figure();
%         hist(features(:, i) , nbPrint);
%     end
% end
end

