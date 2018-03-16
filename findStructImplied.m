function collisions = findStructImplied(nbCol, collisions, structIdNotTransmit)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%Get info for the collisions
for i = 1 : nbCol
   [idImplied, uniqId, fixId] = cellfun(@(x) isImplied(x, i), structIdNotTransmit, 'UniformOutput', false);
   collisions{i}.idsImplied = cell2mat(idImplied');
   collisions{i}.uniqIds =  cell2mat(uniqId');
   collisions{i}.fixUniqId = cell2mat(fixId');
   collisions{i}.nbFix = length(collisions{i}.fixUniqId);
end

end



function [id, uniqId, isFixed] = isImplied(idNotTransmitStruct, idCol)
    id = [];
    uniqId = [];
    isFixed = [];
    if idNotTransmitStruct.implication(idCol) == 1
        id = idNotTransmitStruct.id;
        uniqId = idNotTransmitStruct.uniqId;    
        if sum(idNotTransmitStruct.implication) == 1
           isFixed = idNotTransmitStruct.uniqId;
        end
    end
end
