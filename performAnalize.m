%function [scores, training_part, detect_init, detect] = extractFeatures(dataExtraction, withJam, colDict, colDictCollideWith, muEmiss, sigma2Emiss, frequencyCol)

% Compute the features from the data given

% %%%% DATA CONTAINED %%%% %
% b - is not relevant right now.
% N - number of vehicles in the platoon.
% p_jam - probability of jamming for a packet.
% seconds - duration of simulation is seconds.
% detect & detect_init - vectors representing  time of simulation as slots. 
%%%%%%%%%%%%%%%%%%%%%%%%%%
[periodsInfo, transmissionsInfos, training_part, periodSlot, periodsSec, dataset] = extractPeriods(data, true);
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
prevperiodsInfo = periodsInfo;
while i <= length(positionCol)
     %if i == 12
    [idImpliedInEachCol, idImpliedInDifferent, impliedInTheseCol, periodsInfo, periodImplied] = findCut(i, positionCol, periodsInfo, periodSlot, intervTransmiss, 1);
    %size(idImpliedInEachCol)
    nbCol = size(idImpliedInEachCol, 2);
    a = cellfun(@(x) length(x), idImpliedInEachCol);
    nbNotTransmis = length(idImpliedInDifferent) + sum(a);
    if nbNotTransmis == 0
       i 
    end
    
   %  end 
   
     %end
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
%        posCol = indicePositions(period', -1);
%        posSecondFilt = [posSecondFilt, i:i + nbCol - 1];
%        [results] = secondFiltration(nbCol, posCol, idNotTransmit, nbNotTransmis, colDict, colDictCollideWith, muEmiss, sigma2Emiss, frequencyCol);
       scores(i: i + nbCol-1) = -1;  
%        nbJammed = [nbJammed sum(results == 1)];
%        numbColAnalyze = [numbColAnalyze nbCol];
   end
%    
   i = i + nbCol;
end

%end
