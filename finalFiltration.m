function [results, score] = finalFiltration(nbCol, nbNotTransmis, idNotTransmitStruct, collisions, colDict, muEmiss, sigma2Emiss)

if nbCol == 1
    results = 0;
    score = -1;
    key = num2str(collisions{1}.idsImplied);
    if isKey(colDict, key)
       score = colDict(key); % * multivariateGaussian(posMat, muEmiss(idNotTransmit), sigma2Emiss(idNotTransmit));
    end
else %if nbCol * 2 > nbNotTransmist
   [results, score] = findWithOneBad(nbCol, nbNotTransmis, idNotTransmitStruct, collisions, colDict, muEmiss, sigma2Emiss);

% else 
%     [resultsWithJam, scoreJam] = findWithOneBad(nbCol, posCol, idNotTransmit, nbNotTransmist, colDict, colDictCollideWith, muEmiss, sigma2Emiss, frequencyCol);
%     
%     results = resultsWithJam;
%     score = scoreJam;
%     
%     [resultsAllGood, scoreAllGood] =  findMostProbablyHealthyCol(idNotTransmit, nbNotTransmist, nbCol, colDict);
%     if scoreJam < scoreAllGood
%        results = resultsAllGood;
%        score = scoreAllGood;
%     end
% end

end
end


function [results, score] = findWithOneBad(nbCol, nbNotTransmis, idNotTransmitStruct, collisions, colDict, muEmiss, sigma2Emiss)

   results = zeros(1, nbCol);
   score = 10;
   [idColl, uniqIdVeh] = findMostLikelyJammedCollision(nbCol, nbNotTransmis, idNotTransmitStruct, collisions, colDict, muEmiss, sigma2Emiss); 
   results(idColl) = 1;
   %idNotTransmit = cellfun(@(x) x.id, idNotTransmitStruct)
   %sidNotTransmitStruct{uniqIdVeh}.id
   %scores(idColl) = scoreCol;

   
%    posColBis = posCol;
%    posColBis(idColl) = [];
%    
%    idNotTransmitBis = idNotTransmit;
%    idNotTransmitBis(idNotTransmit == uniqIdVeh) = [];
%    
%    [resultsBis, scoreB] = secondFiltration(nbCol-1, posColBis, idNotTransmitBis, nbNotTransmis - 1, colDict, muEmiss, sigma2Emiss, frequencyCol);
%    score = score * (scoreB > 0) + scoreB;
%    results(results == 0) = resultsBis;

end

