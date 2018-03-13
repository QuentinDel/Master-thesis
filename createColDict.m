function [colDict, colDictCollideWith, muEmiss, sigma2Emiss, intervTransmiss, periods, periodIdNotTransmit] = createColDict(data)
%CREATECOLDICT 

%Take the different name possible and load the selected one
[periodIdNotTransmit, transmissionsInfos, training_part, periodSlot, periods] = extractPeriods(data, false);

%Create the containers for the different features
colDict = containers.Map('KeyType','char','ValueType','int32');
colDictCollideWith = cell(data.N, 1);

dataset = data.detect(1:training_part);
%n = length(dataset);

[muEmiss, sigma2Emiss] = estimateGaussian(transmissionsInfos, data.N);
intervTransmiss = estimateInterv(data.N, periodSlot, muEmiss, sigma2Emiss);
printGaussian(periodSlot, muEmiss, sigma2Emiss, intervTransmiss);

posCol = indicePositions(dataset, -1);
nbCol = length(posCol);

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
           key = num2str(allComb(k, :));
           if isKey(colDict, key)
              colDict(key) = colDict(key) + 1;
           else
              colDict(key) = 1;
           end                
        end
    end
end
end
    

