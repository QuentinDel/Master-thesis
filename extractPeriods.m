function [periodsInfo, transmissionsInfos, training_part, periodSlot, periods, dataset] = extractPeriods(data, isWithJammed, timeForTraining)
%Input: 
%   -data: struct with different 
%   -isWithJammed: boolean to say if it with the training or test dataset


%Obtain the length of a period in slots
n = length(data.detect);
sizeCol = 40;
slotTime = data.seconds / n;
f = 1 / data.beaconing_period;
periodSlot = round(1 / (f * slotTime));

%Obtain the training part as a multiple of the period
training_part = round(length(data.detect)*(3/4));
training_part = training_part + periodSlot - mod(training_part, periodSlot);

%Cut the dataset to obtain either the training part or the test part
if isWithJammed
   dataset = data.detect;
   dataset = [dataset, zeros(1, periodSlot - mod(length(dataset), periodSlot))];
   nbPeriods = length(dataset) / periodSlot;
   nbPeriodsHealthy = nbPeriods - (length(dataset) - training_part) / periodSlot;
else  
%   trainingPart = timeForTraining + periodSlot - mod(timeForTraining, periodSlot);
%   dataset = data.detect(1 : trainingPart);
%   nbPeriods = trainingPart / periodSlot;
    dataset = data.detect(1 : training_part);
    %nbNaturalTraining = sum(dataset == -1) /40
    nbPeriods = training_part / periodSlot;
end
periods = reshape(dataset, periodSlot, nbPeriods);

%Feedback: hyperparameters
k = round(data.N / 2);
%k = round(data.N /);
%k = 4;

%First contain who not transmit
%   second nb of collisions
%   third positions of the coll
periodsInfo = cell(nbPeriods, 1);
transmissionsInfos = cell(nbPeriods, 1);

%Init each array cells
for i = 1 : nbPeriods
   periodsInfo{i} = 1 : data.N;
   transmissionsInfos{i} = inf * ones(data.N, 1);
end

% The id is to have some labeled vehicles in order to have for example the
% vehicle labelled 1 if he transmits most of the time before vehicle
% labelled 2
for i = 1 : nbPeriods
   period = periods(:, i);
   
   %Manage case where transmission on two periods
   if period(1) ~= 0
      id = period(1);
      if sum(period(1:sizeCol) == id) < sizeCol
        period(period(1:sizeCol) == id)= 0;
      end
   end
   
   j = 1;
   lastView = 0; %lastView is used to get the latest id of vehicle that transmitted
   while j <= periodSlot %check slot after slot for the all period
       
       posId = find(period(j:end) ~= 0, 1); %find the next slot with id different than 0
       j = j + posId -1;   %align the cursor on it to obtain the id
       if ~isempty(posId)
        id = period(j);
        
        if id ~= -1
            % Up to date the highest last view
            if id > lastView && id <= lastView + k
                lastView = id; 
            end
            [periodsInfo, transmissionsInfos] = findClosestToRemove(periodsInfo, transmissionsInfos, i, j, id, lastView, k, periodSlot);
        else %Case of collision, we say that the lastView is +1
            lastView = lastView + 1;
        end
        
        j = j + sizeCol + 1; 
       else
         break;  
       end     
   end
end

%Only keep the last quarter to analyze.
if isWithJammed
    periods = periods(: ,nbPeriodsHealthy + 1 : end);
    dataset = dataset(training_part + 1 : end);
    periodsInfo = periodsInfo(nbPeriodsHealthy + 1:end);
    transmissionsInfos =  transmissionsInfos(nbPeriodsHealthy + 1:end);
end

end


%Check in which period the id should be removed from the missing vehicles.
%If the difference from the last viewed vehicles is too big, it means that
%it is certainly an vehicle id from the previous or next period.
function [periodsInfo, transmissionsInfos] = findClosestToRemove(periodsInfo, transmissionsInfos, i, transTime, id, lastView, k, periodSlot)
    if id > lastView + k
        [periodsInfo, transmissionsInfos] = backpropagate(periodsInfo, transmissionsInfos, i - 1, id, transTime + periodSlot, periodSlot);
    elseif id < lastView - k
        if i+1 > size(periodsInfo, 1)
           return 
        end
        [periodsInfo, transmissionsInfos] = backpropagate(periodsInfo, transmissionsInfos, i + 1, id, transTime - periodSlot, periodSlot);
    else
        [periodsInfo, transmissionsInfos] = backpropagate(periodsInfo, transmissionsInfos, i, id, transTime, periodSlot);
    end
    
end

function [periodsInfo, transmissionsInfos] = backpropagate(periodsInfo, transmissionsInfos, i, id, transTime, periodSlot)
    if ismember(id, periodsInfo{i})
        periodsInfo{i}(periodsInfo{i} == id) = [];
        transmissionsInfos{i}(id) = transTime;

    else
        %1
        %Case where it was before -> should not really be used in general
%         1
%         transm = transmissionsInfos{i}(id);
%         transmissionsInfos{i}(id) = transTime;
%         [periodsInfo, transmissionsInfos] = backpropagate(periodsInfo, transmissionsInfos, i - 1, id, transm + periodSlot, periodSlot);
    end
        
end
