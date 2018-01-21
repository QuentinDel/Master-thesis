function [Yval] = findYval(detect, detect_init, numberOfCollisionsInPast)

training_part = round(length(detect_init)*(3/4));
colPositionJam = collision_positions(detect, -1);
%colPosition = collision_positions(detect_init, -1);
Yval = colPositionJam >= training_part;

%Yval = ~ismember(colPositionJam, colPosition);
%Yval = colPositionJam >= training_part;

Yval = Yval(numberOfCollisionsInPast + 1 : end).';

end


%Use with -2
%training_part = round(length(detect_init)*(3/4));
% jamPosition = collision_positions(detect,-2);
% detect(detect == -2) = -1;
% colPositions = collision_positions(detect, -1);
% Yval = ismember(colPositions, jamPosition);
% Yval = Yval(6:end).';