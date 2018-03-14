function collisions = findStructImplied(nbCol, collisions, structIdNotTransmit)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%Get info for the collisions
for i = 1 : nbCol
   [idImplied, uniqId] = cellfun(@(x) isImplied(x, i), structIdNotTransmit, 'UniformOutput', false);
   collisions{i}.idsImplied = cell2mat(idImplied');
   collisions{i}.uniqIds =  cell2mat(uniqId');
end

end



function [id, uniqId] = isImplied(idNotTransmitStruct, idCol)
    id = [];
    uniqId = [];
    if idNotTransmitStruct.implication(idCol) == 1
        id = idNotTransmitStruct.id;
        uniqId = idNotTransmitStruct.uniqId;    
    end
end
