%function [scores, training_part, detect_init, detect] = extractFeatures(dataExtraction, withJam, colDict, colDictCollideWith, muEmiss, sigma2Emiss, frequencyCol)
%EXTRACTFEATURES 
% Compute the features from the data given

% load historic data
data = load(dataExtraction); 

% %%%% DATA CONTAINED %%%% %
% b - is not relevant right now.
% N - number of vehicles in the platoon.
% p_jam - probability of jamming for a packet.
% seconds - duration of simulation is seconds.
% detect & detect_init - vectors representing  time of simulation as slots. 
%%%%%%%%%%%%%%%%%%%%%%%%%%
detect_init = data.detect_init(cut:end);
detect = data.detect(cut:end);

%Get dataset to extract
n = length(detect);
slotTime = data.seconds / n;
f = 1 / data.beaconing_period;
periodSlot = round(1 / (f * slotTime));
   
training_part = round(length(detect)*(3/4));
training_part = training_part + periodSlot - mod(training_part, periodSlot);



%Stat
posFirstFilt = [];
posSecondFilt = [];

dataset = detect(training_part + 1 : end);
dataset = [dataset, zeros(1, periodSlot - mod(length(dataset), periodSlot))];
periods = reshape(dataset, periodSlot, length(dataset) / periodSlot);


positionCol = indicePositions(dataset, -1);
scores = zeros(size(positionCol, 1));
numCol = zeros(size(positionCol, 1));
nbJammed = [];
numbColAnalyze = [];

%nbCol = 1;
i = 1;
while i <= length(positionCol)
   
   position = positionCol(i);
   period = periods(:, ((position - mod(position,periodSlot)) / periodSlot) + 1);
   
   if i == 10
    periodToCheck = period;
   end
   
   nbCol = length(indicePositions(period', -1));
   [idNotTransmit, nbNotTransmis] = findWhoNotTransmit(data.N, period);
   
   if length(idNotTransmit) ~= nbNotTransmis
      fprintf('error idNotTransmit and nb'); 
   end
   
   %First filtration
   if nbCol == 1 && nbNotTransmis > 1
      posFirstFilt = [posFirstFilt, i];
      scores(i) = 0;
      nbJammed = [nbJammed 0];
      numbColAnalyze = [numbColAnalyze nbCol];
      
   elseif nbCol == nbNotTransmis
      posFirstFilt = [posFirstFilt, i:i + nbCol - 1];
      scores(i:i + nbCol - 1) = 1;
      nbJammed = [nbJammed nbCol];
      numbColAnalyze = [numbColAnalyze nbCol];
   
   %Second filtration  
   else 
       posCol = indicePositions(period', -1);
       posSecondFilt = [posSecondFilt, i:i + nbCol - 1];
       [results] = secondFiltration(nbCol, posCol, idNotTransmit, nbNotTransmis, colDict, colDictCollideWith, muEmiss, sigma2Emiss, frequencyCol);
       scores(i: i + nbCol-1) = results;  
       nbJammed = [nbJammed sum(results == 1)];
       numbColAnalyze = [numbColAnalyze nbCol];

   end
   
   i = i + nbCol;
end

%end

