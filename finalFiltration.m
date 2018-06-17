function [results, score, sdc] = finalFiltration(nbCol, nbNotTransmis, idNotTransmitStruct, collisions, colDict, muEmiss, sigma2Emiss, scoreForJam, sdc)
%Recursive algorithm

%Case 1: default case, only one collision left, must be natural!
if nbCol == 1
    results = 0;
    score = -1;
    key = num2str(collisions{1}.idsImplied);
    if isKey(colDict, key)
       score = colDict(key); 
    end
%Case 2: It is sure that there are still some jammed collisions
elseif nbCol * 2 > nbNotTransmis
   [results, score, sdc] = findWithOneBad(nbCol, nbNotTransmis, idNotTransmitStruct, collisions, colDict, muEmiss, sigma2Emiss, scoreForJam, sdc);
%Case 3: Not sure if still jammed ones or not, check both case and assign a
%       score!
else 
    
%      [resultsWithJam, scoreJam] = findWithOneBad(nbCol, nbNotTransmis, idNotTransmitStruct, collisions, colDict, muEmiss, sigma2Emiss, scoreForJam, sdc);
%      results = resultsWithJam;
%      score = scoreJam;
%      [scoreAllGood, collisionsGood] =  findMostProbablyHealthyCol(collisions, nbCol, colDict);     
%      resultsAllGood = zeros(nbCol, 1);
%  
%      if scoreJam < scoreAllGood
%         results = resultsAllGood;
%         score = scoreAllGood;
%      end
     results = zeros(nbCol, 1);
     score = 0;
 end

end

%Find one jammed collision and vehicle, remove them from the data and keep
%processing by calling this function on the rest.
function [results, score, sdc] = findWithOneBad(nbCol, nbNotTransmis, idNotTransmitStruct, collisions, colDict, muEmiss, sigma2Emiss, scoreForJam, sdc)
   results = zeros(1, nbCol);
   [idColl, uniqIdVeh, index, score, sdc] = findMostLikelyJammedCollision(nbCol, nbNotTransmis, idNotTransmitStruct, collisions, colDict, muEmiss, sigma2Emiss, scoreForJam, sdc); 
   results(idColl) = 1;
   collisionsBis = collisions;
   collisionsBis(idColl) = [];
   
   idNotTransmitStructBis = idNotTransmitStruct;
   idNotTransmitStructBis(index) = [];
   idNotTransmitStructBis = removeColl(idColl, idNotTransmitStructBis);
   %collisionsBis = removeUniqId(uniqIdVeh, collisionsBis);
      
   collisionsBis = findStructImplied(nbCol-1, collisionsBis, idNotTransmitStructBis);
    
   [resultsBis, scoreB, sdc] = finalFiltration(nbCol-1, nbNotTransmis-1, idNotTransmitStructBis, collisionsBis, colDict, muEmiss, sigma2Emiss, scoreForJam, sdc);
   score = score * (scoreB > -1) + scoreB * double((score > -1));
   results(results == 0) = resultsBis;

end

%Use to remove data of the jammed vehicles.
function idNotTransmitStructBis = removeColl(idColl, idNotTransmitStructBis)
    for i = 1 : size(idNotTransmitStructBis, 1)
        idNotTransmitStructBis{i}.distances(idColl) = [];
        idNotTransmitStructBis{i}.implication(idColl) = [];             
    end
    
end
