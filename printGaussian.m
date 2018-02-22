function printGaussian(periodSlot, muEmiss, sigma2Emiss)
%PRINTGAUSSIAN Summary of this function goes here

x = - periodSlot : 1 : periodSlot + round(periodSlot/2);

distrib = zeros(25, length(x));

hold on
for i = 1 : length(muEmiss)
    plot(x, normpdf(x,muEmiss(i),sigma2Emiss(i)^0.5));
end

hold off
end

