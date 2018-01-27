function [results, thresholds] = bestParameters()

size_windows = 3000 : 500 : 5000;
nb_neighbors = 5 : 5 : 15;
datasets = 4;


results = zeros(datasets, length(size_windows), length(nb_neighbors));
thresholds = zeros(size(results));

for i = 1 : length(size_windows)
   for j = 1 : length(nb_neighbors)
       for k = 1 : datasets
           fprintf('size window %d \n', size_windows(i));
           fprintf('nb neighbors %d \n', nb_neighbors(j));
           fprintf('dataset %d \n', k);
           [thresholds(k, i,j), results(k, i, j)] = generate_stream_only_col(size_windows(i), nb_neighbors(j), k);   
       end
   end
end
 
end