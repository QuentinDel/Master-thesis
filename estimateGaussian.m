function [mu, sigma2] = estimateGaussian(X, N)
%ESTIMATEGAUSSIAN This function estimates the parameters of a 
%Gaussian distribution using the data in X

mu = zeros(N, 1);
sigma2 = zeros(N, 1);

X = cell2mat(X');
for i = 1 : size(X,1)
    arr = X(i,:);
    arr(arr == inf) = [];
    m = length(arr);
    mu(i) = mean(arr);   
    sigma2(i) = (m-1)/m * var(arr);
end


%Other way to compute with same length dataset:

%mu = mean(X);
%Compute normal sigma
%sigma2 = (m-1)/m * var(X);

%Compute Sigma (matrice)
%sigma2 = 1/m * (X'*X);

end
