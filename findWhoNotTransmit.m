function [idNotTransmit, nbNotTransmist] = findWhoNotTransmit(nb, period)
    idNotTransmit = zeros(1, nb);
    nbNotTransmist = 0;
    for i = 1 : nb
       %if sum(period == i) == 0
       if isempty(indicePositions(period', i))
           nbNotTransmist = nbNotTransmist + 1;
           idNotTransmit(nbNotTransmist) = i;
%        elseif sum(period == i) > 40
%            fprintf('Warning: More than one communication for %d\n', i);        
       end
    end
     
    idNotTransmit = idNotTransmit(1: nbNotTransmist);
end