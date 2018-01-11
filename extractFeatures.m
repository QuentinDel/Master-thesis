function [lastSuccessTransmissionAfterCollEachCar, lastCollisionsFeedback,...
    frequencePacketsSuccSent, numberCollEffective, nbVehicles, numberOfCollisionsInPast] = extractFeatures(dataExtraction, isTraining)
%EXTRACTFEATURES 
% Compute the features from the data given
% Features currently extracted:
% 

data = load(dataExtraction); % load historic data
% b - is not relevant right now.
% N - number of vehicles in the platoon.
% p_jam - probability of jamming for a packet.
% seconds - duration of simulation is seconds.
% detect & detect_init - vectors representing  time of simulation as slots. 

% detect_init contains history of packet exchange between vehicles without
% jamming  -> TRAINING SET

% detect also contains collisions introduced by the jammer. The collisions are started to be introduced after 3/4 of simulation time with probability p_jam for each transmitted packet .
%Get dataset to extract
if(isTraining)
   dataset = data.detect_init;
else
   dataset = data.detect;
end
n = length(dataset) - 4; %4 NaN at the end
slotTime = data.seconds / n;

%Get the number of collisions
[colPos] = collision_positions(dataset, -1);
numberColl = length(colPos);
numberOfCollisionsInPast = 5;
numberCollEffective = numberColl - numberOfCollisionsInPast - 1;
nbVehicles = data.N;

%Features;
%inCollision = false;
lastSuccessTransmissionAfterCollEachCar = zeros(data.N, numberColl);
lastCollisionsFeedback = zeros(numberOfCollisionsInPast, numberColl);
frequencePacketsSuccSent = zeros(data.N, numberColl);

%Variables needed to get features
lastSuccTransmissionEachCar = zeros(data.N, 1);
numberOfPacketsSent = zeros(data.N, 1);


for i = 1 : n
    %Set the last good transmission
    if (i+1 > n || dataset(i+1) == 0) && dataset(i) > 0
        lastSuccTransmissionEachCar(dataset(i)) = i;
        numberOfPacketsSent(dataset(i)) = numberOfPacketsSent(dataset(i)) + 1;
        
    %elseif dataset(i) == -1
    %    inCollision = true; 
        %sizeCollision = sizeCollision + 1;

    elseif ismember(i, colPos)
       indexCol = find(i == colPos);
       lastSuccessTransmissionAfterCollEachCar(:,indexCol) = ones(size(lastSuccTransmissionEachCar)) * i - lastSuccTransmissionEachCar;
       frequencePacketsSuccSent(:, indexCol) = numberOfPacketsSent(:) / (i * slotTime); 
       %sizeCollisionF = [sizeCollisionF ; sizeCollision];
       
       if indexCol == 1
           lastCollisionsFeedback(1, indexCol) = i;
       else
           for j = 1 : numberOfCollisionsInPast
              if j >= indexCol
                  break;
              else
                 lastCollisionsFeedback(j, indexCol) = i - colPos(indexCol-j);
              end

           end
       end
    end
       
        %inCollision = false;
        %sizeCollision = 0;
end

lastSuccessTransmissionAfterCollEachCar = lastSuccessTransmissionAfterCollEachCar(:, numberOfCollisionsInPast + 1 : end);
lastCollisionsFeedback = lastCollisionsFeedback(:, numberOfCollisionsInPast + 1 : end);
frequencePacketsSuccSent = frequencePacketsSuccSent(:, numberOfCollisionsInPast + 1 : end);


%figure();
%t = 1 : 1 : n;
%Y = zeros(n, 1);
%Y(timeCollision) = 1;
%plot(t, Y);
 
 

end

