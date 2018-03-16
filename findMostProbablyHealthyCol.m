function [scoreAllGood, collisions] =  findMostProbablyHealthyCol(collisions, nbCol, colDict)

minImplied = cellfun(@(x) length(x.idsImplied), collisions);
scoreAllGood = -1;
% scoresPossibility = -1 * ones(2, 1);
% colllisionsPossiblity = cell(2, 1);

if sum(minImplied < 2) ~= 0
     return
end

if nbCol == 1
   key = num2str(sort(collisions{1}.idsImplied));
    if isKey(colDict, key)
        scoreAllGood = colDict(key);
    end  
    return
end

firstToAddIndex = findFirstToAdd(collisions{1});

%Add first IdNotTransmit to the first collision of the list: 2 sous cas, je
%laisse rajouter dessus ou je ne laisse pas si > 2
if ~isempty(firstToAddIndex) %Ca veut dire qu'ils sont deja tous fix, suffit de passer au suivant
    collisionsBis = collisions;
    collisionsBis{1}.nbFix = collisionsBis{1}.nbFix + 1;
    collisionsBis{1}.fixUniqId = [collisionsBis{1}.fixUniqId, collisionsBis{1}.uniqIds(firstToAddIndex)];
    collisionsBis(2:end) = removeUniqId(collisionsBis{1}.uniqIds(firstToAddIndex), collisionsBis(2:end));
    [score1, coll1] = findMostProbablyHealthyCol(collisionsBis, nbCol, colDict);
    
%     %Cas ou on laisse plus rajouter dessus
%     if collisions{1}.nbFix >= 2
%         key = num2str(sort(collisions{1}.idsImplied(ismember(collisions{1}.uniqIds, collisions{1}.fixUniqId))));
%         if isKey(colDict, key)
%             scoresPossibilities2 = colDict(key);
%             [scoreSec, colllisionsAllPossiblities2] = findMostProbablyHealthyCol(collisions(2 : end), nbCol, colDict);
%             scoresPossibility(2) = [collisions(1) ; colllisionsAllPossiblities2]
%             scoresPossibility(2) = addScore(scoresPossibility(2), scoreSec);
%         end        
%     end
        
    %Do nothing if possible, delete the possibility of the first id in this
    %collision
    score2 = -1;
    if minImplied(1) > 2 && ismember(collisions{1}.uniqIds(firstToAddIndex), collisions{2}.uniqIds)
        collisionsBis2 = collisions;
        collisionsBis2{1}.uniqIds(firstToAddIndex) = [];
        collisionsBis2{1}.idsImplied(firstToAddIndex) = [];       
        [score2, coll2] = findMostProbablyHealthyCol(collisionsBis2, nbCol, colDict);
    end 
    
    if score1 ~= -1 || score2 ~= -1
       if score1 > score2
           scoreAllGood = score1;
           collisions = coll1;
       else
           scoreAllGood = score2;
           collisions = coll2;
       end        
    end
            
else %Il a au moins 2 impliqu�s au vu du premier check, donc juste calcule le score
   key = num2str(sort(collisions{1}.idsImplied));
    if isKey(colDict, key)
        scoreAllGood = colDict(key);
        [scoreSec, collisionsSec] = findMostProbablyHealthyCol(collisions(2:end), nbCol-1, colDict);
        scoreAllGood = addScore(scoreAllGood, scoreSec);
        collisions = [collisions(1) ; collisionsSec];
    end
end

end


function scoreAllGood = addScore(scoreAllGood, scoreSec)
    if scoreSec == -1
        scoreAllGood = -1;
        return
    end
    scoreAllGood = scoreAllGood + scoreSec;
end


function firstToAddIndex = findFirstToAdd(collision)
    idPossibleToAdd = collision.uniqIds;
    idPossibleToAdd(ismember(idPossibleToAdd, collision.fixUniqId)) = -1;
    firstToAddIndex = find(idPossibleToAdd ~= -1, 1);
end
