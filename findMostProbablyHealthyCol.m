function [scoreAllGood, collisions] =  findMostProbablyHealthyCol(collisions, nbCol, colDict)
%Find the best combination of ids implied in each collisions to max the
%score. Work recursively as well. It works only on the first collision of
%the list and with the first of non fixed id.

%MinImplied is the number of ids implied in each collision.
minImplied = cellfun(@(x) length(x.idsImplied), collisions);
scoreAllGood = 1;

%If some of them have less than 2 id implied, they cannot be natural
%(condition of at least 2 vehicles implied in each collision)
if sum(minImplied < 2) ~= 0
     return
end

%Default case
if nbCol == 1
   key = num2str(sort(collisions{1}.idsImplied));
    if isKey(colDict, key)
        scoreAllGood = colDict(key);
    end  
    return
end

%Play only on the first available id
firstToAddIndex = findFirstToAdd(collisions{1});

if ~isempty(firstToAddIndex) %All fix for that collisions -> need to go the next one
    %Add first IdNotTransmit to the first collision of the list ->
    %considered as fix now
    collisionsBis = collisions;
    collisionsBis{1}.nbFix = collisionsBis{1}.nbFix + 1;
    collisionsBis{1}.fixUniqId = [collisionsBis{1}.fixUniqId, collisionsBis{1}.uniqIds(firstToAddIndex)];
    collisionsBis(2:end) = removeUniqId(collisionsBis{1}.uniqIds(firstToAddIndex), collisionsBis(2:end));
    [score1, coll1] = findMostProbablyHealthyCol(collisionsBis, nbCol, colDict);
    
    %Not sure if I have to keep it or not -> normaly not
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
    %collision -> allow for this id to be implied in the next collision
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
            
else %Just go to the next collision, this one is fixed
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
