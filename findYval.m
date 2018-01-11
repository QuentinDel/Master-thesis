function [ Yval ] = findYval( detect, detect_init)

training_part = round(length(detect_init)*(3/4));
colPositionJam = collision_positions(detect, -1);
Yval = colPositionJam >= training_part;
%colPosition = collision_positions(detect_init,2);
%Yval = ismember(colPositionJam, colPosition);
Yval = Yval(6:end).';
end

