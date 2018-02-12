function [resultsAllGood, scoreAllGood] = findMostProbablyHealthyCol(idNotTransmit, nbNotTransmis, nbCol, colDict)

highestNbVehCol = nbNotTransmis + 1 - 2 * nbCol ;
allPossibleCol = {[0,0]};

%Generate all possible combinations
for i = 1 : highestNbVehCol
   allComb = num2cell(nchoosek(idNotTransmit, i + 1), 2);
   allPossibleCol = [allPossibleCol; allComb];
end

%Remove all not possible collisions
allPossibleCol = cellfun(@(x) removeBadCol(x, colDict), allPossibleCol, 'UniformOutput', false);
allPossibleCol = allPossibleCol(~cellfun('isempty', allPossibleCol));

[~, scoreAllGood] = findPossibleConfig([], nbNotTransmis, allPossibleCol, nbCol, colDict);
resultsAllGood = zeros(nbCol, 1);

end


function [res] = removeBadCol(x, colDict)
    res = x;
    key = num2str(x);
    if ~isKey(colDict, key)
        res = [];
    end
end
    


function [bestConfigs, scoreMax] = findPossibleConfig(idAlreadyUsed, nbIdLeft, colToCheck, nbColLeft, colDict)

%Init default results values
scoreMax = 0;
bestConfigs = [];

for i = 1 : size(colToCheck, 1)
    colId = colToCheck{i};
    score = 0;
    
    if nbColLeft > 1 || (nbColLeft == 1 && size(colId, 2) == nbIdLeft) && ... %Check que la taille est bonne
            sum(ismember(idAlreadyUsed, colId)) == 0                          %Check qu'on utilise que des inutilisés
        
        
        %Case where still need to complete config
        if nbColLeft ~= 1 
            scoreB = 0;
            %Only keep going if they are still some collisions to check
            if i ~= size(colToCheck, 1)
              [bestConfigsB, scoreB] = findPossibleConfig([idAlreadyUsed, colId], nbIdLeft - size(colId, 2), colToCheck(i + 1 : end), nbColLeft - 1, colDict);
            end
            if scoreB ~= 0
               score = scoreB + colDict(num2str(colId));
            end              
        %Case it is the last collision of sequence
        else
            score = colDict(num2str(colId));
            bestConfigsB = [];
        end              
    end
    
    if score > scoreMax
       scoreMax = score;
       bestConfigs = [{colId} ; bestConfigsB];
    end
end
end
