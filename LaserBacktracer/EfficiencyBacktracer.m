close all;
clc;
clear;

% ------------------------------------------------------------
%                      User Configuration
% ------------------------------------------------------------

linearLoss_dB = 1.5;            % dB
TPA = 0.8e-9;                   % cm/GW
FCA = 1.45e-17;                 % cm2
lifetime = 10e-9;               % s
Aeff = 0.0662536e-8;            % (cm^2), um^2 -> 1e-8cm^2
powerPerWavelength_W = 1e-3;    % W

% ------------------------------------------------------------
%                    End of User Configuration
% ------------------------------------------------------------

linearLoss = (linearLoss_dB/10) * log(10);
ode = @(z,intensity) PowerBacktracer(z,intensity,linearLoss,TPA,FCA,lifetime);

generateFrameList = @(A,S,N) A+S*(0:N-1);
length0 = 0.0001;
lengthStep = 0.01;  % cm
numSamples = 400;   % number of collected data points
lengthList = generateFrameList(length0,lengthStep,numSamples);
% An efficiency plot with only the linear loss
figure(1)
plot(lengthList, 100*10.^(-lengthList*linearLoss_dB/10),'DisplayName',"w/o nonlinear loss")
hold on;
figure(2)
plot(lengthList, -lengthList*linearLoss_dB,'DisplayName',"w/o nonlinear loss")
hold on;

for numWavelengths = 5 : 3 : 20
    efficiency = zeros(1,10);
    efficiencyIndex = 1;
    for sampleIndex = 1:numSamples
        waveguideLength = lengthList(sampleIndex);
        zspan = [0 waveguideLength];
        coupledOutPower_W = powerPerWavelength_W * numWavelengths;
        coupledOutIntensity = coupledOutPower_W / Aeff;  % W/cm2

        [z,intensity] = ode45(ode,zspan,coupledOutIntensity);
        coupledInPower_W = intensity(length(intensity))*Aeff;
        efficiency(efficiencyIndex) = coupledOutPower_W / coupledInPower_W;
        efficiencyIndex = efficiencyIndex + 1;
    end
    figure(1)
    plot(lengthList,efficiency*100,'DisplayName',numWavelengths*powerPerWavelength_W*1e3 + " mW");
    figure(2)
    efficiency_dB = 10*log10(efficiency);
    plot(lengthList,efficiency_dB,'DisplayName',numWavelengths*powerPerWavelength_W*1e3 + " mW");
end
% Figure 1 --- in percentage
figure(1)
title("transmission efficiency with fixed OUTPUT power")
xlabel("waveguide length (cm)")
ylabel("efficiency (%)")
legend()
% Figure 2 --- in decibel
figure(2)
title("transmission efficiency with fixed OUTPUT power")
xlabel("waveguide length (cm)")
ylabel("efficiency (dB)")
axis([0 inf -30 0])
legend()