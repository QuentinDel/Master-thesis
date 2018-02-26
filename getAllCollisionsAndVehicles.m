function [nbCol, idVehicles] = getAllPossibColl(periodIdNotTransmit, periodImplied, pos, indCol, posCol, periodSlot, intervTransmiss)

pos = pos - (periodImplied - 1) * periodSlot;

if periodImplied > 1
    prevPerIdImplied = findIdImplied(periodIdNotTransmit{periodImplied - 1}, periodSlot + pos, intervTransmiss);
end

thisPeriodIdImplied = findIdImplied(periodIdNotTransmit{periodImplied}, pos, intervTransmiss);


if periodImplied + 1 <= size(periodIdNotTransmit, 1)
    nextPerIdImplied = findIdImplied(periodIdNotTransmit{periodImplied + 1}, periodSlot - pos, intervTransmiss);
end


end

