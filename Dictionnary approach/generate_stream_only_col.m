function [thresh, F1] = generate_stream_only_col(window_size, nb_neighbors, dataset)
tic
path = '../Data/2017_01_19/';
datasetNames = dir(strcat(path, '*.mat'));
dataset = load(strcat(path, datasetNames(dataset).name)); % load historic data
detect_init = dataset.detect_init;
detect = dataset.detect;

detect_init(detect_init > 0) = 1;
detect_init(detect_init < 0) = 2;
detect(detect > 0) = 1;
detect(detect < 0) = 2;


k=window_size; %window length for the anomaly detection

training_part = round(length(detect_init)*(3/4)); % get the length of the stream  which is not subject to jamming (3/4 of the data). This is the length of the training data.
stream=int8(detect_init(1,1:training_part)); % get the part of the data which is not subject to jamming. This is our training data. Convert to int8 in order to speed up the code

database= create_window_collisions( stream, k ); % create a dictionary of windows for anomaly detection
%len_d=length(database(:,1)); % get length of the dictionary

database_u = unique(database,'rows'); % find unique rows in the dictionary
counter = frequency_count_new(database); % count the number of each unique row in the dictionary


stream_dos=int8(detect); % convert data with jamming into int 8
database_dos= create_window_collisions( stream_dos, k ); % create a dictionary of windows for data with jamming
len_dd=length(database_dos(:,1)); % get length of the dictionary


EU=zeros(1,len_dd); % used to store anomaly score (Euclidean distance) for the original data without jamming
EU_dos=zeros(1,len_dd); % used to store anomaly score (Euclidean distance) for the data with jamming

[ window_dos ] = collision_positions(detect); % calculates starting positions of each collision in  the data with jamming
UE_dos=zeros(1,length(window_dos)); % also store anomaly scores

for i=1:length(window_dos)   
    query_d=database_dos(i,:); % take ith window from the jamming database
    UE_dos(1,i)=eucl_dist_metric_uni( database_u, counter, query_d, nb_neighbors ); % calculate Euclidean distance (anomaly score) with the database for the training data without collisions    
end

for j = 1:length(window_dos)
    EU_dos(1,window_dos(j)) = UE_dos(1,j); % assing the calculated anomaly score to actual position of collision in the data
end


database_init= create_window_collisions( int8(detect_init), k ); % create a dictionary of windows for full original data without jamming
[ window] = collision_positions(detect_init); % calculates starting positions of each collision in  the original data without jamming
UE=zeros(1,length(window)); % intialize for storing anomaly scores

for i=1:length(window)
    % disp(i)
    query=database_init(i,:); % take ith window from the  database
    UE(1,i)=eucl_dist_metric_uni( database_u, counter, query, nb_neighbors ); % calculate anomaly score    
end

for j = 1:length(window)
    EU(1,window(j)) = UE(1,j);  % assing the calculated anomaly score to actual position of collision in the data
end

% Display anaomaly scores and the data
% figure()
% subplot(4,1,1)
% plot(detect_init) % data without jamming
% subplot(4,1,2)
% plot(EU) % anomaly scores in the case without jamming
% subplot(4,1,3)
% plot(EU_dos) % anomaly scores in the case with jamming
% subplot(4,1,4)
% plot(detect-detect_init) % positions of collisions caused by jamming

[thresh, F1] = get_detection_accuracy_collisions(UE_dos, detect_init, detect, training_part); % This script calculates the effect of setting different threhsolds for anomy score for classifiying a collision as anomaly or not
toc

