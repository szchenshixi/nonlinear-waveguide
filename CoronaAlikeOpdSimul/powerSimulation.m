% Assume different wavelengths have a same TPA coefficient and FCA
% coefficient. Both outputs are in unit of mW.
function [clusterPowerOut, nonlinearLoss] = powerSimulation(numClusters, power0_mW, pitches, isNonlinearModelEnabled, splittingRatios)
% reading deviace parameters from scripts
devicePara;
zspan0 = [0 pitches(1)];    % The distance between grating coupler and the first cluster. Length of the first segment of waveguide.
zspan = [0 pitches(2)];     % The pitch between two clusters
intensityInit = power0_mW * 1e-3 / Aeff;              % W/cm^2
clusterPowerOut = zeros(1,numClusters);      % The output power of each OPE per input (two inputs in this model
linearLosses = zeros(1,3);             % linear_losses(1): Grating coupler loss
                                        % linear_losses(2): Linear propagation loss
                                        % linear_losses(3): Splitter loss

intensitySeg = zeros(1,numClusters);         % The  power intensity entering each segment of waveguide
if (nargin < 5) % the last argument is optional
    splittingRatios = particalSwarmOptimization(numClusters, power0_mW, pitches, isNonlinearModelEnabled);
end

% OPI injection loss
intensitySeg(1) = intensityInit * injection_loss_per_coupler;
% display("injection_loss_per_OPI: " + injection_loss_per_OPI)
linearLosses(1) = intensityInit - intensitySeg(1);    % W/cm^2

for iter = 1:numClusters
    if(iter == 1)    % The first segment of the waveguide
        [intensityTrace, z] = twoPortWaveguide(zspan0,intensitySeg(iter),isNonlinearModelEnabled);
        linear_propagation_loss = 10^(-(linear_propagation_loss)*zspan0(1)/10);   % in percentage(e.g. 0.92)
    else
        [intensityTrace, z] = twoPortWaveguide(zspan,intensitySeg(iter),isNonlinearModelEnabled);
        linear_propagation_loss = 10^(-(linear_propagation_loss)*zspan0(2)/10);   % in percentage(e.g. 0.92)
    end
%     plot(z*10, intensityTrace*Aeff*1e3)
%     xlabel("propagation distance (mm)")
%     ylabel("optical power (mW)")
    
    outIntensity = intensityTrace(length(intensityTrace));
    clusterPowerOut(iter) = outIntensity * splittingRatios(iter) * splitter_loss * Aeff * 1e3;  % mW
    intensitySeg(iter+1) = outIntensity * (1 - splittingRatios(iter)) * splitter_loss;    % W/cm^2
    % Loss accumulators
    linearLosses(2) = linearLosses(2) + intensitySeg(iter) * (1-linear_propagation_loss);      %W/cm^2
    linearLosses(3) = linearLosses(3) + outIntensity * (1-splitter_loss); %W/cm^2
end
linearLosses = linearLosses * Aeff * 1e3;         % mW
nonlinearLoss = power0_mW - sum(clusterPowerOut) - sum(linearLosses);
% display("initial power(mW): " + intensity0_init*Aeff*1e3)
% display("total output power(mW): " + sum(OPE_power_out))
% figure(2)
% stem(1:num_OPEs, OPE_power_out)
% title("ejected optical power at each OPE")
% xlabel("OPE number")
% ylabel("ejcted optical power (mW)")
% power = intensity1 .* Aeff .*1e3;
% power = flip(power);


% pwr1_W = 10^(15/10) * 1e-3;                  % W
% pwr2_W = 10^(5/10) * 1e-3;                   % W
% intensity1_init = pwr1_W / Aeff;             % W/cm^2
% intensity2_init = pwr2_W / Aeff;             % W/cm^2
% [intensity1,intensity2,z] = four_port_power_waveguide(zspan,intensity1_init,intensity2_init);
% 
% plot(z,intensity1*Aeff*1e3)
% hold on
% plot(z,intensity2*Aeff*1e3)