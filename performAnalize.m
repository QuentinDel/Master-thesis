%function [scores, training_part, detect_init, detect] = extractFeatures(dataExtraction, withJam, colDict, colDictCollideWith, muEmiss, sigma2Emiss, frequencyCol)

% %%%% DATA already included %%%%
%data: structure of the data
%colDict: dictionary of collisions
%muEmiss: Means of the first slot for the beacon transmission of the different vehicles  
%sigma2Emiss: standard deviation for the beacon transmission of the different vehicles  
%intervTransmiss: Interval of slots for each vehicles where it can
%                      transmit
%periods: the dataset shaped into period
%periodIdNotTransmit: Which vehicles did not transmit in each period


%Extract the info of who did not transmit in each period
[periodsInfo, transmissionsInfos, training_part, periodSlot, periodsSec, dataset] = extractPeriods(data, true, TIME(tt));

%Used for stat
posFirstFilt = [];
posSecondFilt = [];

%Init different variables used to retrieve info about results
positionCol = indicePositions(dataset, -1);
scores = zeros(size(positionCol, 1));
numCol = zeros(size(positionCol, 1));
nbJammed = [];
numbColAnalyze = [];

i = 1;
prevperiodsInfo = periodsInfo; %Used to see only the differences before/after
while i <= length(positionCol)
    %Get sets of collisions
    [fixeIdInEachCol, posForEachFixedVeh, idInDifferent, impliedInTheseCol, periodsInfo, periodImplied] = findCut(i, positionCol, periodsInfo, periodSlot, intervTransmiss, 1);
    
    %Obtain C and M (number of collisions and number of vehicles implied in
    %these collisions).
    nbCol = size(fixeIdInEachCol, 2);
    a = cellfun(@(x) length(x), fixeIdInEachCol);
    nbNotTransmis = length(idInDifferent) + sum(a);
    
    %Error in that moment
    if nbNotTransmis < nbCol
       fprintf('No vehicles implied in one or more collisions %d %d %d\n', i, nbCol, periodImplied);
        scores(i:i + nbCol - 1) = 1;
        numbColAnalyze = [numbColAnalyze nbCol];
        nbJammed = [nbJammed 0];
        i = i + nbCol;

       continue
    end

   %First filtration: C = 1 and M > 1
   if nbCol == 1 && nbNotTransmis > 1
      posFirstFilt = [posFirstFilt, i];
      scores(i) = 0;
      nbJammed = [nbJammed 0];
      numbColAnalyze = [numbColAnalyze nbCol];
    
   %First filtration: C = M
   elseif nbCol == nbNotTransmis
      posFirstFilt = [posFirstFilt, i:i + nbCol - 1];
      scores(i:i + nbCol - 1) = 1;
      nbJammed = [nbJammed nbCol];
      numbColAnalyze = [numbColAnalyze nbCol];
   
   %Second filtration  
   else 
     %Function used to restructure the data
     [idNotTransmitStruct, collisions] = formatData(nbCol, fixeIdInEachCol, posForEachFixedVeh, idInDifferent, impliedInTheseCol);
    
     %Get the information that these collisions were predicted in the
     %second filtration
     posSecondFilt = [posSecondFilt, i:i + nbCol - 1];
     %Second classifier
     [results] = finalFiltration(nbCol, nbNotTransmis, idNotTransmitStruct, collisions, colDict, muEmiss, sigma2Emiss, scoreJam(p));
     scores(i: i + nbCol-1) = results; 
     nbJammed = [nbJammed sum(results == 1)];
     numbColAnalyze = [numbColAnalyze nbCol];

   end 
   i = i + nbCol;
end

%end

