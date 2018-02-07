function [results, score] = secondFiltration(nbCol, posCol, idNotTransmit, nbNotTransmist, colDict, muEmiss, sigma2Emiss, frequencyCol)

%results = zeros(nbCol, 0);
%scores = zeros(nbCol, 0);

if nbCol == 1
    results = 0;
    score = 0;
    key = num2str(idNotTransmit);
    if isKey(colDict, key)
       posMat = posCol(1) * ones(nbNotTransmist, 1)';
%        size(posMat)
%        size(muEmiss(idNotTransmit))
%        size(sigma2Emiss(idNotTransmit))
       score = colDict(key) * multivariateGaussian(posMat, muEmiss(idNotTransmit), sigma2Emiss(idNotTransmit));
    end
elseif nbCol * 2 > nbNotTransmist
   [results, score] = findWithOneBad(nbCol, posCol, idNotTransmit, nbNotTransmist, colDict, muEmiss, sigma2Emiss, frequencyCol);

else 
    [resultsWithJam, scoreJam] = findWithOneBad(nbCol, posCol, idNotTransmit, nbNotTransmist, colDict, muEmiss, sigma2Emiss, frequencyCol);
    
    results = resultsWithJam;
    score = scoreJam;
    
    if frequencyCol(nbCol / nbNotTransmis) > 0
        [resultsAllGood, scoreAllGood] = findMostProbablyHealthyCol(idNotTransmit, nbNotTransmist);
    
        if scoreJam < scoreAllGood
            results = resultsAllGood;
            score = scoreAllGood;
        end
    end
end

end


function [results, score] = findWithOneBad(nbCol, posCol, idNotTransmit, nbNotTransmis, colDict, muEmiss, sigma2Emiss, frequencyCol)
   [idColl, idCar] = findMostLikelyJammedCollision(idNotTransmit, nbNotTransmis, nbCol, posCol, colDict, muEmiss, sigma2Emiss); 
   results(idColl) = 1;
   %scores(idColl) = scoreCol;
   
   posColBis = posCol;
   posColBis(idColl) = [];
   
   idNotTransmitBis = idNotTransmit;
   idNotTransmitBis(idNotTransmit == idCar) = [];
   
   [resultsBis, score] = secondFiltration(nbCol-1, posColBis, idNotTransmitBis, nbNotTransmis - 1, colDict, muEmiss, sigma2Emiss, frequencyCol);
   results(results == 0) = resultsBis;

end

