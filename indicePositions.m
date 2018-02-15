function [ col ] = indicePositions( detect, val)
% Get the positions of emissions from "val"

%packet_size=40;
%pat= val*ones(1,packet_size);
pat = [0 val];
col=strfind(detect,pat);
end

