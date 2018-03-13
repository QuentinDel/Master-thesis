function [structIdNotTransmit, collisions] = getDistances(nbCol, nbNotTransmis, fixeIdInEachCol, posForEachFixedVeh, idInDifferent, impliedInTheseCol)
collisions = cell(nbCol, 1);
structIdNotTransmit = cell(nbCol, 1);
indicIdStruc = 1;
uniqueId = 1;

%Manage id vehicle with fixed implication
for i = 1 : size(fixeIdInEachCol, 2)
   for j = 1 : length(fixeIdInEachCol{i})
      
       %Set unique id
      idStruct.uniqId = uniqueId;
      uniqueId = uniqueId + 1;
      
      %Set idVehicule
      idStruct.id = fixeIdInEachCol{i}(j);
      %fixeIdInEachCol{i}(j) = idStruct.uniqId; %Replace with unique id of the vehicle
        
      %Set distance
      distance = inf * ones(nbCol, 1);
      distance(i) = posForEachFixedVeh{i}(j);
      idStruct.distances = distance;
      
      %Impliqu� dans collisions
      implication = zeros(nbCol, 1);
      implication(i) = 1;
      idStruct.implication = implication;
      
      %Set the structure to the same position as its unique key
      structIdNotTransmit{indicIdStruc} = idStruct;
      indicIdStruc = indicIdStruc + 1;  
   end
end

%Manage id vehicle with multiple implication
for i = 1 : length(idInDifferent)
  %Set unique id
  idStruct.uniqId = uniqueId;
  uniqueId = uniqueId + 1;

  %Set idVehicule
  idStruct.id = fixeIdInEachCol{i}(j);
  
   %Impliqu� dans collisions
  implication = zeros(nbCol, 1);
  implication(impliedInTheseCol{i}{1}) = 1;
  idStruct.implication = implication;
  
  %fixeIdInEachCol{i}(j) = idStruct.uniqId; %Replace with unique id of the vehicle

  %Set distance
  distance = inf * ones(nbCol, 1);
  distance(implication == 1) = impliedInTheseCol{i}{2};
  idStruct.distances = distance;

  %Set the structure to the same position as its unique key
  structIdNotTransmit{indicIdStruc} = idStruct;
  indicIdStruc = indicIdStruc + 1;  
end


for i = 1 : nbCol
   [idImplied, uniqId] = cellfun(@(x) isImplied(x, i), structIdNotTransmit)       
end


end



function [id, uniqId] = isImplied(idNotTransmitStruct, idCol)
    id = [];
    uniqId = [];
    if idStruct.implication(idCol) == 1
        id = idNotTransmitStruct.id;
        uniqId = idNotTransmitStruct.uniqId;    
    end
end