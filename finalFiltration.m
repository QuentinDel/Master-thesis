function [results] = finalFiltration(fixeIdInEachCol, idInDifferent, impliedInTheseCol, nbNotTransmis, nbCol, colDict)
results = zeros(nbCol, 1);

if nbCol * 2 > nbNotTransmis
    nbSureJammed = nbCol * 2 - nbNotTransmis; 
    [fixeIdInEachCol, idInDifferent, impliedInTheseCol, nbNotTransmis, nbCol, colDict, results] = ...
        removeNbJammed(fixeIdInEachCol, idInDifferent, impliedInTheseCol, nbNotTransmis, nbCol, colDict, nbSureJammed);
    
end



end

