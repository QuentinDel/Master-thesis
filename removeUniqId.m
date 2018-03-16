function collisions = removeUniqId(uniqId, collisions)
    for i = 1 : size(collisions, 1)
       index = find(collisions{i}.uniqIds == uniqId);
       if isempty(index)
          break
       else
           collisions{i}.uniqIds(index) = [];
           collisions{i}.idsImplied(index) = [];
       end
    end
end