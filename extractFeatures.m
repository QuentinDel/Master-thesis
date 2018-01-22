function [lastSuccessTransmissionAfterCollEachCar, lastCollisionsFeedback,...
    frequencePacketsSuccSent, numberOfCollisionsInPast] = extractFeatures(dataExtraction, withJam)
%EXTRACTFEATURES 
% Compute the features from the data given

% load historic data
data = load(dataExtraction); 

% %%%% DATA CONTAINED %%%%
% b - is not relevant right now.
% N - number of vehicles in the platoon.
% p_jam - probability of jamming for a packet.
% seconds - duration of simulation is seconds.
% detect & detect_init - vectors representing  time of simulation as slots. 
%%%%%%%%%%%%%%%%%%%%%%%%%%

%Get dataset to extract
if(~withJam)
   dataset = data.detect_init;
else
   dataset = data.detect;
   %dataset(dataset==-2) = -1;
end

n = length(dataset);
slotTime = data.seconds / n;

%Get the number of collisions and set parameters
[colPos] = collision_positions(dataset, -1);
numberColl = length(colPos);
numberOfCollisionsInPast = 5;

%Get the emissions for all car.
nbVehicles = data.N;
emissionPositions = cell(nbVehicles, 1);

%Get emissions for each vehicles
for i = 1 : nbVehicles
   emissionPositions{i} = collision_positions(dataset, i);
end

%Features initialization
lastSuccessTransmissionAfterCollEachCar = zeros(data.N, numberColl);
lastCollisionsFeedback = zeros(numberOfCollisionsInPast, numberColl);
frequencePacketsSuccSent = zeros(data.N, numberColl);


for i = numberOfCollisionsInPast + 1 : numberColl
     currentColPos = colPos(i);
    
    for j = 1 : nbVehicles
       [nbPacketSent]  = find(emissionPositions{j} < currentColPos, 1, 'last');
       lastSuccessTransmissionAfterCollEachCar(j, i) = currentColPos - emissionPositions{j}(nbPacketSent);
       frequencePacketsSuccSent(j, i) = nbPacketSent / (slotTime * currentColPos);
    end
   
    %Get last collisions
    for j = 1 : numberOfCollisionsInPast
       lastCollisionsFeedback(j, i) = colPos(i) - colPos(i - j);
    end
end

lastSuccessTransmissionAfterCollEachCar = lastSuccessTransmissionAfterCollEachCar(:, numberOfCollisionsInPast + 1 : end);
lastCollisionsFeedback = lastCollisionsFeedback(:, numberOfCollisionsInPast + 1 : end);
frequencePacketsSuccSent = frequencePacketsSuccSent(:, numberOfCollisionsInPast + 1 : end);

end

