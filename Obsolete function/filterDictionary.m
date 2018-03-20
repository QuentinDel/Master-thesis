function [ colDict ] = filterDictionary(colDict, mu, sigma2, periodSlot)

allKeys = keys(colDict);
sigma = sigma2 .^(0.5);
nbDeleted = 0;

for i = 1 : size(allKeys, 2)
    idNotTransmit = str2num(allKeys{i});
    overlap = calc_overlap_twonormal(sigma(idNotTransmit),  mu(idNotTransmit), periodSlot, 1);
    if overlap < 0.001
        nbDeleted = nbDeleted + 1;
        remove(colDict, allKeys(i));
    end
end
end

% numerical integral of the overlapping area of two normal distributions:
% s1,s2...sigma of the normal distributions 1 and 2
% mu1,mu2...center of the normal distributions 1 and 2
% xstart,xend,xinterval...defines start, end and interval width
% example: [overlap] = calc_overlap_twonormal(2,2,0,1,-10,10,0.01)
function [overlap2] = calc_overlap_twonormal(s, mu, xend, xinterval)
x_range = 1 : xinterval : xend;
m = length(s);
gaussians = zeros(m, xend);

for i = 1 : m
    gaussians(i, :) = normpdf(x_range,mu(i),s(i))';   
end
overlap=cumtrapz(x_range,min(gaussians));
overlap2 = overlap(end);
end
