function [results, score] = finalFiltration(nbCol, nbNotTransmis, idNotTransmitStruct, collisions, colDict, muEmiss, sigma2Emiss)

if nbCol == 1
    results = 0;
    score = -1;
    key = num2str(collisions{1}.idsImplied);
    if isKey(colDict, key)
       score = colDict(key); % * multivariateGaussian(posMat, muEmiss(idNotTransmit), sigma2Emiss(idNotTransmit));
    end
elseif nbCol * 2 > nbNotTransmis
   [results, score] = findWithOneBad(nbCol, nbNotTransmis, idNotTransmitStruct, collisions, colDict, muEmiss, sigma2Emiss);

else 
     %results = zeros(nbCol, 1);
     %score = 1;
     [resultsWithJam, scoreJam] = findWithOneBad(nbCol, nbNotTransmis, idNotTransmitStruct, collisions, colDict, muEmiss, sigma2Emiss);
     results = resultsWithJam;
     score = scoreJam;
 
     [scoreAllGood, collisionsGood] =  findMostProbablyHealthyCol(collisions, nbCol, colDict);
     scoreAllGood
     celldisp(collisionsGood)
     
     resultsAllGood = zeros(nbCol, 1);
 
     if scoreJam < scoreAllGood
        results = resultsAllGood;
        score = scoreAllGood;
     end
 end

end


function [results, score] = findWithOneBad(nbCol, nbNotTransmis, idNotTransmitStruct, collisions, colDict, muEmiss, sigma2Emiss)
   results = zeros(1, nbCol);
   score = 0;
   [idColl, uniqIdVeh, index] = findMostLikelyJammedCollision(nbCol, nbNotTransmis, idNotTransmitStruct, collisions, colDict, muEmiss, sigma2Emiss); 
   results(idColl) = 1;
   collisionsBis = collisions;
   collisionsBis(idColl) = [];
   
   idNotTransmitStructBis = idNotTransmitStruct;
   idNotTransmitStructBis(index) = [];
   idNotTransmitStructBis = removeColl(idColl, idNotTransmitStructBis);
   
   collisionsBis = findStructImplied(nbCol-1, collisionsBis, idNotTransmitStructBis);

   %idNotTransmit = cellfun(@(x) x.id, idNotTransmitStruct)
   %sidNotTransmitStruct{uniqIdVeh}.id
   %scores(idColl) = scoreCol;

   
%    posColBis = posCol;
%    posColBis(idColl) = [];
%    
%    idNotTransmitBis = idNotTransmit;
%    idNotTransmitBis(idNotTransmit == uniqIdVeh) = [];
%    
    [resultsBis, scoreB] = finalFiltration(nbCol-1, nbNotTransmis-1, idNotTransmitStructBis, collisionsBis, colDict, muEmiss, sigma2Emiss);
    score = score * (scoreB > 0) + scoreB;
    results(results == 0) = resultsBis;

end


function idNotTransmitStructBis = removeColl(idColl, idNotTransmitStructBis)
    for i = 1 : size(idNotTransmitStructBis, 1)
        idNotTransmitStructBis{i}.distances(idColl) = [];
        idNotTransmitStructBis{i}.implication(idColl) = [];             
    end
    
end


