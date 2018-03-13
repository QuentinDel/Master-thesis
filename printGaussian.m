function printGaussian(periodSlot, muEmiss, sigma2Emiss, intervTransmiss)
%PRINTGAUSSIAN Summary of this function goes here

x =  - round(periodSlot/2) : 1 : periodSlot + round(periodSlot/2);
y = 0.0001 * ones(size(intervTransmiss));


figure
hold on
for i = 1 : length(muEmiss)
    plot(x, normpdf(x,muEmiss(i),sigma2Emiss(i)^0.5));
    title('Gaussian representing transmission time of each vehicle');
    xlabel('Time of transmission');
    ylabel('Probability');
end
plot(intervTransmiss(1, :), y(1, :), '+r');
hold off
end

