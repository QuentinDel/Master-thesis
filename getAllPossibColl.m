function [idVehicles] = getAllPossibColl(periodIdNotTransmit, periodImplied, pos, periodSlot, intervTransmiss)

idVehicles = [];
pos = pos - (periodImplied - 1) * periodSlot;


if periodImplied > 1
    prevPerIdImplied = findIdImplied(periodIdNotTransmit{periodImplied - 1}, periodSlot + pos, intervTransmiss);
    idVehicles = [idVehicles, prevPerIdImplied];
end

thisPeriodIdImplied = findIdImplied(periodIdNotTransmit{periodImplied}, pos, intervTransmiss);
idVehicles = [idVehicles, thisPeriodIdImplied];

if periodImplied + 1 <= size(periodIdNotTransmit, 1)
    nextPerIdImplied = findIdImplied(periodIdNotTransmit{periodImplied + 1}, periodSlot - pos, intervTransmiss);
    idVehicles = [idVehicles, nextPerIdImplied];
end

end

