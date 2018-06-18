% Main function used to perform an analyze on each dataset./

%Exp1 (no jitter)
%path = 'Data/DATA_2018_04_06_no_jitter/ONOFF/';

%Exp7 jitter 5ms and 20 ms
%path = 'Data/DATA_2018_05_02_experiment_7/jitter_01/';
%path = 'Data/DATA_2018_05_02_experiment_7/jitter_0025/';

%Different jamming probability
%path = 'Data/DATA_2018_05_14_jamming_probability_0_1/ONOFF/';
%path = 'Data/DATA_2018_05_14_jamming_probability_0_1/random/';

%path = 'Data/DATA_2018_05_14_jamming_probability_0_25/ONOFF/';
%path = 'Data/DATA_2018_05_14_jamming_probability_0_25/random/';

%Exp 9
%path = 'Data/Data/DATA_2018_05_28_experiment_9/var_jitter_l_0025_d_005/';
%path = 'Data/Data/DATA_2018_05_28_experiment_9/var_jitter_l_0025_d_005/seq_all/';
%path = 'Data/Data/DATA_2018_05_28_experiment_9/var_jitter_l_00025_d_0005/';
%path = 'Data/Data/DATA_2018_05_28_experiment_9/var_jitter_l_00025_d_0005/seq_all/';


%EPR:
%path = 'Data/Data/DATA_2018_06_15_PER_0_01_p_jam_0_1/ONOFF/';
%path = 'Data/Data/DATA_2018_06_15_PER_0_01_p_jam_0_1/random/';
%path = 'Data/Data/DATA_2018_06_15_PER_0_1_p_jam_0_1/ONOFF/';
path = 'Data/Data/DATA_2018_06_15_PER_0_1_p_jam_0_1/random/';
%path = 'Data/Data/DATA_2018_06_15_PER_0_05_p_jam_0_1/ONOFF/';
%path = 'Data/Data/DATA_2018_06_15_PER_0_05_p_jam_0_1/random/';
%path = 'Data/Data/DATA_2018_05_25_PER_0_01/ONOFF/';
%path = 'Data/Data/DATA_2018_05_25_PER_0_01/random/';
%path = 'Data/Data/DATA_2018_05_25_PER_0_1/ONOFF/';
%path = 'Data/Data/DATA_2018_05_25_PER_0_1/random/';
%path = 'Data/Data/DATA_2018_05_25_PER_0_05/ONOFF/';
%path = 'Data/Data/DATA_2018_05_25_PER_0_05/random/';


datasetNames = dir(strcat(path, '*.mat'));

idCrossDataset = 10;% size(datasetNames, 1);

%scoreJam = [0, 10, 50, 100, 200];
%coefSafety = [0, 1, 3, 5];
scoreJam = 0;
coefSafety = 0;

slotPERsec=1/13e-6; % number of slots in 1 second
TIME=slotPERsec*100; 

MccScores = zeros(idCrossDataset, size(datasetNames, 1));
F1Scores = zeros(idCrossDataset, size(datasetNames, 1));
TP = zeros(idCrossDataset, size(datasetNames, 1));
TN = zeros(idCrossDataset, size(datasetNames, 1));
FP = zeros(idCrossDataset, size(datasetNames, 1));
FN = zeros(idCrossDataset, size(datasetNames, 1));
goodNbPredict = zeros(idCrossDataset, size(datasetNames, 1), 2);
nbAttacksDetected = zeros(idCrossDataset, size(datasetNames, 1), 2);
ratioGoodNbPredict = zeros(idCrossDataset, size(datasetNames, 1));
ratioNbAttacksDetected = zeros(idCrossDataset, size(datasetNames, 1));
falseAlarmsInfo = zeros(idCrossDataset, size(datasetNames, 3));

