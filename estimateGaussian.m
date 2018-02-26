function [mu, sigma2] = estimateGaussian(X, N)
%ESTIMATEGAUSSIAN This function estimates the parameters of a 
%Gaussian distribution using the data in X
%   [mu sigma2] = estimateGaussian(X), 
%   The input X is the dataset with each n-dimensional data point in one row
%   The output is an n-dimensional vector mu, the mean of the data set
%   and the variances sigma^2, an n x 1 vector
% 

% Useful variables
mu = zeros(N, 1);
sigma2 = zeros(N, 1);

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the mean of the data and the variances
%               In particular, mu(i) should contain the mean of
%               the data for the i-th feature and sigma2(i)
%               should contain variance of the i-th feature.
%

X = cell2mat(X');
for i = 1 : size(X,1)
    arr = X(i,:);
    arr(arr == inf) = [];
    m = length(arr);
    mu(i) = mean(arr);   
    sigma2(i) = (m-1)/m * var(arr);
end



%mu = mean(X);
%Compute normal sigma
%sigma2 = (m-1)/m * var(X);

%Compute Sigma (matrice)
%sigma2 = 1/m * (X'*X);






% =============================================================


end
