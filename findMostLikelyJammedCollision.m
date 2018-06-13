function [idColl, uniqIdVeh, index, score] = findMostLikelyJammedCollision(nbCol, nbNotTransmis, idNotTransmitStruct, collisions, colDict, muEmiss, sigma2Emiss, scoreForJam)
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

%Get the smallest scores. May happend that the id not transmit is in one
%natural collision for sure (nbfix > 2), in that case we need to take the
%second lowest,... etc
[~, ind] = sort(scores(:));
for i = 1 : nbNotTransmis
   index = ind(i);
   uniqIdVeh = idNotTransmitStruct{index}.uniqId;
   [idColl, findNextOne] = findClosestCol(idNotTransmitStruct{index}.id, nbCol, idNotTransmitStruct{index}.distances, muEmiss, sigma2Emiss, collisions); 
   if ~findNextOne
       %This score is a hyperparameter!
       score = scoreForJam;
       break
   end
end

end

%Find implied with an id 
function impliedWith = findImpliedWith(idStruct, idNotTransmitStruct, collisions)
    colImplied = find(idStruct.implication == 1);
    impliedWith = cellfun(@(x) x.idsImplied, collisions(colImplied), 'UniformOutput', false);
    impliedWith = unique(cell2mat(impliedWith'));
    impliedWith(impliedWith == idStruct.id) = [];
end

function beta = getBeta(idVeh1, idVeh2, posCol, muEmiss, sigma2Emiss)
    dist1 = abs(posCol(1) - muEmiss(idVeh1)); 
    dist2 = abs(posCol(2) - muEmiss(idVeh2));
    beta = (dist1 + dist2)/(sigma2Emiss(idVeh1) + sigma2Emiss(idVeh2));
end


%Check for the most likely collision for the id of the vehicle
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
           probMax = prob;
           idColl = i;
       end 
    end
    
    if probMax == -1
       findNextOne = true;    
    end
    
end