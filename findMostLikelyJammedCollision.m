function [idColl, idCar] = findMostLikelyJammedCollision(idNotTransmit, nbNotTransmis, nbCol, posCol, colDict, muEmiss, sigma2Emiss)

keyCol = keys(colDict);

%First find one that never collided naturally
for i = 1 : nbNotTransmis
   results = cellfun(@(x) ismember(idNotTransmit(i), str2num(x)), keyCol);
   if sum(results) == 0
       1
       idCar = idNotTransmit(i);
       idColl = findClosestCol(idCar, nbCol, posCol, muEmiss, sigma2Emiss);
       return;
   end
end

idColl = 1;
idCar = idNotTransmit(1);

end

function [idColl] = findClosestCol(idCar, nbCol, posCol, muEmiss, sigma2Emiss)
    probMax = 0;
    for i = 1 : nbCol
       prob = multivariateGaussian(posCol(i), muEmiss(idCar), sigma2Emiss(idCar));
       if prob > probMax
           idColl = i;
       end
        
    end



end