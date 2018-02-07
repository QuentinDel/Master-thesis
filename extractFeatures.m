%function [score, training_part, detect_init, detect] = extractFeatures(dataExtraction, withJam, periodDic)
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
n = length(data.detect);
slotTime = data.seconds / n;
f = 1 / data.beaconing_period;
periodSlot = round(1 / (f * slotTime));
   
training_part = round(length(data.detect)*(3/4));
training_part = training_part + periodSlot - mod(training_part, periodSlot);

detect_init = data.detect_init;
detect = data.detect;

%Stat
nbFirstFilt = 0;

if(~withJam)
   dataset = data.detect_init(1 : training_part);
   periods = reshape(dataset, periodSlot, training_part / periodSlot);
else
   dataset = data.detect(training_part + 1 : end);
   dataset = [dataset, zeros(1, periodSlot - mod(length(dataset), periodSlot))];
   periods = reshape(dataset, periodSlot, length(dataset) / periodSlot);
end

positionCol = collision_positions( dataset, -1);
scores = zeros(size(positionCol, 1));
numCol = zeros(size(positionCol, 1));

for i = 1 : length(positionCol)
   
   position = positionCol(i);
   period = periods(:, ((position - mod(position,periodSlot)) / periodSlot) + 1);
   
   nbCol = sum(period == -1)/40;
   [idNotTransmit, nbNotTransmis] = findWhoNotTransmit(data.N, period);
   
   %First filtration
   if nbCol == 1
      nbFirstFilt = nbFirstFilt + 1;
      if nbNotTransmis == 1
         scores(i) = 1;
      else
         scores(i) = 0;
      end
   %Second filtration  
   else
       [results] = performSecondFiltration(period, nbCol, idNotTransmit, nbNotTransmis);
       scores(i: i + nbCol-1) = results;
   end
   
   i = i + nbCol - 1;
end

%end

