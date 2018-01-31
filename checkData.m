path = 'Data/2017_01_19/';
datasetNames = dir(strcat(path, '*.mat'));
idCrossDataset = 1;
problem = [];
nbTransm = [];

for i = idCrossDataset : idCrossDataset
    
   data = load(strcat(path, datasetNames(i).name)); 
   n = length(data.detect);
   slotTime = data.seconds / n;
   f = 1 / data.beaconing_period;
   periodSlot = round(1 / (f * slotTime));
   
   detect_init = [data.detect , zeros(1, periodSlot * f * data.seconds - n)];
   periods = reshape(detect_init, periodSlot, data.seconds * f);
   count = 0;
   for j = 1 : size(periods,2)
      period = periods(:, j); 
      
      if sum(period == -1) == 0
         if sum(period > 0)/40 ~= data.N
             for k = 1 : data.N
                if sum(period == k) > 40
                    fprintf('Multiple transmissions of same vehicle in T in DS: %d\nVehicles nb: %d\n', i, k);
                    break;
                end
                 
             end
             fprintf('Car transmit in other period or other problem in dataset %d\n', i);
             problem = [problem ; period];
         
         end
         
      else
          if sum(period > 0)/40 == 24
             count = count + 1; 
              
          end
          nbTransm = [nbTransm, sum(period < 0)/40];
          %problem = [problem ; period];

      end
       
       
   end
    
    
end