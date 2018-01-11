function printData()

[features, Xval, yval, XTest, yTest] = performAllData(false);
[mu, sigma2] = estimateGaussian(features);
pval = multivariateGaussian(Xval, mu, sigma2);


mu
sigma2
Xval


end

