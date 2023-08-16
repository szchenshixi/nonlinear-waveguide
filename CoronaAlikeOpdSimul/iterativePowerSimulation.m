function [outPowerMean, initPower, positiveError, negativeError, nonlinearLosses, outPower] = iterativePowerSimulation
a = 0;
simulConfig;

clusterSampleSize = length(clusterSamples);
pitchSamplesSize = length(pitchSamples);
numOfModels = 2;        % linear loss model/nonlinear loss model

initPower = zeros(clusterSampleSize, pitchSamplesSize, numOfModels);
outPowerMean = zeros(clusterSampleSize, pitchSamplesSize, numOfModels);
outPower = zeros(clusterSampleSize, pitchSamplesSize, numOfModels, clusterSamples(length(clusterSamples)));
% overallEfficiency = zeros(clusterSampleSize, pitchSamplesSize, numOfModels);
positiveError = zeros(clusterSampleSize, pitchSamplesSize, numOfModels);
negativeError = zeros(clusterSampleSize, pitchSamplesSize, numOfModels);
nonlinearLosses = zeros(clusterSampleSize, pitchSamplesSize, numOfModels);  % mW

numClusters = 0;
for clusterSampleIndex = 1 : clusterSampleSize
    a = a + 1;
    b = 0;
    % If a different cluster size is tested
%     if(clusterSamples(clusterSampleIndex) ~= numClusters)
        power0_mW = power0Samples(clusterSampleIndex);
        numClusters = clusterSamples(clusterSampleIndex);
%     end
    % Only initialize power0_mW in the first loop of choosing sample size.
    % The next loops will need larger power0_mW in each iteration.
    for pitchSamplesIndex = 1 : pitchSamplesSize
        b = b + 1;
        pitches = [pitch0Samples(pitchSamplesIndex) pitchSamples(pitchSamplesIndex)];
%         for isNonlinearModelEnabled = 0 : numOfModels - 1
%             c = c + 1;
        % isNonlinearModelEnabled       % Choose whether or not to use nonlinear loss model
                                        %   0 - disable nonlienar loss model
                                        %   1 - enable nonlinear loss model
        c = 0;
        for isNonlinearModelEnabled = 0 : numOfModels - 1
           c = c + 1;
           display("clusters: " + numClusters + ", pitch: " + pitches(2) + "mm, nonlinear: " + isNonlinearModelEnabled + ". Started" )     
           while 1
%            if (numClusters >= 24) && (isNonlinearModelEnabled == 1) % In this case the power delivery failed
                if (isNonlinearModelEnabled == 0) % Use the linear tools for the linear model estimation
                   initPower(a, b, c) = +inf;
                   display("clusters: " + numClusters + ", pitch: " + pitches(2) + "mm, nonlinear: " + isNonlinearModelEnabled + ". Skipped" )
                  break;  
                end
                [clusterPowerOut, nonlinearLoss] = powerSimulation(numClusters, power0_mW, pitches, isNonlinearModelEnabled);
                if sum(clusterPowerOut) > minTotalPower(clusterSampleIndex)
                    initPower(a, b, c) = power0_mW;
                    for i = 1:length(clusterPowerOut)
                           outPower(a, b, c, i) = clusterPowerOut(i);
                    end
                    outPowerMean(a, b, c) = mean(clusterPowerOut);
                    positiveError(a, b, c) = max(clusterPowerOut) - mean(clusterPowerOut);
                    negativeError(a, b, c) = mean(clusterPowerOut) - min(clusterPowerOut);
                    nonlinearLosses(a, b, c) = nonlinearLoss;
                    break;
                end
%                 power0_mW = 1.002*power0_mW;
                power0_mW = 1.01*power0_mW;
                % If the input power is already 10 times more than the
                % required output. Abort this trial and set initPower to
                % infinity.
                if(power0_mW > 50 * minTotalPower(clusterSampleIndex))
                    initPower(a, b, c) = -power0_mW;    % Negative means failure
                    for i = 1:length(clusterPowerOut)
                           outPower(a, b, c, i) = clusterPowerOut(i);
                    end
                    outPowerMean(a, b, c) = mean(clusterPowerOut);
                    positiveError(a, b, c) = max(clusterPowerOut) - mean(clusterPowerOut);
                    negativeError(a, b, c) = mean(clusterPowerOut) - min(clusterPowerOut);
                    nonlinearLosses(a, b, c) = nonlinearLoss;
                    break;
                end
           end
            display("clusters: " + numClusters + ", pitch: " + pitches(2) + "mm, nonlinear: " + isNonlinearModelEnabled + ". Finished")
        end
    end
end

% % data with 5 OPEs
% OPE_5_meanValue = squeeze(meanValue(2,:,:));
% OPE_5_positiveError = squeeze(positiveError(2,:,:));
% OPE_5_negativeError = squeeze(negativeError(2,:,:));
% OPE_5_overallEfficiency = squeeze(overallEfficiency(2,:,:));
% 
% % % data with 2mm pitch
% % pitch_2_meanValue = squeeze(meanValue(:,:,6))';
% % pitch_2_positiveError = squeeze(positiveError(:,:,6))';
% % pitch_2_negativeError = squeeze(negativeError(:,:,6))';
% % pitch_2_overallEfficiency = squeeze(overallEfficiency(:,:,6))';
% 
% % data with 12mm waveguide
% length_12_meanValue = squeeze(meanValue(:,:,4))';
% length_12_positiveError = squeeze(positiveError(:,:,4))';
% length_12_negativeError = squeeze(negativeError(:,:,4))';
% length_12_overallEfficiency = squeeze(overallEfficiency(:,:,4))';