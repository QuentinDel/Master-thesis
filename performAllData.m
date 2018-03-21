% Main function used to perform an analyze on each dataset.

%Dataset without jitter
%path = 'Data/2017_01_19/';

%Dataset with jitter
path = 'Data/DATA_2018_02_17/';

datasetNames = dir(strcat(path, '*.mat'));

idCrossDataset = 12;

%scoreJam = [0, 10, 50, 100, 200];
scoreJam = 0;
coefSafety = 0;
%coefSafety = [0, 1, 3, 5, 7, 9, 10];
F1Scores = zeros(length(scoreJam), length(coefSafety), 2);
times = zeros(length(scoreJam), length(coefSafety), 2);

for p = 1 : length(scoreJam)
    for q = 1 : length(coefSafety)
        fprintf('Parameters:\n');
        fprintf('\tScore for jammed collisions: %d\n', scoreJam(p));
        fprintf('\tSecurity coefficient: %d\n', coefSafety(q));
        f1scores = zeros(idCrossDataset, 1);
        tic
        for o = 1 : idCrossDataset    %size(datasetNames, 1)

            data = load(strcat(path, datasetNames(o).name));

            %Correspond to the training part in the report
            [colDict, muEmiss, sigma2Emiss, intervTransmiss, periods, periodIdNotTransmit] = createColDict(data, coefSafety(q));

            %Test part -> obtain scores = predicted values
            performAnalize;

            %Obtain the true value
            yval = findYval(data.detect, data.detect_init, training_part);

            tp = sum(yval == 1 & scores == 1);
            fp = sum(yval == 0 & scores == 1);
            fn = sum(yval == 1 & scores == 0);
            tn = sum(yval == 0 & scores == 0);

            prec = tp / (tp + fp);
            rec = tp / (tp + fn);

            F1 = 2*prec*rec / (prec + rec);
            f1scores(o) = F1;

            nbJamCorrectGuessed = 0;
            i= 1;
            j = 1;
            while i <= length(yval)
                %yval(i: i + numbColAnalyze(j) - 1)
                nbJammedYval = sum(yval(i: i + numbColAnalyze(j) - 1) == 1);
                nbJamCorrectGuessed = nbJamCorrectGuessed + (nbJammed(j) == nbJammedYval);
                i = i+numbColAnalyze(j);
                j = j+1;        
            end

            fprintf('\n----------- Results data set %d -----------\n', o);
            
            fprintf('Parameters:\n');
            fprintf('\tScore for jammed collisions: %d\n', scoreJam(p));
            fprintf('\tSecurity coefficient: %d\n', coefSafety(q));

            fprintf('Collisions predicted correctly: %d/%d\n', sum(yval == scores),  sum(scores > -1));
            fprintf('\tFirst filtration: %d/%d\n', sum(yval(posFirstFilt) == scores(posFirstFilt)), length(posFirstFilt));
            fprintf('\tSecond filtration: %d/%d\n', sum(yval(posSecondFilt) == scores(posSecondFilt)), length(posSecondFilt));
            fprintf('\tNumber of good prediction of number of jammed collisions in a period: %d/%d\n', nbJamCorrectGuessed, length(numbColAnalyze));

            fprintf('\tNumber of predicted jammed collisions: %d/%d\n', sum(scores == 1), sum(yval == 1));
            fprintf('\tTrue positive: %d\n', tp);
            fprintf('\tTrue negative: %d\n', tn);
            fprintf('\tFalse positive: %d\n', fp);
            fprintf('\tFalse negative: %d\n', fn);

            fprintf('\tF1 score: %d\n', F1);    
            fprintf('Collisions that have been checked: %d/%d\n\n', sum(scores > -1), size(yval, 2));

        end
        times(p, q, 1) = toc;
        mean(f1scores)
        var(f1scores)
        times(p, q, 1)
        F1Scores(p, q, 1) = mean(f1scores);
        F1Scores(p, q, 2) = var(f1scores);

    end
end
