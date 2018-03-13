function [idColl, uniqIdVeh] = findMostLikelyJammedCollision(nbCol, nbNotTransmis, idNotTransmitStruct, collisions, colDict, muEmiss, sigma2Emiss)

scores = zeros(1, nbNotTransmis);

for i = 1 : nbNotTransmis
    impliedWith = findImpliedWith(idNotTransmitStruct{i}, idNotTransmitStruct, collisions);
    %If no impliedWith -> isJammed
    if isempty(impliedWith)
        uniqIdVeh = idNotTransmitStruct{i}.uniqId;
        [idColl] = findClosestCol(idNotTransmitStruct{i}.id, nbCol, idNotTransmitStruct{i}.distances, muEmiss, sigma2Emiss);
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

[~, uniqIdVeh] = min(scores(:));
[idColl] = findClosestCol(idNotTransmitStruct{uniqIdVeh}.id, nbCol, idNotTransmitStruct{uniqIdVeh}.distances, muEmiss, sigma2Emiss);


end

function impliedWith = findImpliedWith(idStruct, idNotTransmitStruct, collisions)
    colImplied = find(idStruct.implication == 1);
    impliedWith = cellfun(@(x) x.idsImplied, collisions(colImplied), 'UniformOutput', false);
    impliedWith = unique(cell2mat(impliedWith'));
    impliedWith(impliedWith == idStruct.id) = [];
%     for i = 1 : length(colImplied)
%         impliedWith = [idImplied, ];
%     end
end

function [idColl] = findClosestCol(idVeh, nbCol, posCol, muEmiss, sigma2Emiss)
    probMax = 0;
    idColl = 1;
    for i = 1 : nbCol
       prob = -1;
       if posCol(i) ~= inf
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
    
%     if probMax == 0
%        %fprintf('Impossible to find a correct position for this configuration of vehicles\n'); 
%     end
end