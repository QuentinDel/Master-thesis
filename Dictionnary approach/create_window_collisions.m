function [ database ] = create_window_collisions( stream, k )
%CREATE_WINDOW Summary of this function goes here
%   Detailed explanation goes here

%k - length of the window
%stream - training data

[ col ] = collision_positions(stream);

database=int8(zeros(length(col),k)); % initialize a dictionary
for i=1:length(col)
    if col(i)-k > 0
        database(i,:)=stream(  col(i)-k : col(i)-1   ); % store k slots of data before ith collision 
    else
        database = database(2:end, :);
    end
end

end

