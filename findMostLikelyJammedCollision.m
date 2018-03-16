function [idColl, uniqIdVeh, index, score] = findMostLikelyJammedCollision(nbCol, nbNotTransmis, idNotTransmitStruct, collisions, colDict, muEmiss, sigma2Emiss)
score = -1;
scores = zeros(1, nbNotTransmis);

%go through each veh struct
for i = 1 : nbNotTransmis
    impliedWith = findImpliedWith(idNotTransmitStruct{i}, idNotTransmitStruct, collisions);
    %If no impliedWith -> isJammed
    if isempty(impliedWith)
        index = i;
        uniqIdVeh = idNotTransmitStruct{i}.uniqId;
        [idColl] = findClosestCol(idNotTransmitStruct{i}.id, nbCol, idNotTransmitStruct{i}.distances, muEmiss, sigma2Emiss, collisions);
        return
    end
    %If not sum score
    for j = 1 : length(impliedWith)
        key = num2str(sort([idNotTransmitStruct{i}.id, impliedWith(j)]));
        if isKey(colDict, key)
            scores(i) = scores(i) + colDict(key);
        end
    end 
end

% [~, index] = sort(scores(:));
% %Check if the id can be removed
% for i = 1 : nbNotTransmis
%     uniqIdVeh = idNotTransmitStruct{index(i)}.uniqId;
%    [idColl, findNextOne] = findClosestCol(idNotTransmitStruct{index(i)}.id, nbCol, idNotTransmitStruct{index(i)}.distances, muEmiss, sigma2Emiss, collisions); 
%    if ~findNextOne
%        score = 10;
%        break
%    end
% end

[~, ind] = sort(scores(:));
for i = 1 : nbNotTransmis
   index = ind(i);
   uniqIdVeh = idNotTransmitStruct{index}.uniqId;
   [idColl, findNextOne] = findClosestCol(idNotTransmitStruct{index}.id, nbCol, idNotTransmitStruct{index}.distances, muEmiss, sigma2Emiss, collisions); 
   if ~findNextOne
       score = 10;
       break
   end
end

end

function impliedWith = findImpliedWith(idStruct, idNotTransmitStruct, collisions)
    colImplied = find(idStruct.implication == 1);
    impliedWith = cellfun(@(x) x.idsImplied, collisions(colImplied), 'UniformOutput', false);
    impliedWith = unique(cell2mat(impliedWith'));
    impliedWith(impliedWith == idStruct.id) = [];
end

function [idColl, findNextOne] = findClosestCol(idVeh, nbCol, posCol, muEmiss, sigma2Emiss,collisions)
    probMax = -1;
    idColl = 1;
    findNextOne = false;
    for i = 1 : nbCol
       prob = -1;
       if posCol(i) ~= inf && collisions{i}.nbFix < 2
         prob = multivariateGaussian(posCol(i), muEmiss(idVeh), sigma2Emiss(idVeh));
       end
       if prob > probMax
%            if probMax ~= 0 && (abs(prob - probMax))/abs(prob + probMax) < 0.01
%               %fprintf('Difficult to determine which is the bad one\n'); 
%            end
           probMax = prob;
           idColl = i;
       end 
    end
    
    if probMax == -1
       findNextOne = true;    
    end
    
end