function [idColl, uniqIdVeh, index, score, sdc] = findMostLikelyJammedCollision(nbCol, nbNotTransmis, idNotTransmitStruct, collisions, colDict, muEmiss, sigma2Emiss, scoreForJam, sdc)
score = -1;
scores = zeros(1, nbNotTransmis);
prevScores = zeros(1, nbNotTransmis);

%Info getJammed
infoChosenJammedCollision = struct;
infoChosenJammedCollision.orderVehicle = cellfun(@(x) x.id, idNotTransmitStruct);

%go through each veh struct
for i = 1 : nbNotTransmis
    [impliedWith, impliedWithUnique] = findImpliedWith(idNotTransmitStruct{i}, idNotTransmitStruct, collisions);
    %If no impliedWith -> isJammed
    if isempty(impliedWith)
        index = i;
        uniqIdVeh = idNotTransmitStruct{i}.uniqId;
        [idColl] = findClosestCol(idNotTransmitStruct{i}.id, nbCol, idNotTransmitStruct{i}.distances, muEmiss, sigma2Emiss, collisions);
        return
    end
    %If not sum score
    %betas = zeros(1, length(impliedWith));
    for j = 1 : length(impliedWith)
        key = num2str(sort([idNotTransmitStruct{i}.id, impliedWith(j)]));
        if isKey(colDict, key)
            prevScores(i) = scores(i) + colDict(key);
            scores(i) = scores(i) + colDict(key);

            %betas(i) = getBeta(idNotTransmitStruct{i}.id, impliedWith(j), idNotTransmitStruct{i}.distances, idNotTransmitStruct{findIndex(idNotTransmitStruct, impliedWithUnique(j))}.distances, muEmiss, sigma2Emiss);
            %scores(i) = scores(i) + colDict(key) / getBeta(idNotTransmitStruct{i}.id, impliedWith(j), idNotTransmitStruct{i}.distances, idNotTransmitStruct{findIndex(idNotTransmitStruct, impliedWithUnique(j))}.distances, muEmiss, sigma2Emiss);
        end
    end 
end

%Get the smallest scores. May happend that the id not transmit is in one
%natural collision for sure (nbfix > 2), in that case we need to take the
%second lowest,... etc
%scores
%PrevScores
%betas
%scores
infoChosenJammedCollision.betaScores = scores;
infoChosenJammedCollision.normalScores = prevScores;

[~, ind] = sort(scores(:));
for i = 1 : nbNotTransmis
   index = ind(i);
   uniqIdVeh = idNotTransmitStruct{index}.uniqId;
   [idColl, findNextOne] = findClosestCol(idNotTransmitStruct{index}.id, nbCol, idNotTransmitStruct{index}.distances, muEmiss, sigma2Emiss, collisions); 
   if ~findNextOne
       %This score is a hyperparameter!
       score = scoreForJam;
       infoChosenJammedCollision.idColl = idColl;
       infoChosenJammedCollision.vehJam = idNotTransmitStruct{index}.id;
       break
   end
end
sdc.infoJC{end + 1} = infoChosenJammedCollision;
end

%Find implied with an id 
function [impliedWith, impliedWithUnique] = findImpliedWith(idStruct, idNotTransmitStruct, collisions)
    colImplied = find(idStruct.implication == 1);
    impliedWith = cellfun(@(x) x.idsImplied, collisions(colImplied), 'UniformOutput', false);
    impliedWithUnique = cellfun(@(x) x.uniqIds, collisions(colImplied), 'UniformOutput', false);
    impliedWith = unique(cell2mat(impliedWith'));
    impliedWithUnique = unique(cell2mat(impliedWithUnique'));
    impliedWith(impliedWith == idStruct.id) = [];
    impliedWithUnique(impliedWithUnique == idStruct.uniqId) = [];

end

function beta = getBeta(idVeh1, idVeh2, distances1, distances2, muEmiss, sigma2Emiss)
    dist1 = abs(distances1 - muEmiss(idVeh1));
    dist2 = abs(distances2 - muEmiss(idVeh2));
    minDist = min(dist1 + dist2);
    beta = (minDist)/(3*sigma2Emiss(idVeh1)^0.5 + 3*sigma2Emiss(idVeh2)^0.5);
    if beta == inf
        fprintf('\nbeta inf\n');
    end
end


function index = findIndex(idNotTransmitStruct, uniqId)
    index = cellfun(@(x) x.uniqId == uniqId, idNotTransmitStruct);
    index = find(index == 1);
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