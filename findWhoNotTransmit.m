function [idNotTransmit, nbNotTransmist] = findWhoNotTransmit(nb, period)
    idNotTransmit = zeros(1, nb);
    nbNotTransmist = 0;
    for i = 1 : nb
       if sum(period == i) == 0 
           nbNotTransmist = nbNotTransmist + 1;
           idNotTransmit(nbNotTransmist) = i;
       elseif sum(period == i) > 40
           fprintf('More than one communication');    
       end
    end
     
    idNotTransmit = idNotTransmit(1: nbNotTransmist);
end