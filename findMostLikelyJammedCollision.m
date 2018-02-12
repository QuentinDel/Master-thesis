function [idColl, idCar] = findMostLikelyJammedCollision(idNotTransmit, nbNotTransmis, nbCol, posCol, colDict, colDictCollideWith, muEmiss, sigma2Emiss)

%First find one that never collided naturally
for i = 1 : nbNotTransmis
   if isempty(colDictCollideWith{idNotTransmit(i)})
       idCar = idNotTransmit(i);
       idColl = findClosestCol(idCar, nbCol, posCol, muEmiss, sigma2Emiss);
       return;
   end
end

%Find one that never collided with all the other
for i = 1 : nbNotTransmis
   if sum(ismember(idNotTransmit, colDictCollideWith{idNotTransmit(i)})) == 0
       idCar = idNotTransmit(i);
       idColl = findClosestCol(idCar, nbCol, posCol, muEmiss, sigma2Emiss);
       return;
   end
end


%Find the most unlikely natural one
allComb = nchoosek(idNotTransmit, 2);
scores = zeros(size(allComb, 1), 1);
for i = 1 : size(allComb, 1)
    key = num2str(allComb(i,:));
    if isKey(colDict, key)
        scores(i) = colDict(key);
    end
end
maxScore = inf;
for i = 1 : nbNotTransmis
    idV = idNotTransmit(i);
    score = 0;
    for j = 1 : size(allComb, 1)
       score = score + scores(j) * ismember(idV, allComb(j, :));
    end
    
    if score < maxScore
       idCar = idV;
       [idColl] = findClosestCol(idCar, nbCol, posCol, muEmiss, sigma2Emiss);
       maxScore = score;
    end
end

end


function [idColl] = findClosestCol(idCar, nbCol, posCol, muEmiss, sigma2Emiss)
    probMax = 0;
    idColl = 1;
    for i = 1 : nbCol
       prob = multivariateGaussian(posCol(i), muEmiss(idCar), sigma2Emiss(idCar));

       if prob > probMax
           if probMax ~= 0 && (abs(prob - probMax))/abs(prob + probMax) < 0.01
              fprintf('Difficult to determine which is the bad one\n'); 
           end
           probMax = prob;
           idColl = i;
       end 
    end
    
    if probMax == 0
       fprintf('Impossible to find a correct position for this configuration of vehicles'); 
    end
end