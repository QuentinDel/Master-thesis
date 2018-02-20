function [idNotTransmit, timeTransmit] = extractPeriods(data)

%Obtain the length of a period in slots
n = length(data.detect_init);
sizeCol = 40;
slotTime = data.seconds / n;
f = 1 / data.beaconing_period;
periodSlot = round(1 / (f * slotTime));

%Obtain the training part as a multiple of the period
training_part = round(length(data.detect_init)*(3/4));
training_part = training_part + periodSlot - mod(training_part, periodSlot);

%Cut the dataset to obtain only the training part
dataset = data.detect_init(1 : training_part);
nbPeriods = training_part / periodSlot;
periods = reshape(dataset, periodSlot, nbPeriods);

%First contain who not transmit
%   second nb of collisions
%   third positions of the coll
periodsInfo = cells(nbPeriods, 1);

%Init each array cells
for i = 1 : nbPeriods
   periodsInfo{i, 1} = 1 : data.N;
end


for i = 1 : nbPeriods
   period = periods(:, i);
   j = 1;
   while j <= periodSlot
       posId = find(period(j:end) ~= 0, 1);
       if ~isempty(posId)
        id = period(j + posId);
        
        if id ~= -1
            periodsInfo = findClosestToRemove(periodsInfo, i, id);
        else
            
        end
        j = j + posId + sizeCol; 
       else
         break;  
       end
       
   end
   
   
    
end


end

