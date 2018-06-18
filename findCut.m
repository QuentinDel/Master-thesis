function [idImpliedInEachCol, posForEachVeh, idImpliedInDifferentCol, impliedInCol, periodIdNotTransmit, periodImplied, maxNb] = ...
            findCut(indiceCol, positionsCol, periodIdNotTransmit, periodSlot, intervTransmiss, shift)

idImpliedInDifferentCol = [];
idImpliedToRemove = [];
idImpliedInEachCol = {};
posForEachVeh = {};
impliedInCol = {};
numCol = shift;
pos = positionsCol(indiceCol);
periodImplied = (pos - mod(pos,periodSlot)) / periodSlot + 1;
pos = pos - (periodImplied - 1) * periodSlot;
idImpliedThisCol = [];
posColIdImplied = [];
maxNb = 0;


for i = -1 : 1
  if periodImplied + i >= 1 && periodImplied + i <= size(periodIdNotTransmit, 1)
     %Obtain all the id possible for that transmission
     idImplied = findIdImplied(periodIdNotTransmit{periodImplied + i}, (periodSlot * -i) + pos, intervTransmiss);
     
     %Remove from the periodIdNotTransmit
     arr = periodIdNotTransmit{periodImplied + i};
     arr(ismember(arr, idImplied)) = [];
     %periodIdNotTransmit{periodImplied + i} = arr;
     
     %Check if vehicle is not implied in an other coll
     for j = 1 : length(idImplied)
       [nb, dist, arr] = checkWhereElseIsImpliedId(idImplied(j), periodImplied + i, indiceCol + 1, positionsCol, periodSlot, intervTransmiss, periodImplied, arr);
       %Set the id as implicated in more than one collisions
       if nb == -1
           idImpliedToRemove = [idImpliedToRemove, idImplied(j)];
       elseif nb > 0
            idImpliedInDifferentCol = [idImpliedInDifferentCol idImplied(j)];
            impliedInCol{end + 1} = cell(2, 1);
            %Set the nb of colisions
            impliedInCol{end}{1} = shift : shift + nb;
            impliedInCol{end}{2} = [(periodSlot * -i) + pos, dist];
            if nb > maxNb
               maxNb = nb;
            end
       end

     end
     %Remove idImplied that appears in more than one coll. or is assigned to the next detection period 
     idImplied(ismember(idImplied, idImpliedInDifferentCol) == 1) = [];
     idImplied(ismember(idImplied, idImpliedToRemove) == 1) = [];
     
     idImpliedThisCol = [idImpliedThisCol, idImplied];
     posColIdImplied = [posColIdImplied, ((periodSlot * -i) + pos) * ones(size(idImplied))];
  end
end

periodIdNotTransmit{periodImplied + i} = arr;
idImpliedInEachCol = {idImpliedThisCol};
posForEachVeh = {posColIdImplied};

i = 1;
while i <= maxNb
    [idImpliedEachColSec, posForEachVehBis, idImpliedInDifferentSec, impliedInDiffColSec, periodIdNotTransmit,~, maxNbBis] = ...
        findCut(indiceCol + i, positionsCol, periodIdNotTransmit, periodSlot, intervTransmiss, shift + i);
    idImpliedInEachCol = [idImpliedInEachCol, idImpliedEachColSec];
    posForEachVeh = [posForEachVeh, posForEachVehBis];
    %idImpliedInEachCol = mergeIdImplied(idImpliedInEachCol, idImpliedEachColSec, i);
    idImpliedInDifferentCol = [idImpliedInDifferentCol , idImpliedInDifferentSec];
    impliedInCol = [impliedInCol, impliedInDiffColSec];
    i = i + 1 + maxNbBis;
end
end

function [nb, dist, arr] = checkWhereElseIsImpliedId(id, periodImplied, indiceCol, positionsCol, periodSlot, intervTransmiss, periodCurrentDetect, arr)
nb = 0;
dist = [];
if indiceCol <= length(positionsCol)
    pos = positionsCol(indiceCol);
    periodImpliedNewCol = (pos - mod(pos,periodSlot)) / periodSlot + 1;
    pos = pos - (periodImplied - 1) * periodSlot;
    
    %If considered as involved in the collision
    if intervTransmiss(id, 1) < pos && pos < intervTransmiss(id, 2)     
       %If we consider that the new collision is in the next period: need
       %to stop here.
       if periodImpliedNewCol == periodCurrentDetect+1 %Case where it is in the next detection period, need to cut here.
           
           posPrev = positionsCol(indiceCol - 1); 
           posPrev = posPrev - (periodImplied - 1) * periodSlot;
           mu = (intervTransmiss(id, 1) + intervTransmiss(id, 2))/2;   
           %Case of veh closer for next period
           if abs(mu - posPrev) >= abs(mu-pos)
               nb = -1;
               arr = [id arr];
           end
           %Anyway return, other case consists of doing nothing
           return;
       end
       
       [nb, distBis, arr] = checkWhereElseIsImpliedId(id, periodImplied, indiceCol + 1, positionsCol, periodSlot, intervTransmiss, periodCurrentDetect, arr);
       if nb ~= -1
           nb = nb + 1;
           dist = pos;
           dist = [dist, distBis];
       end
    end
end

end