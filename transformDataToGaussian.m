function [lastSuccessTransmissionGauss, frequencePacketsSuccSentGauss, lastCollisionsFeedbackGauss] = ...
        transformDataToGaussian(lastSuccessTransmission, frequencePacketsSuccSent, lastCollisionsFeedback)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

lastSuccessTransmissionGauss =  log(lastSuccessTransmission);
frequencePacketsSuccSentGauss = frequencePacketsSuccSent.^2;
lastCollisionsFeedbackGauss = lastCollisionsFeedback;

end

