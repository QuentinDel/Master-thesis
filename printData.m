function printData()

[lastSuccessTransmissionOneCar, lastCollisionsFeedback, frequencePacketsSuccSent, ...
    Xval, yval, N] = performAllData();

features = [lastSuccessTransmissionOneCar ; frequencePacketsSuccSent; lastCollisionsFeedback];

[mu, sigma2] = estimateGaussian(features');

x = 0:0.25:50;

mark = 1;
marksBis = zeros(size(lastCollisionsFeedback, 2));
sigma = diag(sigma2);
sigma = sigma.^0.5;

for i = 1 : size(features, 1)
    figure();
    norm = normpdf(x, mu(i), sigma(i));
    plot(x, norm);
    plot(features(i,:), marksBis, 'b+');
    plot(Xval(:, i), mark, 'r+');
end



end

