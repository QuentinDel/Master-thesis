function [intervTransmiss] = estimateInterv(N, periodSlot, muEmiss, sigma2Emiss)
    
x = - round(periodSlot/2) : 1 : periodSlot + round(periodSlot/2);
intervTransmiss = zeros(N, 2);

for i = 1 : N
   p = normcdf(x, muEmiss(i), sigma2Emiss(i)^0.5);
   intervTransmiss(i, 1) = find(p > 0.0001, 1)  - round(periodSlot/2);
   intervTransmiss(i, 2) = 2 * muEmiss(i) - intervTransmiss(i, 1);
end

%Apply marge factor
coef =3;
sigma = sigma2Emiss.^0.5;
intervTransmiss(:, 1) = intervTransmiss(:, 1) -  sigma * coef;
intervTransmiss(:, 2) = intervTransmiss(:, 2) + sigma * coef;

end