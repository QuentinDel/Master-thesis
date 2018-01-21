%function [features, Xval, Yval, Xtest, yTest] = performAllData(print)
function [lastSuccessTransmissionOneCar, lastCollisionsFeedback, frequencePacketsSuccSent, ...
    Xval, yval] = performAllData()
% Get the data from all the data sets and print the result

path = 'Data/2017_01_19/';
datasetNames = dir(strcat(path, '*.mat'));

%Get features
lastSuccessTransmissionOneCar = [];
lastCollisionsFeedback = [];
frequencePacketsSuccSent = [];

%Training data set
for i = 1 : size(datasetNames, 1)
    [lastTransm, lastCollFeed, freqPcktsSucc] = extractFeatures(strcat(path, datasetNames(i).name), false);
    lastSuccessTransmissionOneCar = [lastSuccessTransmissionOneCar ; lastTransm];
    lastCollisionsFeedback = [lastCollisionsFeedback ; lastCollFeed];
    frequencePacketsSuccSent = [frequencePacketsSuccSent ; freqPcktsSucc];
end

%For the dataset, we vectorize this to have one normal car "comportement"
lastSuccessTransmissionOneCar = log(lastSuccessTransmissionOneCar(:));
%lastCollisionsFeedback = log((lastCollisionsFeedback * 5) .^ 2);
frequencePacketsSuccSent = frequencePacketsSuccSent(:).^2;
lastCollisionsFeedback = lastCollisionsFeedback;


%Get CrossValidation set
dataset = load(datasetNames(1, :));
[lastSuccCross, lastCollCross, lastFreqCross] = extractFeatures(datasetNames(1, :), false);
lastSuccCross = log(lastSuccCross);
lastCollCross =  log(lastCollCross .^ 2);
lastFreqCross = lastFreqCross .^2;
Xval = [lastSuccCross; lastFreqCross; lastCollCross]';
%Xval = buildGaussian([lastSuccCross', lastCollCross', lastFreqCross']);
yval = findYval(dataset.detect);

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

