function [idImpliedInEachCol, idImpliedInDifferentCol, impliedInCol, periodIdNotTransmit, periodImplied, maxNb] = ...
            findCut(indiceCol, positionsCol, periodIdNotTransmit, periodSlot, intervTransmiss, shift)

idImpliedInDifferentCol = [];
idImpliedInEachCol = {};
impliedInCol = {};
numCol = shift;
pos = positionsCol(indiceCol);
periodImplied = (pos - mod(pos,periodSlot)) / periodSlot + 1;
pos = pos - (periodImplied - 1) * periodSlot;
idImpliedThisCol = [];
maxNb = 0;

for i = -1 : 1
  if periodImplied + i >= 1 && periodImplied + i < size(periodIdNotTransmit, 1)
     %Obtain all the id possible for that transmission
     idImplied = findIdImplied(periodIdNotTransmit{periodImplied + i}, (periodSlot * -i) + pos, intervTransmiss);
     
     %Remove from the periodIdNotTransmit
     arr = periodIdNotTransmit{periodImplied + i};
     arr(ismember(arr, idImplied)) = [];
     periodIdNotTransmit{periodImplied + i} = arr;
     
     %Check if vehicle is not implied in an other coll
     for j = 1 : length(idImplied)
       [nb] = checkWhereElseIsImpliedId(idImplied(j), periodImplied + i, indiceCol + 1, positionsCol, periodSlot, intervTransmiss);
       %Set the id as implicated in more than one collisions
       if nb > 0
            idImpliedInDifferentCol = [idImpliedInDifferentCol idImplied(j)];
            %Set the nb of colisions
            impliedInCol{end + 1} = {shift : shift + nb};
            if nb > maxNb
               maxNb = nb;
            end
       end
       
     end
     idImplied(ismember(idImplied, idImpliedInDifferentCol) == 1) = [];
     idImpliedThisCol = [idImpliedThisCol, idImplied];
  end
end

idImpliedInEachCol = {idImpliedThisCol};

i = 1;
while i <= maxNb
    [idImpliedEachColSec, idImpliedInDifferentSec, impliedInDiffColSec, periodIdNotTransmit,~, maxNbBis] = ...
        findCut(indiceCol + i, positionsCol, periodIdNotTransmit, periodSlot, intervTransmiss, shift + i);
    idImpliedInEachCol = [idImpliedInEachCol, idImpliedEachColSec];
    %idImpliedInEachCol = mergeIdImplied(idImpliedInEachCol, idImpliedEachColSec, i);
    idImpliedInDifferentCol = [idImpliedInDifferentCol , idImpliedInDifferentSec];
    impliedInCol = [impliedInCol, impliedInDiffColSec];
    i = i + 1 + maxNbBis;
end

end

function [nb] = checkWhereElseIsImpliedId(id, periodImplied, indiceCol, positionsCol, periodSlot, intervTransmiss)
nb = 0;
if indiceCol <= length(positionsCol)
    pos = positionsCol(indiceCol);
    pos = pos - (periodImplied - 1) * periodSlot;
    if intervTransmiss(id, 1) < pos && pos < intervTransmiss(id, 2)
       nb = 1 + checkWhereElseIsImpliedId(id, periodImplied, indiceCol + 1, positionsCol, periodSlot, intervTransmiss);
    end
end

end


% function idImpliedInEachCol = mergeIdImplied(idImpliedInEachCol, idImpliedEachColSec, i)
% celldisp(idImpliedInEachCol)
% celldisp(idImpliedEachColSec)
% firstPart = idImpliedInEachCol(1:i);
% l1 = size(idImpliedInEachCol, 2)
% l2 = size(idImpliedEachColSec, 2)
% lengthLastPart = l1 - l2 - i
% 
% if lengthLastPart < 0
%    lastPart = idImpliedInEachCol(l1 + lengthLastPart : end);
%    middlePart1 = idImpliedInEachCol(i : l1 + lengthLastPart - 1); 
%    middlePart2 = idImpliedEachColSec;
% elseif lengthLastPart > 0
%    lastPart = idImpliedEachColSec(l2 - lengthLastPart : end); 
%    middlePart1 = idImpliedInEachCol(i : end);
%    middlePart2 = idImpliedEachColSec(1 : l2 - lengthLastPart - 1);
% else
%    lastPart = {};
%    middlePart1 = idImpliedInEachCol(i + 1: end);
%    middlePart2 = idImpliedEachColSec;
% end
% 
% middlePart = cell(size(middlePart1, 2), 1);
% for i = 1 : size(middlePart1, 2)
%    middlePart{i} = [middlePart1{i} middlePart2{i}]; 
% end
% 
% 
% idImpliedInEachCol = [firstPart middlePart lastPart];
% 
% end