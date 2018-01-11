function [ database ] = create_window_collisions( stream, k )
%CREATE_WINDOW Summary of this function goes here
%   Detailed explanation goes here

%k - length of the window
%stream - training data

packet_size=40; % size of each packet and collision
pat= 2*ones(1,packet_size); % create a pattern of collision to find in in the training data
col=strfind(stream,pat); % find position of each collision in the data

database=int8(zeros(length(col),k)); % initialize a dictionary
for i=1:length(col)
    database(i,:)=stream(  col(i)-k : col(i)-1   ); % store k slots of data before ith collision 
end

end

