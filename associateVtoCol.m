function [results] = associateVtoCol(nbCol, posCol, vehiclesGroup, mu, sigma)
vehiclesGroup
results = ones(1, nbCol);
healthyGroup = cellfun(@(x) size(x, 2) > 1, vehiclesGroup);

nbHealthyGroup = sum(healthyGroup);
if nbHealthyGroup == nbCol
    results = zeros(nbCol, 1);
end

for i = 1 : nbCol
    if healthyGroup(i) == 1
        vehiclesGroup{i}
        [idCol] = findClosestCol(vehiclesGroup{i}, nbCol, posCol, mu, sigma);
        results(idCol) = 0;
        posCol(idCol) = [];
        nbCol = nbCol-1;
    end
end

end


function [idColl] = findClosestCol(idVec, nbCol, posCol, muEmiss, sigma2Emiss)
    probMax = 0;
    idColl = 1;
    for i = 1 : nbCol
       prob = multivariateGaussian(posCol(i), muEmiss(idVec), sigma2Emiss(idVec));
       prob

       if prob > probMax
%            if probMax ~= 0 && (abs(prob - probMax))/abs(prob + probMax) < 0.01
%               %fprintf('Difficult to determine which is the bad one\n'); 
%            end
           probMax = prob;
           idColl = i;
       end 
    end
    
%     if probMax == 0
%        %fprintf('Impossible to find a correct position for this configuration of vehicles\n'); 
%     end
end