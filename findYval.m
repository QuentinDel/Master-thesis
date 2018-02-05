function [Yval] = findYval(detect, detect_init, training_part)

detect = detect(training_part + 1: end);
detect_init = detect_init(training_part + 1 : end);

colPositionJam = collision_positions(detect, -1);
colPosition = collision_positions(detect_init, -1);

Yval = ~ismember(colPositionJam, colPosition);

end


%Use with -2
%training_part = round(length(detect_init)*(3/4));
% jamPosition = collision_positions(detect,-2);
% detect(detect == -2) = -1;
% colPositions = collision_positions(detect, -1);
% Yval = ismember(colPositions, jamPosition);
% Yval = Yval(6:end).';