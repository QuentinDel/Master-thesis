function [intervTransmiss] = estimateInterv(N, periodSlot, muEmiss, sigma2Emiss, coef)
    
x = - round(periodSlot/2) : 1 : periodSlot + round(periodSlot/2);
intervTransmiss = zeros(N, 2);

for i = 1 : N
   %Compute the cumulative prob.
   p = normcdf(x, muEmiss(i), sigma2Emiss(i)^0.5);
   intervTransmiss(i, 1) = find(p > 0.0001, 1)  - round(periodSlot/2); 
   intervTransmiss(i, 2) = 2 * muEmiss(i) - intervTransmiss(i, 1);
end

%Apply safety factor
%coef =3;
%safAdd = 500;
sigma = sigma2Emiss.^0.5;
intervTransmiss(:, 1) = intervTransmiss(:, 1) -  sigma * coef;% - safAdd;
intervTransmiss(:, 2) = intervTransmiss(:, 2) + sigma * coef;% + safAdd;

%intervTransmiss(:, 1) = muEmiss - sigma*coef;
%intervTransmiss(:, 2) = muEmiss + sigma*coef;

end