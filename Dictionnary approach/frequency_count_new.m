function [HD] = frequency_count_new(database )

% Count the number of time each row is present in the dictionary. Used for
% compression purposes. 


uni = unique(database,'rows');


database = sortrows(database);
len_d=length(database(:,1)); %number of rows in the database
len_u=length(uni(:,1));
HD=zeros(length(uni(:,1)),1);


c=1;
c_pr=0;
for i=1:len_u
 query= uni(i,:);
    while (c<=len_d)&&(isequal(query,database(c,:)))
        c=c+1;   
    end
    HD(i)=c-1-c_pr;
    c_pr=c-1;
end


    


end

