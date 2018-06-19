fprintf('\n----------- Results dataset %d -----------\n', o);

%             fprintf('Parameters:\n');
%             fprintf('\tScore for jammed collisions: %d\n', scoreJam(p));
%             fprintf('\tSecurity coefficient: %d\n', coefSafety(q));
fprintf('Collisions predicted correctly: %d/%d\n', sum(yval == scores),  sum(scores > -1));
fprintf('Set of dependent collisions without min. veh. implied: %d\n', nbWithoutMinVehReq);
fprintf('\tFirst filtration: %d/%d\n', sum(yval(posFirstFilt) == scores(posFirstFilt)), length(posFirstFilt));
fprintf('\tSecond filtration: %d/%d\n', sum(yval(posSecondFilt) == scores(posSecondFilt)), length(posSecondFilt));
fprintf('\tNumber of good prediction of number of jammed collisions in a sdc: %d/%d\n', nbJamCorrectGuessed, length(numbColAnalyze));

fprintf('\tNumber of predicted jammed collisions: %d/%d\n', sum(scores == 1), sum(yval == 1));
fprintf('\tTrue positive: %d\n', tp);
fprintf('\tTrue negative: %d\n', tn);
fprintf('\tFalse positive: %d\n', fp);
fprintf('\tFalse negative: %d\n', fn);

fprintf('\tMCC score: %d\n', mcc);    
fprintf('\tF1 score: %d\n', f1);    

fprintf('Collisions that have been checked: %d/%d\n\n', sum(scores > -1), size(yval, 2));
fprintf('\tCheck number of sdcs on more than one detection period: %d\n', checkSDC);    
