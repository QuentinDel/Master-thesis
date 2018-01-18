function [Yval] = findYval( detect)

%training_part = round(length(detect_init)*(3/4));
jamPosition = collision_positions(detect,-2);
detect(detect == -2) = -1;
colPositions = collision_positions(detect, -1);
Yval = ismember(colPositions, jamPosition);
Yval = Yval(6:end).';

% training_part = round(length(detect_init)*(3/4));
% colPositionJam = collision_positions(detect, -1);
% Yval = colPositionJam >= training_part;
% %colPosition = collision_positions(detect_init,2);
% %Yval = ismember(colPositionJam, colPosition);
% Yval = Yval(6:end).';
end

