function [results, score] = secondFiltration(nbCol, posCol, idNotTransmit, nbNotTransmis)

%results = zeros(nbCol, 0);
%scores = zeros(nbCol, 0);

if nbCol * 2 > nbNotTransmis
   [results, score] = findWithOneBad(idNotransmis, nbCol, posCol);
else
    
    [resultsAllGood, scoreAllGood] = findMostProbablyHealthyCol(idNotTransmit, nbNotTransmis);
    [resultsWithJam, scoreJam] = findWithOneBad(idNotransmis, nbCol, posCol);
    
    results = resultsAllGood;
    score = scoreAllGood;
    
    if scoreJam > scoreAllGood
        results = resultsWithJam;
        score = scoreJam;
    end
end

end


function [results, score] = findWithOneBad(nbCol, posCol, idNotTransmit, nbNotTransmis)
   [idColl, idCar] = findMostLikelyJammedCollision(idNotTransmit, nbCol, posCol); 
   results(idColl) = 1;
   %scores(idColl) = scoreCol;
   
   posColBis = posCol;
   posColBis(idColl) = [];
   
   idNotTransmitBis = idNotTransmit;
   idNotTransmitBis(idNotTransmit == idCar) = [];
   
   [resultsBis, score] = secondFiltration(nbCol-1, posColBis, idNotTransmitBis, nbNotTransmis);
   results(resuls == 0) = resultsBis;

end

