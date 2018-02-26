function [idImplied] = findIdImplied(idNotTransmit, pos, intervTransmiss)
idImplied = [];
%pos
%idNotTransmit

for i = 1 : length(idNotTransmit)
    id = idNotTransmit(i);
    if intervTransmiss(id, 1) < pos && pos < intervTransmiss(id, 2)
       idImplied =  [idImplied, id];
    end
end
%idImplied
end

