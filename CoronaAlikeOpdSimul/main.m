[outPowerMean, initPower, positiveError, negativeError, nonlinearLosses, outPower] = iterativePowerSimulation;
% clusterSampleSize, pitchSamplesSize, numOfModels, 16

% % 8 clusters
% % WITHOUT nonlinear loss model
% % diferent pitches
% outPower1 = squeeze(outPower(1, 1, 1, :));
% outPower2 = squeeze(outPower(1, 2, 1, :));
% outPower3 = squeeze(outPower(1, 3, 1, :));
% outPower4 = squeeze(outPower(1, 4, 1, :));
% % WITH nonlinear loss model
% % diferent pitches
% outPower5 = squeeze(outPower(1, 1, 2, :));
% outPower6 = squeeze(outPower(1, 2, 2, :));
% outPower7 = squeeze(outPower(1, 3, 2, :));
% outPower8 = squeeze(outPower(1, 4, 2, :));
% 
% 
% % 16 clusters
% % WITHOUT nonlinear loss model
% % diferent pitches
% outPower9 = squeeze(outPower(2, 1, 1, :));
% outPower10 = squeeze(outPower(2, 2, 1, :));
% outPower11 = squeeze(outPower(2, 3, 1, :));
% outPower12 = squeeze(outPower(2, 4, 1, :));
% % WITH nonlinear loss model
% % diferent pitches
% outPower13 = squeeze(outPower(2, 1, 2, :));
% outPower14 = squeeze(outPower(2, 2, 2, :));
% outPower15 = squeeze(outPower(2, 3, 2, :));
% outPower16 = squeeze(outPower(2, 4, 2, :));
% 
% 
% % 24 clusters
% % WITHOUT nonlinear loss model
% % diferent pitches
% outPower17 = squeeze(outPower(3, 1, 1, :));
% outPower18 = squeeze(outPower(3, 2, 1, :));
% outPower19 = squeeze(outPower(3, 3, 1, :));
% outPower20 = squeeze(outPower(3, 4, 1, :));
% % WITH nonlinear loss model
% % diferent pitches
% outPower21 = squeeze(outPower(3, 1, 2, :));
% outPower22 = squeeze(outPower(3, 2, 2, :));
% outPower23 = squeeze(outPower(3, 3, 2, :));
% outPower24 = squeeze(outPower(3, 4, 2, :));

wo_nonlinear = initPower(:, :, 1);
w_nonlinear = initPower(:, :, 2);