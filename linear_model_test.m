% This script is for calculating the input power given the required output power, cluster number and pitches.
% Inputs
numOfClusters = 24;
requiredPowerPerCluster = 0.86711;				% mW
pitchSamples = [0.05 0.1 0.15 0.2];                 % cm
pitch0Samples = 0.5*pitchSamples;                 % cm

% Parameters
gratingCouplerLoss = 1.5;             % dB
splitterExcessLoss = 0.2;             % dB
linearPropagationLoss = 1.5;          % dB/cm

% Calculation
initPower = zeros(1, length(pitchSamples));
for pitchIndex = 1:length(pitchSamples)
	pitch = pitchSamples(pitchIndex);
	pitch0 = pitch0Samples(pitchIndex);
    curPower = requiredPowerPerCluster;
	for i = 1:numOfClusters
        if (i == numOfClusters)
		% The first segment is shorter than the others
			lossForCurSeg = pitch0*linearPropagationLoss + splitterExcessLoss;        %dB
			powerBeforeCurSeg = curPower * 10^(lossForCurSeg/10);
		else
			lossForCurSeg = pitch*linearPropagationLoss + splitterExcessLoss;         %dB
			powerBeforeCurSeg = curPower * 10^(lossForCurSeg/10);
			powerAugmengt = requiredPowerPerCluster * 10^(splitterExcessLoss/10);
			powerBeforeCurSeg = powerBeforeCurSeg + powerAugmengt;
        end
        curPower = powerBeforeCurSeg;
	end
	powerBeforeCurSeg = powerBeforeCurSeg * 10^(gratingCouplerLoss/10);
	initPower(pitchIndex) = powerBeforeCurSeg;
end
	