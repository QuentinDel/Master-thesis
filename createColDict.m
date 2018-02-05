function [ colDict, nbCol ] = createColDict(idDataSet)
%CREATECOLDICT Summary of this function goes here
%   Detailed explanation goes here

path = 'Data/2017_01_19/';
datasetNames = dir(strcat(path, '*.mat'));

data = load(strcat(path, datasetNames(idDataSet).name)); 
n = length(data.detect);
slotTime = data.seconds / n;
f = 1 / data.beaconing_period;
periodSlot = round(1 / (f * slotTime));
   
training_part = round(length(data.detect)*(3/4));
training_part = training_part + periodSlot - mod(training_part, periodSlot);


dataset = data.detect_init(1 : training_part);
periods = reshape(dataset, periodSlot, training_part / periodSlot);

colDict = containers.Map('KeyType','char','ValueType','int32');

for i = 1 : size(periods, 2)    
      period = periods(:, i); 
      nbCol = sum(period == -1)/40;
      
      if nbCol ~= 0
        [idNotTransmit, nbNotTransmis] = findWhoNotTransmit(data.N, period);
        
        for j = 1 : nbNotTransmis + 1 - 2 * nbCol 
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

%end



