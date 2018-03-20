function [idImplied] = findIdImplied(idNotTransmit, pos, intervTransmiss)
%Check the vehicle that may be implied in the collision at posistion pos
idImplied = [];

for i = 1 : length(idNotTransmit)
    id = idNotTransmit(i);
    if intervTransmiss(id, 1) < pos && pos < intervTransmiss(id, 2)
       idImplied =  [idImplied, id];
    end
end
end

