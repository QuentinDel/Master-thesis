function [results, score] = secondFiltration(idImpliedInEachCol, posForEachVeh, idImpliedInDifferent, impliedInTheseCol, nbCol, colDict, muEmiss, sigma2Emiss)
%
%scores = zeros(nbCol, 0);

if nbCol == 1
    results = 0;
    score = -1;
    key = num2str(idNotTransmit);
    if isKey(colDict, key)
       score = colDict(key); % * multivariateGaussian(posMat, muEmiss(idNotTransmit), sigma2Emiss(idNotTransmit));
    end
elseif nbCol * 2 > nbNotTransmist
   [results, score] = findWithOneBad(nbCol, posCol, idNotTransmit, nbNotTransmist, colDict, colDictCollideWith, muEmiss, sigma2Emiss, frequencyCol);

else 
    [resultsWithJam, scoreJam] = findWithOneBad(nbCol, posCol, idNotTransmit, nbNotTransmist, colDict, colDictCollideWith, muEmiss, sigma2Emiss, frequencyCol);
    
    results = resultsWithJam;
    score = scoreJam;
    
    [resultsAllGood, scoreAllGood] =  findMostProbablyHealthyCol(idNotTransmit, nbNotTransmist, nbCol, colDict);
    if scoreJam < scoreAllGood
       results = resultsAllGood;
       score = scoreAllGood;
    end
end

end


function [results, score] = findWithOneBad(nbCol, posCol, idNotTransmit, nbNotTransmis, colDict, colDictCollideWith, muEmiss, sigma2Emiss, frequencyCol)

   results = zeros(1, nbCol);
   score = 10;
   [idColl, idCar] = findMostLikelyJammedCollision(idNotTransmit, nbNotTransmis, nbCol, posCol, colDict, colDictCollideWith, muEmiss, sigma2Emiss); 
   results(idColl) = 1;
   %scores(idColl) = scoreCol;

   
   posColBis = posCol;
   posColBis(idColl) = [];
   
   idNotTransmitBis = idNotTransmit;
   idNotTransmitBis(idNotTransmit == idCar) = [];
   
   [resultsBis, scoreB] = secondFiltration(nbCol-1, posColBis, idNotTransmitBis, nbNotTransmis - 1, colDict, colDictCollideWith, muEmiss, sigma2Emiss, frequencyCol);
   score = score * (scoreB > 0) + scoreB;
   results(results == 0) = resultsBis;

end

