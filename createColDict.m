function [colDict, colDictCollideWith, muEmiss, sigma2Emiss, frequencyCol, periods] = createColDict(path, idDataSet)
%CREATECOLDICT 

%Take the different name possible and load the selected one
[periodsInfo, transmissionsInfos, collisionsInfos, lastViewCollInfos, N, periods] = extractPeriods(path, idDataSet);



%Create the containers for the different features
colDict = containers.Map('KeyType','char','ValueType','int32');
colDictCollideWith = cell(N, 1);

emissionsVehicles = cell(N, 1);
frequencyCol = zeros(N, 1);

%Go through all the periods
for i = 1 : size(periodsInfo, 2)   
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
        idNotTransmit = periodsInfo{i};
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




