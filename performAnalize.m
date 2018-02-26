%function [scores, training_part, detect_init, detect] = extractFeatures(dataExtraction, withJam, colDict, colDictCollideWith, muEmiss, sigma2Emiss, frequencyCol)

% Compute the features from the data given

% %%%% DATA CONTAINED %%%% %
% b - is not relevant right now.
% N - number of vehicles in the platoon.
% p_jam - probability of jamming for a packet.
% seconds - duration of simulation is seconds.
% detect & detect_init - vectors representing  time of simulation as slots. 
%%%%%%%%%%%%%%%%%%%%%%%%%%
[periodIdNotTransmit, transmissionsInfos, training_part, periodSlot, periodsSec, dataset] = extractPeriods(data, true);

%Stat
posFirstFilt = [];
posSecondFilt = [];

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
   
   nbCol = length(indicePositions(period', -1));
   [idNotTransmit, nbNotTransmis] = findWhoNotTransmit(data.N, period);
  
   
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

