function [colDict, muEmiss, sigma2Emiss, intervTransmiss, periods, periodIdNotTransmit] = createColDict(data)
% Input:
%   -data: dataset containing the training part
% Output:
%   -colDict: the dictionary
%   -muEmiss: Means of the first slot for the beacon transmission of the different vehicles  
%   -sigma2Emiss: standard deviation for the beacon transmission of the different vehicles  
%   -intervTransmiss: Interval of slots for each vehicles where it can
%                       transmit
%   -periods: the dataset shaped into period
%   -periodIdNotTransmit: Which vehicles did not transmit in each period

%Take the different name possible and load the selected one
[periodIdNotTransmit, transmissionsInfos, training_part, periodSlot, periods] = extractPeriods(data, false);

%Create the dictionary
colDict = containers.Map('KeyType','char','ValueType','int32');

%Use only the training part
dataset = data.detect(1:training_part);

%Estimate gaussian and intervals
[muEmiss, sigma2Emiss] = estimateGaussian(transmissionsInfos, data.N);
intervTransmiss = estimateInterv(data.N, periodSlot, muEmiss, sigma2Emiss);
%printGaussian(periodSlot, muEmiss, sigma2Emiss, intervTransmiss);

posCol = indicePositions(dataset, -1);
nbCol = length(posCol);

%Compute for each collision the ids implied. For the all combinations
%possible add in the dictionary.
for i = 1 : nbCol-1
    pos = posCol(i);
    periodImplied = (pos - mod(pos,periodSlot)) / periodSlot + 1;
    [idNotTransmit, pos] = getAllPossibColl(periodIdNotTransmit, periodImplied, pos, periodSlot, intervTransmiss);
    
    if length(idNotTransmit) < 2
        fprintf('\nJammed detected in healthy dataset: %d %s\n', i, num2str(periodImplied)); 
    end

    for j = 1 : length(idNotTransmit) + 1 - 2 
        allComb = nchoosek(idNotTransmit, j + 1);

        for k = 1 : size(allComb, 1);
           key = num2str(sort(allComb(k, :)));
           if isKey(colDict, key)
              colDict(key) = colDict(key) + 1;
           else
              colDict(key) = 1;
           end                
        end
    end
end
end
    

