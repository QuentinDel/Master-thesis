function [periodsInfo, transmissionsInfos, training_part, periodSlot, periods, dataset] = extractPeriods(data, isWithJammed)

%Obtain the length of a period in slots
n = length(data.detect);
sizeCol = 40;
slotTime = data.seconds / n;
f = 1 / data.beaconing_period;
periodSlot = round(1 / (f * slotTime));

%Obtain the training part as a multiple of the period
training_part = round(length(data.detect)*(3/4));
training_part = training_part + periodSlot - mod(training_part, periodSlot);

%Cut the dataset to obtain only the training part
if isWithJammed
   dataset = data.detect;
   dataset = [dataset, zeros(1, periodSlot - mod(length(dataset), periodSlot))];
   nbPeriods = length(dataset) / periodSlot;
   nbPeriodsHealthy = nbPeriods - (length(dataset) - training_part) / periodSlot;
else 
   dataset = data.detect(1 : training_part);
   nbPeriods = training_part / periodSlot;
end

periods = reshape(dataset, periodSlot, nbPeriods);

%Feedback: hyperparameters
k = round(2 * data.N / 3);

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

%Init each array
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
   lastView = 0;
   while j <= periodSlot
       posId = find(period(j:end) ~= 0, 1);
       j = j + posId -1;
       if ~isempty(posId)
        id = period(j);
        
        if id ~= -1
            % Up to date the highest last view
            if id > lastView && id <= lastView + k
                lastView = id; 
            end
            [periodsInfo, transmissionsInfos] = findClosestToRemove(periodsInfo, transmissionsInfos, i, j, id, lastView, k, periodSlot);
        else
            lastView = lastView + 1;
        end
        
        j = j + sizeCol + 1; 
       else
         break;  
       end     
   end
end

if isWithJammed
    periods = periods(: ,nbPeriodsHealthy + 1 : end);
    dataset = dataset(training_part + 1 : end);
    periodsInfo = periodsInfo(nbPeriodsHealthy + 1:end);
    transmissionsInfos =  transmissionsInfos(nbPeriodsHealthy + 1:end);
end

end



function [periodsInfo, transmissionsInfos] = findClosestToRemove(periodsInfo, transmissionsInfos, i, transTime, id, lastView, k, periodSlot)
    if id > lastView + k
        [periodsInfo, transmissionsInfos] = backpropagate(periodsInfo, transmissionsInfos, i - 1, id, transTime + periodSlot, periodSlot);
    elseif id < lastView - k && i + 1 <= size(periodsInfo, 1)
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
        transm = transmissionsInfos{i}(id);
        transmissionsInfos{i}(id) = transTime;
        [periodsInfo, transmissionsInfos] = backpropagate(periodsInfo, transmissionsInfos, i - 1, id, transm + periodSlot, periodSlot);
    end
        
end
