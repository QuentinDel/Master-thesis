function [ col ] = collision_positions( detect)
%CREATE_WINDOW Summary of this function goes here
%   Detailed explanation goes here
%   pos is the position of query's first symbol in the stream

packet_size=40;
pat= 2*ones(1,packet_size);
col=strfind(detect,pat);

% end  
 

end

