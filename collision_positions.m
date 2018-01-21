function [ col ] = collision_positions( detect, val)
% Get the positions of emissions from "val"

packet_size=40;
pat= val*ones(1,packet_size);
col=strfind(detect,pat);
end

