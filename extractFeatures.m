function [features, firstCollisionAccepted] = extractFeatures(dataExtraction, withJam, nbPastPeriods)
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
end

n = length(dataset);
slotTime = data.seconds / n;
onePeriodSlot = round(data.beaconing_period/slotTime);
slotsPastToCheck = onePeriodSlot * nbPastPeriods;
firstCollisionAccepted = -1;

%Get the number of collisions and set parameters
[colPos] = collision_positions(dataset, -1);
numberColl = length(colPos);

%Get the emissions for all car.
nbVehicles = data.N;
emissionPositions = cell(nbVehicles, 1);

%Get emissions for each vehicles
for i = 1 : nbVehicles
   emissionPositions{i} = collision_positions(dataset, i);
end

%Features initialization
freqPacketsSuccSent = zeros(data.N, numberColl);
freqColl = zeros(1, numberColl);


for i = 1 : numberColl
     currentColPos = colPos(i);
     
     if currentColPos > slotsPastToCheck
         %Set first collision to agree
         if firstCollisionAccepted == -1
             firstCollisionAccepted = i + 1;             
         end
         
         %Get frequence of nb packet sent and collision packet.
%          for j = 1 : nbVehicles
%              %Check total number of packets sent at the time of the
%              %collision
%              [nbPacketSentUp]  = find(emissionPositions{j} < currentColPos, 1, 'last');
%               if isempty(nbPacketSentUp)
%                 nbPacketSentUp = 0; 
%              end 
%              
%              [nbPacketSentLow] = find(emissionPositions{j} < currentColPos - slotsPastToCheck, 1, 'last');
%              if isempty(nbPacketSentLow)
%                 nbPacketSentLow = 0; 
%              end
%              
%              freqPacketsSuccSent(j, i) = (nbPacketSentUp - nbPacketSentLow) / (slotsPastToCheck * slotTime);           
%          end
         
         lastCollInPeriods = find(colPos < currentColPos - slotsPastToCheck, 1, 'last');
         if isempty(lastCollInPeriods)
             lastCollInPeriods = 0;
         end
         freqColl(1, i) = (i - lastCollInPeriods) / (slotsPastToCheck * slotTime);
         
     end
     
end


%freqPacketsSuccSent = freqPacketsSuccSent(:, firstCollisionAccepted : end);
freqColl = freqColl(:, firstCollisionAccepted : end);


%Transform to Gaussian
features = [freqColl]';
firstCollisionAccepted = firstCollisionAccepted - 1;
end

