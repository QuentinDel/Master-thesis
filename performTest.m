function [pval, mu, sigma2, features, Xval, lastSuccessTransmissionOneCar, frequencePacketsSuccSent, lastCollisionsFeedback] = performTest()
% Perform the test

[lastSuccessTransmissionOneCar, frequencePacketsSuccSent, lastCollisionsFeedback, ...
    Xval, yval, N] = performAllData();

features = frequencePacketsSuccSent;
Xval = Xval(:, N +1: 2 * N);
% features = [lastSuccessTransmissionOneCar ; frequencePacketsSuccSent; lastCollisionsFeedback];

[mu, sigma2] = estimateGaussian(features');
pval = multivariateGaussian(Xval, mu, sigma2);

if sum(sum(sigma2 < 1)) ~= 0
    disp('Warning !!! possible variance < 1');
    disp(mu);
    disp(sigma2);
end

[epsilon, F1, tp, fp, fn] = selectThreshold(yval, pval);
resultCrossVal = pval<epsilon;

fprintf('Best epsilon found using cross-validation: %e\n', epsilon);
fprintf('Best F1 on Cross Validation Set:  %f\n', F1);
fprintf('True positive:  %d\n', tp);
fprintf('False positive:  %f\n', fp);
fprintf('False negative:  %f\n\n', fn);

% % Get results for test set
% % pTest = multivariateGaussian(XTest, mu, sigma2);
% % 
% % resultTest = pTest < epsilon;
% % tp = sum(yTest == 1 & resultTest == 1);
% % fp = sum(yTest == 0 & resultTest == 1);
% % fn = sum(yTest == 1 & resultTest == 0);
% % prec = tp / (tp + fp);
% % rec = tp / (tp + fn);
% % F1 = 2*prec*rec / (prec + rec);
% % 
% % fprintf('Results for the Test set\n');
% % fprintf('F1:  %f\n', F1);
% % fprintf('True positive:  %d\n', tp);
% % fprintf('False positive:  %f\n', fp);
% % fprintf('False negative:  %f\n', fn);
% % 
% 
figure();
subplot(4,1,1)       % add first plot in 2 x 1 grid
bar(yval)
title('True value')

subplot(4,1,2)       % add second plot in 2 x 1 grid
bar(resultCrossVal);  % plot using + markers
title('Bad collisions detected')

subplot(4,1,3)       % add second plot in 2 x 1 grid
bar(yval - resultCrossVal);  % plot using + markers
title('True positive / false negative');
legend('-1 = false positive 1 = false negative   ');

subplot(4,1,4)       % add second plot in 2 x 1 grid
bar(pval);  % plot using + markers
title('Probability score');

end

