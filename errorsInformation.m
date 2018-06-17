nbContainingNoErrors = 0;
nbWithGoodNumberOfJammedCollisions = 0;
nbJLCol = 0;
goodNumberJammedCollisions = [];
errorNumber = [];
sizeCorrect = [];
sizeGoodNb = [];
sizeBad = [];

ratioCorrect = [];
ratioGood = [];
ratioBad = [];

for z = 1 : length(infosSDC)
   sdc = infosSDC{z};
%    yval(sdc.i : sdc.end)
%    sdc.results(:)'
   if yval(sdc.i : sdc.end) == sdc.results(:)'
       nbContainingNoErrors = nbContainingNoErrors + 1; 
       sizeCorrect = [sizeCorrect sdc.nbCol];
       ratioCorrect = [ratioCorrect sdc.nbCol/sdc.nbNotTransmis];

   elseif sum(yval(sdc.i : sdc.end) == 1) == sum(sdc.results(:)' == 1)
       nbWithGoodNumberOfJammedCollisions = nbWithGoodNumberOfJammedCollisions + 1;
       infosSDC{z}.goodResults = yval(sdc.i : sdc.end);
       sizeGoodNb = [sizeGoodNb sdc.nbCol];
       goodNumberJammedCollisions = [goodNumberJammedCollisions z];
       ratioGood = [ratioGood sdc.nbNotTransmis/sdc.nbCol];
   else
       nbJLCol = nbJLCol - sum(yval(sdc.i : sdc.end) == 1) + sum(sdc.results(:)' == 1);
       errorNumber = [errorNumber z];
       infosSDC{z}.goodResults = yval(sdc.i : sdc.end);
       sizeBad = [sizeBad sdc.nbCol];
       ratioBad = [ratioBad sdc.nbNotTransmis/sdc.nbCol];
   end
    
end

meanNbCol = mean(cellfun(@(x) x.nbCol, infosSDC));
sdNbCol = var(cellfun(@(x) x.nbCol, infosSDC))^0.5;
maxNbCol = max(cellfun(@(x) x.nbCol, infosSDC));
meanNbNotTransmitted = mean(cellfun(@(x) x.nbNotTransmis, infosSDC));
sdNbNotTransmitted = var(cellfun(@(x) x.nbNotTransmis, infosSDC))^0.5;
maxNbNotTransmit = max(cellfun(@(x) x.nbNotTransmis, infosSDC));


nbWithErrors = length(infosSDC) - nbContainingNoErrors;
fprintf('\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%%% STATS RESULTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n');
fprintf('Number of SDC containing no errors (1): %d/%d\n', nbContainingNoErrors, length(infosSDC));
fprintf('mean-std-max of collisions in a sdc: %f/%f  M=%d\n', meanNbCol, sdNbCol, maxNbCol);
fprintf('mean-std-max of vehicles involved in a sdc: %f/%f M=%d\n', meanNbNotTransmitted, sdNbNotTransmitted, maxNbNotTransmit);

fprintf('SDC containing errors: %d\n', nbWithErrors);
fprintf('\tNumber of SDC with correct number of jammed collisions (2): %d/%d \n', nbWithGoodNumberOfJammedCollisions, nbWithErrors);
fprintf('\tWith no correct number of JC, mean difference between nb JC predict and actual nb JC (3): %f\n', nbJLCol/ (nbWithErrors - nbWithGoodNumberOfJammedCollisions));

fprintf('mean-std-max nb of collisions in (1) (2) and (3): %f/%f/%d   %f/%f/%d   %f/%f/%d\n', mean(sizeCorrect), var(sizeCorrect).^0.5, max(sizeCorrect), ...
                                                mean(sizeGoodNb), var(sizeGoodNb).^0.5, max(sizeGoodNb), mean(sizeBad), var(sizeBad).^0.5, max(sizeBad));
                                            
fprintf('mean-std-max ratio of nbCol/nbVeh in (1) (2) and (3): %f/%f/%d   %f/%f/%d   %f/%f/%d\n', mean(ratioCorrect), var(ratioCorrect).^0.5, max(ratioCorrect), ...
                                                mean(ratioGood), var(ratioGood).^0.5, max(ratioGood), mean(ratioBad), var(ratioBad).^0.5, max(ratioBad));                                            


