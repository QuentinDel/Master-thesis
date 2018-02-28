function [vehiclesGroup, score] = secondFiltrationBis(idImpliedInEachCol, idImpliedInDifferent, impliedInTheseCol, nbCol, colDict, idCol)
%nbCol
%idCol
%celldisp(idImpliedInEachCol)
fixedVehiclesForThisCollision = idImpliedInEachCol{idCol};
idPossible = [];

if ~isempty(impliedInTheseCol)
    possibleForThis = cellfun(@(x) ismember(idCol, x{1}), impliedInTheseCol);
    idPossible = idImpliedInDifferent(possibleForThis == 1);
end

%Case where no vehicles is implied in one collision
if isempty(fixedVehiclesForThisCollision) && isempty(idPossible)
    score = -1;
    vehiclesGroup = {};
    
%Case where it is the last collision
elseif idCol == nbCol
    score = getScore([fixedVehiclesForThisCollision, idPossible], colDict, 0);
    vehiclesGroup = {[fixedVehiclesForThisCollision, idPossible]};
    
else
    if ~isempty(idPossible)
        idVehicleToManage = idPossible(1);        
        %idVehicleToManage
        %Take the id into account
        idImpliedInEachColOpt1 = idImpliedInEachCol;
        idImpliedInEachColOpt1{idCol} = [fixedVehiclesForThisCollision idVehicleToManage];
        idImpliedInDifferentOpt1 = idImpliedInDifferent;
        idImpliedInDifferentOpt1(1) = [];
        impliedInTheseColOpt1 = impliedInTheseCol;
        position = find(possibleForThis == 1, 1);
        impliedInTheseColOpt1(position) = [];
        [vehiclesGroup, score] = secondFiltrationBis(idImpliedInEachColOpt1, idImpliedInDifferentOpt1, impliedInTheseColOpt1, nbCol, colDict, idCol);
        
        %Don't add this into this collision but in a next one if possible
        %idCol
        %impliedInTheseCol{position}{1}
        %~isempty(find(impliedInTheseCol{position}{1} > idCol, 1))
        if ~isempty(find(impliedInTheseCol{position}{1} > idCol, 1))
            [vehiclesGroupOpt2, scoreOpt2] = secondFiltrationBis(idImpliedInEachCol, idImpliedInDifferent, impliedInTheseCol, nbCol, colDict, idCol + 1);
            scoreOpt2 = getScore(fixedVehiclesForThisCollision, colDict, scoreOpt2);            
            if scoreOpt2 > score
                score = scoreOpt2;
                vehiclesGroup = [{fixedVehiclesForThisCollision} vehiclesGroupOpt2];
            end
        end
        
    else       
       [vehiclesGroup, scoreOpt3] = secondFiltrationBis(idImpliedInEachCol, idImpliedInDifferent, impliedInTheseCol, nbCol, colDict, idCol + 1);
       score = getScore(fixedVehiclesForThisCollision, colDict, scoreOpt3);
       vehiclesGroup = [{fixedVehiclesForThisCollision} vehiclesGroup];

    end
    
    
end


end


function score = getScore(idNotTransmit, colDict, secondScore)
valueToCol = 0;
key = num2str(idNotTransmit);
if secondScore == -1 || isempty(idNotTransmit)
    score = -1;
else
    score = 0;
    if length(idNotTransmit) == 1
        score = valueToCol;
    elseif isKey(colDict, key)
        score = colDict(key);
    end
end
end


