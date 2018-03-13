function [fixeIdInEachCol, idInDifferent, impliedInTheseCol, nbNotTransmis, nbCol, colDict, results] = ...
        removeNbJammed(fixeIdInEachCol, idInDifferent, impliedInTheseCol, nbNotTransmis, nbCol, colDict, nbSureJammed)

    
 idNotTransmit = [fixeIdInEachCol{1:end} idInDifferent];

 allComb = nchoosek(idNotTransmit, 2);
 scoresForTheDifferentComb = zeros(size(allComb, 1), 1);
 for i = 1 : size(allComb, 1)
     key = num2str(allComb(i,:));
     if isKey(colDict, key)
         scoresForTheDifferentComb(i) = colDict(key);
     end
 end

maxScore = inf;
scoreEachId = zeros(1, length(idNotTransmit));
for i = 1 : nbNotTransmis
    idV = idNotTransmit(i);
    score = 0;
    for j = 1 : size(allComb, 1)
       score = score + scoresForTheDifferentComb(j) * ismember(idV, allComb(j, :));
    end
    
    scoreEachId(i) = score;
%     if score < maxScore
%        idCar = idV;
%        [idColl] = findClosestCol(idCar, nbCol, posCol, muEmiss, sigma2Emiss);
%        maxScore = score;
%     end
end
idNotTransmit
scoreEachId

[~, pos] = min(scoreEachId)
[~, index] = sort(scoreEachId)
idNotTransmit(index)

end





% results = zeros(1, nbCol);
% scoresNonJammedCol = zeros(1, nbCol);
% allCombEachCol = cell(1, nbCol);
% for i = 1 : nbCol
%    fixedVehiclesForThisCollision = fixeIdInEachCol{i};
%    idPossible = [];
%    if length(fixedVehiclesForThisCollision) > 1
%         scoresNonJammedCol(i) = inf;
%    else
%    end
%    
%    if ~isempty(impliedInTheseCol)
%        possibleForThis = cellfun(@(x) ismember(i, x{1}), impliedInTheseCol);
%        idPossible = idInDifferent(possibleForThis == 1);
%    end
%    
%    idNotTransmit = [fixedVehiclesForThisCollision, idPossible];
%    
%    if length(idNotTransmit) == 1
%         scoresNonJammedCol = 0;
%    else
%        allComb = nchoosek(idNotTransmit, 2);
%        allCombEachCol{i} = {allComb};
%        scoresForTheDifferentComb = zeros(size(allComb, 1), 1);
%        for j = 1 : size(allComb, 1)
%            key = num2str(allComb(j,:));
%            if isKey(colDict, key)
%                scoresForTheDifferentComb(j) = colDict(key);
%            end
%        end
%        scoresNonJammedCol(i) = sum(scoresForTheDifferentComb);
%    end
%    
%    
%    
% end
% scoresNonJammedCol
% [~, index] = sort(scoresNonJammedCol);
% results(index(1: nbSureJammed)) = 1;
% results

