% Main function used to perform an analyze on each dataset.

%Dataset without jitter
%path = 'Data/2017_01_19/';

%Dataset with jitter
%path = 'Data/DATA_2018_02_17/'; %25
%path = 'Data/20_vehicles/';
%path = 'Data/15_vehicles/';
%path = 'Data/10_vehicles/';
%path = 'Data/5_vehicles/';

%Dataset ONOFF
%path = 'Data/ONOFF/5_vehicles/';
%path = 'Data/ONOFF/10_vehicles/';
%path = 'Data/ONOFF/15_vehicles/';
%path = 'Data/ONOFF/20_vehicles/';
%path = 'Data/ONOFF/25_vehicles/';

%Exp1 (no jitter)
path = 'Data/DATA_2018_04_06_no_jitter/ONOFF/';


datasetNames = dir(strcat(path, '*.mat'));

idCrossDataset = 10;% size(datasetNames, 1);

%scoreJam = [0, 10, 50, 100, 200];
%coefSafety = [0, 1, 3, 5, 7, 9, 10];
scoreJam = 0;
coefSafety = 0;

slotPERsec=1/13e-6; % number of slots in 1 second
TIME=slotPERsec*100; 

MccScores = zeros(idCrossDataset, size(datasetNames, 1));
goodNbPredict = zeros(idCrossDataset, size(datasetNames, 1), 2);

times = zeros(length(scoreJam), length(coefSafety), length(TIME));

%Use to get in previous structure
data.beaconing_period=1/30;
data.seconds = 150;
tt = 1;
nbVehicles = [10, 15, 20, 25, 5];
for p = 1 : length(scoreJam)
    for q = 1 : length(coefSafety)
    %         fprintf('Parameters:\n');
    %         fprintf('\tScore for jammed collisions: %d\n', scoreJam(p));
    %         fprintf('\tSecurity coefficient: %d\n', coefSafety(q));

        
        for r = 1 : 5%size(datasetNames, 1)
            fprintf('N : %d\n', nbVehicles(r));
            dataToTest = load(strcat(path, datasetNames(r).name));
            fns = fieldnames(dataToTest);

            tic
                for o = 1 : idCrossDataset    %size(datasetNames, 1)
                    %data = load(strcat(path, datasetNames(o).name));
                    data.detect_init = dataToTest.(fns{1})(o).detect_init;
                    data.detect = dataToTest.(fns{1})(o).detect;
                    data.N = nbVehicles(r);
                    %Correspond to the training part in the report
                    [colDict, muEmiss, sigma2Emiss, intervTransmiss, periods, periodIdNotTransmit] = createColDict(data, coefSafety(q), TIME(tt));

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

                    %Compute mcc score
                    square_root=sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn));
                    if (square_root==0)
                        square_root=1;
                    end
                     mcc=((tp*tn)-(fp*fn))/square_root;
                     
                     %Case with not fp
                     if tp == size(yval, 2)
                       mcc = 1;
                     end
                     MccScores(o, mod(r, 5) + 1) = mcc;
                     %MccScores(o, tt) = mcc;
                    
                    

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


        %             fprintf('Parameters:\n');
        %             fprintf('\tScore for jammed collisions: %d\n', scoreJam(p));
        %             fprintf('\tSecurity coefficient: %d\n', coefSafety(q));

                    fprintf('Collisions predicted correctly: %d/%d\n', sum(yval == scores),  sum(scores > -1));
                    fprintf('\tFirst filtration: %d/%d\n', sum(yval(posFirstFilt) == scores(posFirstFilt)), length(posFirstFilt));
                    fprintf('\tSecond filtration: %d/%d\n', sum(yval(posSecondFilt) == scores(posSecondFilt)), length(posSecondFilt));
                    fprintf('\tNumber of good prediction of number of jammed collisions in a period: %d/%d\n', nbJamCorrectGuessed, length(numbColAnalyze));
                    goodNbPredict(o, mod(r,5) + 1, 1) = nbJamCorrectGuessed;
                    goodNbPredict(o, mod(r,5) + 1, 2) = length(numbColAnalyze);

                    fprintf('\tNumber of predicted jammed collisions: %d/%d\n', sum(scores == 1), sum(yval == 1));
                    fprintf('\tTrue positive: %d\n', tp);
                    fprintf('\tTrue negative: %d\n', tn);
                    fprintf('\tFalse positive: %d\n', fp);
                    fprintf('\tFalse negative: %d\n', fn);

                    fprintf('\tMCC score: %d\n', mcc);    
                    fprintf('Collisions that have been checked: %d/%d\n\n', sum(scores > -1), size(yval, 2));
                end
%             times(p, q, tt) = toc;
%             meanMcc = mean(mccscores)
%             varMcc = var(mccscores)^0.5
%             t12 = times(p, q, 1)
%             MccScores(p, q, tt, 1) = mean(mccscores);
%             MccScores(p, q, tt, 2) = var(mccscores);
        end
         

    end
end
