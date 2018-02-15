function [colDict, colDictCollideWith, muEmiss, sigma2Emiss, frequencyCol, cut, periods] = createColDict(idDataSet)
%CREATECOLDICT 

%Take the different name possible and load the selected one
path = 'Data/2017_01_19/';
datasetNames = dir(strcat(path, '*.mat'));
data = load(strcat(path, datasetNames(idDataSet).name));
maxW = 15;
k = 2;
cut = find(data.detect_init > 0, 1) - maxW * k;

if cut < 1
   cut = 1;
end

data.detect_init = data.detect_init(cut:end);

%Obtain the length of a period in slots
n = length(data.detect_init);
slotTime = data.seconds / n;
f = 1 / data.beaconing_period;
periodSlot = round(1 / (f * slotTime));

%Obtain the training part as a multiple of the period
training_part = round(length(data.detect_init)*(3/4));
training_part = training_part + periodSlot - mod(training_part, periodSlot);

%Cut the dataset to obtain only the training part
dataset = data.detect_init(1 : training_part);
periods = reshape(dataset, periodSlot, training_part / periodSlot);

%Create the containers for the different features
colDict = containers.Map('KeyType','char','ValueType','int32');
colDictCollideWith = cell(data.N, 1);

emissionsVehicles = cell(data.N, 1);
frequencyCol = zeros(data.N, 1);

%Go through all the periods
for i = 1 : size(periods, 2)    
      period = periods(:, i);
      
      %Get number and positions of all the collisions
      colPos = indicePositions(period', -1);
      nbCol = sum(colPos > 0);
      
      %Obtain time when vehicles emit beacon
      for j = 1 : data.N
          pos = find(period == j, 1); 
          if ~isempty(pos)
              if isempty(emissionsVehicles{j})
                emissionsVehicles{j} = {pos};
              else
                emissionsVehicles{j}{end + 1} = pos ;
              end
          end          
      end
      
      %Case of collisions happened
      if nbCol ~= 0
        [idNotTransmit, nbNotTransmis] = findWhoNotTransmit(data.N, period);
        frequencyCol(nbCol) = frequencyCol(nbCol) + 1;
            
        %Otherwise we check for all possible collisions
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

[muEmiss, sigma2Emiss] = estimateGaussian(emissionsVehicles);
[ colDict ] = filterDictionary(colDict, muEmiss, sigma2Emiss, periodSlot);



frequencyCol = frequencyCol / sum(frequencyCol);
groupCollision = keys(colDict);

for i = 1 : data.N
    results = cellfun(@(x) getAllCollideWith(x, i), groupCollision, 'UniformOutput', false);
    colDictCollideWith{i} = cell2mat(results);
end
    
end

function result = getAllCollideWith(x, id)
    result = [];
    xNum = str2num(x);
    if ismember(id, xNum)
       result = xNum;
       result(result == id) = [];
    end
end




