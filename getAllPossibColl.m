function [idVehicles] = getAllPossibColl(periodIdNotTransmit, periodImplied, pos, periodSlot, intervTransmiss)

idVehicles = [];
pos = pos - (periodImplied - 1) * periodSlot;

for i = -1 : 1
  if periodImplied + i >= 1 && periodImplied + i < size(periodIdNotTransmit, 1)
     IdImplied = findIdImplied(periodIdNotTransmit{periodImplied + i}, (periodSlot * -i) + pos, intervTransmiss);
     idVehicles = [idVehicles, IdImplied];
  end
end

end

