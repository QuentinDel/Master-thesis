function [ anomaly ] = eucl_dist_metric_uni( database_u, counter, query, nb_neighbors ) %, pos)
%CREATE_WINDOW Summary of this function goes here
%   Detailed explanation goes here
%   pos is the position of query's first symbol in the stream
% warning off
m=nb_neighbors; %m nearest neighbor. How many nearest neoghbors to take into account when calculating anomaly score

len=length(database_u(:,1)); %number of rows in the database_u 


DIST=single(zeros(len,1));


for i=1:len%len_n
    DIST(i,1)=norm(single(database_u(i,:) - query));

end

[DIST_s, ind]=sort(DIST);
counter_s=counter(ind);

c=1;
n=0;
while n<m
    n=n+counter_s(c);
    c=c+1;
end
c=c-1;

anomaly=sum(counter_s(1:c-1).*DIST_s(1:c-1));
anomaly=(anomaly+DIST_s(c)*(m-sum(counter_s(1:c-1))) )/m;
 
end

