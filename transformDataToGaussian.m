function [frequencePacketsSuccSentGauss, lastCollisionsFeedbackGauss] = ...
        transformDataToGaussian(frequencePacketsSuccSent, lastCollisionsFeedback)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

frequencePacketsSuccSentGauss = frequencePacketsSuccSent.^3;
lastCollisionsFeedbackGauss = lastCollisionsFeedback;

end


%lastSuccessTransmissionGauss =  log(lastSuccessTransmission);
