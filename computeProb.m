function p = computeProb(X, mu, sigma2)

p = 1;
for i = 1 : length(X)
   p = p * (2*pi)^(-0.5) * exp(-(p(i) - mu(i))^2 / (2*sigma2));    
end

end