%Use to get in previous structure
data.beaconing_period=1/30;
data.seconds = 150;
tt = 1;
nbVehicles = [10, 15, 20, 25, 5];
for p = 1 : length(scoreJam)
    
    for q = 1 : length(coefSafety)
        fprintf('Parameters:\n');
        fprintf('\tScore for jammed collisions: %d\n', scoreJam(p));
        fprintf('\tSecurity coefficient: %d\n', coefSafety(q));

        
        for r = 4 : 4%size(datasetNames, 1)
            fprintf('N : %d\n', nbVehicles(r));
            dataToTest = load(strcat(path, datasetNames(r).name));
            fns = fieldnames(dataToTest);

            tic
                for o = 10 : idCrossDataset    %size(datasetNames, 1)
                    %OTHER DATASETS
                    data.detect_init = dataToTest.(fns{1})(o).detect_init;
                    data.detect = dataToTest.(fns{1})(o).detect;
                    data.N = nbVehicles(r);
                    %Correspond to the training part in the report
                    [colDict, muEmiss, sigma2Emiss, intervTransmiss, periods, periodIdNotTransmit] = createColDict(data, coefSafety(q), TIME(tt));

                    %Test part -> obtain scores = predicted values
                    performAnalize;

                    %Obtain the true value
                    [yval, colPositionJam, colPosition] = findYval(data.detect, data.detect_init, training_part);
                    
                    %nbNaturalDetectionPart = sum(yval == 0)
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
                    f1 = 2*prec*rec / (prec + rec);
                     
                     %Case with not fp
                    if tp == size(yval, 2)
                      mcc = 1;
                    end
                    MccScores(o, mod(r, 5) + 1) = mcc;
                    F1Scores(o, mod(r, 5) + 1) = f1;
                    TP(o, mod(r, 5) + 1) = tp;
                    FP(o, mod(r, 5) + 1) = fp;
                    FN(o, mod(r, 5) + 1) = fn;
                    TN(o, mod(r, 5) + 1) = tn;         
                    
                    %errorsInformation;
                    nbJamCorrectGuessed = 0;
                    attackDetectedOnSDC = 0;
                    falseAlarms = 0;
                    i= 1;
                    j = 1;
                    
                    while i <= length(yval)
                        %yval(i: i + numbColAnalyze(j) - 1)
                        nbJammedYval = sum(yval(i: i + numbColAnalyze(j) - 1) == 1);
                        nbJamCorrectGuessed = nbJamCorrectGuessed + (nbJammed(j) == nbJammedYval);
                        attackDetectedOnSDC = attackDetectedOnSDC + ((nbJammed(j) > 0) == (nbJammedYval > 0));
                        falseAlarms = falseAlarms + ((nbJammed(j) > 0) & (nbJammedYval == 0));
                        %nbJammed(j) == nbJammedYval
                        %((nbJammed(j) > 0) & (nbJammedYval == 0))
                        %(nbJammed(j) > 0) == (nbJammedYval > 0)
                        i = i+numbColAnalyze(j);
                        j = j+1;        
                    end
                                       
                    goodNbPredict(o, mod(r,5) + 1, 1) = nbJamCorrectGuessed;
                    goodNbPredict(o, mod(r,5) + 1, 2) = length(numbColAnalyze);
                    nbAttacksDetected(o, mod(r,5) + 1, 1) = attackDetectedOnSDC;
                    nbAttacksDetected(o, mod(r,5) + 1, 2) = length(numbColAnalyze);
                    ratioGoodNbPredict(o, mod(r,5) + 1) = nbJamCorrectGuessed/length(numbColAnalyze);
                    ratioNbAttacksDetected(o, mod(r,5) + 1, 1) = attackDetectedOnSDC/length(numbColAnalyze);
                    falseAlarmsInfo(o, mod(r,5) + 1, 1) = falseAlarms;
                    falseAlarmsInfo(o, mod(r,5) + 1, 2) = length(numbColAnalyze);
                    falseAlarmsInfo(o, mod(r,5) + 1, 3) = falseAlarms/length(numbColAnalyze);
                    
                    printInfos;
                    
                end
           
        end
         
    end
   
    Results.MccScores = MccScores;
    Results.F1Scores = F1Scores;
    Results.TP = TP;
    Results.FP = FP;
    Results.FN = FN;
    Results.TN = TN;
    Results.goodNbPredict = goodNbPredict;
    Results.nbAttacksDetected = nbAttacksDetected;
    Results.ratioGoodNbPredict = ratioGoodNbPredict;
    Results.ratioNbAttacksDetected = ratioNbAttacksDetected;
    Results.falseAlarmsInfo = falseAlarmsInfo;
end

